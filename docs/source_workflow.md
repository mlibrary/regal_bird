# Source Workflow

## Overview

1. Static schedule enqueues SourceSchedulerJob
2. SourceScheduler enqueues SourceJobs
3. SourceRunner invokes user-defined Source
4. Source returns an array of Events
5. SourceRunner wraps events in Progress instances, dedups against
   existing instances, and saves them.

### Entry

Regal Bird will periodically run a SourceScheduler, as driven by the static schedule.

### SourceScheduler

Simply reponsible for discovering and enqueuing all sources.

```
For each plan in the repository:
  For each of the plan's sources:
    Enqueue a SourceJob with the Source class name.
```

### SourceRunner

When a source executes, it returns a collection of Event instances.  These
events will be used to initialize Progress instances.  Notably, these events
may or may not be duplicate.

The SourceRunner will save only those Progress instances that do not already existed,
as defined by `event.data[:id]`.


