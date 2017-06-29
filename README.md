
*This project is not ready for use at this time.*

# Regal Bird
![regal_bird](regal_bird_500.jpg)

Regal Bird is a ruby gem for automating a process as a series of steps, similar to an
ETL service.  It is intended for transactional operations on individual units of work.

## When to use Regal Bird

* You need to send units of data through a process.
* Your process can be represented as a single path through a finite state machine.
* You want a lightweight solution.

## When not to use Regal Bird

* You need to operate on batches of data.
* Your process contains operations that are dependent on two or more operations
  that should be run concurrently, and these cannot just be run in sequence.
* You need to control the order in which the data units are processed (e.g. for a bidding
  system).

# Installation

Regal Bird depends on a RabbitMQ server.

Install like you would any other gem.  Regal Bird is intended to be a dependency of a
domain-specific project that defines the process it will automate, so we recommend simply
including it as a bundled dependency.  As with all gems, installing into the system-wide
gems is not recommended.

# Configuration

Regal Bird is primarily controlled via some rake tasks. To access them:
1. Add `require regal_bird/tasks` to your Rakefile.
2. Set the Regal Bird configuration in the `regal_bird:setup` task. E.g.:
```ruby
task "regal_bird:setup" do
  require "myapp"
  RegalBird.config = RegalBird::Configuration.new(
    plan_dir: path to your plans, e.g. <project_root>/plans,
    connection: a connection string
  )
end
```

See [ruby bunny docs](http://rubybunny.info/articles/connecting.html) for more info on
how to connect to your rabbitmq server. You can leave `connection` blank to simply use
the default parameters.

# Usage

For Regal Bird to be of any use at all, you'll need to both define a plan
and the actions--as ruby classes--to be taken as part of that plan.

## Defining a Plan

Plans are defined with a simple ruby DSL, and consist of three parts. Regal Bird will
load all of the .rb files in your plan directory.

### Part 1: Declaring Sources

The first part of a plan will define one or more sources.  Sources discover units of work
on which the rest of the plan will be carried out.  Most plans will likely only have one
source, but any number of sources can be defined.  Generally, sources should define the
same type of units of work; if you have sources that define different units of work,
then you likely want to separate them into their own plans.

Your plan file should look something like this:

```ruby
RegalBird::Plan.define("name_of_my_plan") do
  source MyDomain::MyFirstSource, 30
  source MyDomain::MyDailySource, 60*60*24
end
```

This example plan declares a source to be run every 30 seconds, and another to be
run once a day. Note that the first time you run a plan, these intervals will pass
before the sources are first run. Afterwards, their scheduled run time is preserved
in RabbitMQ.


### Part 2: Declaring Actions

This makes up the bulk of any plan.  It is simply any number of state:action pairs, where the
state is a string or symbol and the action is a class.  Each unit of work will have the action
run against it that corresponds to the unit's current state.  State:action pairs are a
many-to-one mapping, but note that such branching plans can be complex.

Your plan file should look something like this:

```ruby
RegalBird::Plan.define("cool_plan") do
  # sources
  action :ready,  MyDomain::FooAction, 1
  action :set,    MyDomain::BarAction, 1
  action :go,     MyDomain::BazAction, 1
  action :go,     MyDomain::BooAction, 5
end
```

The above plan defines several actions and the state that causes them to be invoked. The last
argument is the number of workers to create for that operation.  Note that the :go state will
cause two separate actions to occur. Those actions are then completely independent, so a
naive attempt to converge them will result in duplicate work.

Unfortunately, Regal Bird does not support shared workers or worker pools at this time.

### Part 3: Declaring Terminal States

It's likely that you do not want units that have completed or failed to remain in
Regal Bird's docket.  A special action is provided that will remove a unit,
`RegalBird::Action::Clean`.  Please note that if you wish to do something useful
when a unit is in a failed state, it may be useful to represent that.  Your plan might
look like this:

```ruby
RegalBird::Plan.define("foo") do
  # sources...
  # other actions...
  action :cancelled,      MyDomain::LogCancel,      1
  action :logged_cancel,  RegalBird::Action::Clean, 1
end
```

### Putting it all together

Here's a simple plan (that I've intentionally overcomplicated) that emails a
newsletter and sends a Twitter message each day.

```ruby
RegalBird::Plan.define("newsletter_with_twitter") do
  source CoolBlog::Newsletter::GetUsers, 60 * 60 * 24
  action :ready,      CoolBlog::Newsletter::SendEmail,        1
  action :no_email,   RegalBird::Action::Clean,               1
  action :email_sent, CoolBlog::Newsletter::GetTwitterHandle, 1
  action :no_twitter, RegalBird::Action::Clean,               1
  action :got_handle, CoolBlog::Newsletter::SendTwitter,      1
  action :done,       RegalBird::Action::Clean,               1
end
```

