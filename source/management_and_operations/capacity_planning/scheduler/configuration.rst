.. _scheduler_configuration:

================================================================================
Scheduler Configuration
================================================================================

The OpenNebula scheduler is a configurable component that determines how Virtual Machines (VMs) are allocated and migrated across the infrastructure. This section describes the relevant configuration parameters found in ``oned.conf`` that control the scheduler behavior.

Scheduler Driver Configuration
--------------------------------------------------------------------------------
The ``SCHED_MAD`` parameter specifies the scheduler driver responsible for managing scheduling operations. The configuration includes:

- **EXECUTABLE**: The path to the scheduler driver executable. This can be either an absolute path or a relative path to ``/usr/lib/one/mads/``.
- **ARGUMENTS**: A set of arguments passed to the scheduler driver:

  - ``-t``: Number of threads, i.e., the number of concurrent scheduling operations.
  - ``-p``: Scheduler used for initial VM placement:

    - ``rank``: The default OpenNebula matchmaking algorithm.
    - ``one_drs``: Optimizes VM placement and balances cluster load.

  - ``-o``: Scheduler used for cluster-wide VM optimization:

    - ``one_drs``: Optimizes VM placement and balances cluster load.

Example configuration:

.. code-block:: bash

    SCHED_MAD = [
          EXECUTABLE = "one_sched",
          ARGUMENTS  = "-t 15 -p rank -o one_drs"
    ]

Scheduler Window
--------------------------------------------------------------------------------
OpenNebula schedules VMs in batches using a scheduling window. A placement request is sent to the scheduler when:

- The scheduling window remains open for longer than ``SCHED_MAX_WND_TIME`` seconds.
- The number of pending VMs exceeds ``SCHED_MAX_WND_LENGTH``.

Once either of these conditions is met, the scheduler processes the accumulated VM placement requests.

Example configuration:

.. code-block:: bash

    SCHED_MAX_WND_TIME   = 10
    SCHED_MAX_WND_LENGTH = 7

Retrying Failed Placements
--------------------------------------------------------------------------------
If a VM cannot be placed due to insufficient resources, the scheduler retries the allocation after ``SCHED_RETRY_TIME`` seconds.

Example configuration:

.. code-block:: bash

    SCHED_RETRY_TIME = 60

Action Limits
--------------------------------------------------------------------------------
The scheduler limits the number of deploy and migration actions that can be performed simultaneously on a given host or cluster to prevent resource overload.

- ``MAX_ACTIONS_PER_HOST``: Maximum number of scheduled actions per host.
- ``MAX_ACTIONS_PER_CLUSTER``: Maximum number of scheduled actions per cluster.

Example configuration:

.. code-block:: bash

    MAX_ACTIONS_PER_HOST    = 1
    MAX_ACTIONS_PER_CLUSTER = 30

Action Timeout
--------------------------------------------------------------------------------
The ``ACTION_TIMEOUT`` parameter defines the maximum time (in seconds) that a scheduled action can remain pending before being marked as a failure.

Example configuration:

.. code-block:: bash

    ACTION_TIMEOUT = 300

Live and Cold Migrations
--------------------------------------------------------------------------------
- ``LIVE_RESCHEDS``: Defines whether VM rescheduling should use live migrations (``1``) or cold migrations (``0``).
- ``COLD_MIGRATE_MODE``: Specifies the type of cold migration:
  - ``0`` = Save (default)
  - ``1`` = Power off
  - ``2`` = Hard power off

Example configuration:

.. code-block:: bash

    LIVE_RESCHEDS     = 0
    COLD_MIGRATE_MODE = 0

OpenNebula Distributed Resource Scheduler (DRS)
--------------------------------------------------------------------------------
OneDRS periodically optimizes cluster load balancing. The ``DRS_INTERVAL`` parameter controls how frequently (in seconds) DRS actions are performed. Setting ``DRS_INTERVAL`` to ``-1`` disables automatic DRS operations.

Example configuration:

.. code-block:: bash

    DRS_INTERVAL = 600

This is an example configuration snippet from ``/etc/one/oned.conf``:

.. code-block:: ini

    SCHED_MAD = [
          EXECUTABLE = "one_sched",
          ARGUMENTS  = "-t 15 -p rank -o one_drs"
    ]

    SCHED_MAX_WND_TIME   = 10
    SCHED_MAX_WND_LENGTH = 7

    SCHED_RETRY_TIME = 60

    MAX_ACTIONS_PER_HOST    = 1
    MAX_ACTIONS_PER_CLUSTER = 30

    ACTION_TIMEOUT = 300

    LIVE_RESCHEDS     = 0
    COLD_MIGRATE_MODE = 0

    DRS_INTERVAL = -1

