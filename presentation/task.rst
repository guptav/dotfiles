===========
Taskwarrior
===========

Display Task::

    task            # List of task 
    task list       # One line per task
    task ls         # 
    task +book      # Task with tag book
    task -book      # Task without tag book
    task completed  # List of completed tasks
    task projects   # List of projects
    task tags       # List of projects
    task summary    # Summary of task
    task timesheet  # Weekly report of task completed
    task 1          # Details of the task 1
    task something  # List of task that matchs with text: something

    task project:fitbit     # List all the task from project fitbit.
    task due.any:           # List of of tasks wit due date

    task +MONTH     # Task due this month
    task calendar   # Task calendar

    task +BLOCKED               # Blocked tasks
    task +BLOCKING              # Blocking tasks
    task +BLOCKING -BLOCKED     # Focus on tasks

    task reports    # List all the possible reports.
    task help       # For help

Adding a task::

    task add "do something0"                    # Adding a task
    task add "do something1" +tag               # Adding a task with tag
    task add "do something2" project:fitbit     # Adding a task to project
    task add "High priority" priority:H         # Adding a task with priority
    task add "Due date" due:2019-01-31          # Adding a task with due date

    task 3 done                         # Marking task 3 done
    task 3 delete                       # Delete task 3
    task 3 modify "do something new"    # Modify a task text
    task 3 modify  +tag                 # Add a tag to task 3
    task 3 modify  project:fitbit       # Move task 3 to project fitbit
    task 3-7 modify +tag1               # Add tag tag1 to task 3 to 7

Annotate::

    task 3 annotate "one line note to a task"

Log ::
    task log "did something"            # Log things completed.

Waiting and Scheduled task::

    task waiting            # List of waiting tasks
    task scheduled          # List of scheduled tasks

    task add "meet john" due:thursday   # Add a task
    task 54 modify wait:due             # Just remind me due date i.e thursday

    task add credit card +pay due:2019-01-12    # Add a task
    task 56 modify schedule:15th                # Schedule it to reminde from 15th

Contexts: Apply filters automatically::

    task context define blog -work      # Define a new context
    task context list                   # List all the context
    task context blog                   # Start blog context.
    task context none                   # remove blog context.

Task dependencies::

    task 78 modify depends:77
    task 77 modify depends:76

Active Task::

    task 72 start           # Start task 72
    task active             # List of active task
    task 72 stop            # Stop task 72
    task 72 done            # Marking task done.

Undo task::

    task undo               # Revert the last change you made.
