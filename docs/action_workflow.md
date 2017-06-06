# Action Workflow

## Overview

1. Static schedule enqueues ActionSchedulerJob
2. ActionScheduler enqueues ActionJobs, each with a Progress id
3. ActionJob finds the Progress instance and passes it to an ActionRunner
3. ActionRunner calls the Progress's `#next` method
4. Progress#next runs the next Action in the Plan
5. The Action returns an Event
6. The Event is added to the Progress's EventLog
7. ActionRunner saves the Progress entity

### Entry

Regal Bird will periodically run an ActionScheduler, as driven by the static schedule.

### ActionScheduler

Simply reponsible for discovering and enqueuing all sources.

```
For each progress in the repository:
  Enqueue an ActionJob with the progress id.
```

### ActionJob

Finds the Progress entity via its id, and passes the instance to ActionRunner.

### ActionRunner

Calls `progress#next`, and saves the progress when it completes.

### Progress#next

The progress instance consults its corresponding Plan, finds the Action to be
performed, and performs the action.  The action returns an Event, which is
appended to the instance's EventLog.

## Ongoing Issues

There is no way to prevent multiple ActionRunner's with the same progress_id
from being executed simultaneously.  Some manner of checkout system seems to
be required.

In order to handle the weirdest case, the job runner should check if a duplicate
job is already running by examining the process, rather than simply checking a flag.
