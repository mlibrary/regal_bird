# Source

Sources obtain sets of data, generally from an external service.  They minimally
define a single method `#execute` that returns a collection of Events.  These
events are used to create Progress instances. Plans must define at least one
source.

# Action

Action act on individual items.  They minimally define a single method `#execute`
that returns a single Event.  This Event is used to update a Progress instance.
Even failures or no-ops are considered Events.  Actions are able to access the
Progress's EventLog, which contains information about the item and any work
performed on it so far.