## Defining Sources and Actions

### Defining Sources

Short version: Subclass RegalBird::Source, define `#execute` to return an array of
RegalBird:Event instances that carry the data you need.

Sources obtain sets of data, generally from an external service.  A source must define a single
`#execute` method that returns an array of RegalBird::Event instances.  Like this:

```ruby
class GetUsers < RegalBird::Source
  def execute
    start_time = Time.now.utc
    users = User.active
    users.map do |user|
      RegalBird::Event.new(item_id: user.username, state: :ready, emitter: "GetUsers",
        start_time: start_time, end_time: Time.now.utc,
        data: {id: user.name, user: user.email}
      )
    end
  end
end
```

Obviously, this is a bit much, and the above doesn't even handle exceptions.  Regal Bird provides
some convenience methods for you so that the above can be written as below.  This will handle
exceptions automatically (by logging the error).  When a source fails, it is not run again until
its next regularly-scheduled time.

```ruby
class GetUsers < RegalBird::Source
  def execute
    wrap_execution do
      Users.active.map do |user|
        success(user.username, :ready, {email: user.email})
      end
    end
  end
end
```

### Defining Actions

Short version: Subclass RegalBird::Action, define `#execute` to return a single
RegalBird::Event instance.

Defining actions is very similar to defining sources.  Unlike sources, actions can draw upon
information from the previous step in the plan for that unit of work. This information is
represented as a RegalBird::Event, accessible via `#event`. E.g., to get item's id, do
`#event.item_id`. Most likely, you'll want to access previous data that has been recorded; this
can be done via `#event.data`, which will return a hash.

`#event.data` only contains the hash from the most recently emitted RegalBird::Event, so if you
need to forward information for a latter step in your plan, be sure to copy the contents of the
hash to the Event returned by `#execute`.

Please note that only JSON-serializable data can be stored or retrieved from the event.
The event log will handle serialization and deserialization for you.

```ruby
class GetTwitterHandle < RegalBird::Action
  def execute
    start_time = Time.now.utc
      handle = TwitterService.handle(event.data[:email])
      if handle != nil
        RegalBird::Event.new(item_id: event.item_id, state: :handle_found, emitter: self.class.to_s,
          start_time: start_time, end_time: Time.now.utc,
          data: {handle: handle}
        )
      else
        RegalBird::Event.new(item_id: event.item_id, state: :no_twitter, emitter: self.class.to_s,
          start_time: start_time, end_time: Time.now.utc,
          data: {}
        )
      end
  end
end
```

Again, you are *highly encouraged* to use `#wrap_execution` and the other convenience methods.
They clean up the above code, and handle any exceptions raised.  Note that the default
behavior for handling exceptions is to:
 1. Requeue the event
 2. Log the exception to a file log.
 3. Store the error in `#event.data[:error]` for the next action, if needed.

The above can be rewritten as the following:

```ruby
class GetTwitterHandle < RegalBird::Action
   def execute
     wrap_execution do
       if handle != nil
         success(:handle_found, {handle: handle})
       else
         success(:no_twitter, {})
       end
     end
   end
 end
```

This now features the default exception handling behavior.  In addition, there are
two other convenience methods that can be used within `#wrap_execution`:
* `#failure(message or exception)` will perform the failure behavior described above.
* `#noop` for when the action succeeded, but the state did not change.  This is useful
  for checking if an external service has completed an operation.

# Running Regal Bird

As mentioned in the configuration section, Regal Bird provides rake tasks to run its
workers. This infrastructure is persistent, and will survive restarts of both
Regal Bird and rabbitmq-server. As such, when you want to delete all *or part of* a
plan, you should be sure to invoke the `purge[path_to_plan]` rake task, but please
note that this will delete *all* state information currently in the plan.

## More Information

This readme covers most of the functionality, but not all of it.  For that, please
consult the [rubydoc](http://www.rubydoc.info/github/mlibrary/regal_bird/master).

# Contributing

You will need to assign a license to your contribution that is compatible
with the Revised BSD License of the project (see LICENSE.txt).  You are not
required to assign the copyright to the Regents of the University of Michigan.
If you are adding a file, include a copyright notice in the header.


# License

```
Copyright (c) 2017 The Regents of the University of Michigan.
All Rights Reserved.
Licensed according to the terms of the Revised BSD License.
See LICENSE.txt for details.
```
