.. _appflow_elasticity:

================================================================================
OneFlow Services Auto-scaling
================================================================================

A Service Role's cardinality can be adjusted manually, based on metrics, or based on a schedule.

Overview
========

When a scaling action starts, the Role and Service enter the ``SCALING`` state. In this state, the Role will ``instantiate`` or ``terminate`` a number of VMs to reach its new cardinality.

A Role with elasticity policies must define a minimum and maximum number of VMs:

.. code-block:: javascript

    "roles": [
        {
          "name": "frontend",
          "cardinality": 1,
          "vm_template": 0,
     
          "min_vms" : 1,
          "max_vms" : 5,
    ...

After the scaling, the Role and Service are in the ``COOLDOWN`` state for the configured duration. During a scale operation and the cooldown period, other scaling actions for the same or for other Roles are delayed until the Service is ``RUNNING`` again.

Set the Cardinality of a Role Manually
======================================

The command ``oneflow scale`` starts the scalability immediately.

.. prompt:: text $ auto

    $ oneflow scale <serviceid> <role_name> <cardinality>

You can force a cardinality outside the defined range with the ``--force`` option.

Maintain the Cardinality of a Role
==================================

The 'min_vms' attribute is a hard limit, enforced by the elasticity module. If the cardinality drops below this minimum, a scale-up operation will be triggered.

Set the Cardinality of a Role Automatically
===========================================

Auto-scaling Types
------------------

Both elasticity_policies and scheduled_policies elements define an automatic adjustment of the Role cardinality. Three different adjustment types are supported:

-  **CHANGE**: Add/subtract the given number of VMs
-  **CARDINALITY**: Set the cardinality to the given number
-  **PERCENTAGE_CHANGE**: Add/subtract the given percentage to the current cardinality

+---------------------+-----------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Attribute           | Type      | Mandatory   | Description                                                                                                                                                          |
+=====================+===========+=============+======================================================================================================================================================================+
| type                | string    | Yes         | Type of adjustment. Values: CHANGE, CARDINALITY, PERCENTAGE\_CHANGE                                                                                                  |
+---------------------+-----------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| adjust              | integer   | Yes         | Positive or negative adjustment. Its meaning depends on 'type'                                                                                                       |
+---------------------+-----------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| min\_adjust\_step   | integer   | No          | Optional parameter for PERCENTAGE\_CHANGE adjustment type. If present, the policy will change the cardinality by at least the number of VMs set in this attribute.   |
+---------------------+-----------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Auto-scaling Based on Metrics
-----------------------------

Each Role can have an array of ``elasticity_policies``. These policies define an expression that will trigger a cardinality adjustment.

These expressions can use performance data from

-  The VM guest. Using the :ref:`OneGate server <onegate_usage>`, applications can send custom monitoring metrics to OpenNebula.
-  The VM, at hypervisor level. The :ref:`Virtualization Drivers <vmmg>` return information about the VM, such as ``CPU``, ``NETTX`` and ``NETRX``.

.. code-block:: javascript

      "elasticity_policies" : [
        {
          "expression" : "ATT > 50",
          "type" : "CHANGE",
          "adjust" : 2,
     
          "period_number" : 3,
          "period" : 10
        },
        ...
      ]

The **expression** can use VM attribute names, float numbers, and logical operators (!, &, \|). When an attribute is found, it will take the **average** value for all the **running VMs** that contain that attribute in the Role. If none of the VMs contain the attribute, the expression will evaluate to false.

The attribute will be looked for in ``/VM/USER_TEMPLATE``, ``/VM/MONITORING``, ``/VM/TEMPLATE`` and ``/VM``, in that order. Logical operators have the usual precedence.

+------------------+-----------+-------------+-----------------------------------------------------------------------------------------+
| Attribute        | Type      | Mandatory   | Description                                                                             |
+==================+===========+=============+=========================================================================================+
| expression       | string    | Yes         | Expression to trigger the elasticity                                                    |
+------------------+-----------+-------------+-----------------------------------------------------------------------------------------+
| period\_number   | integer   | No          | Number of periods that the expression must be true before the elasticity is triggered   |
+------------------+-----------+-------------+-----------------------------------------------------------------------------------------+
| period           | integer   | No          | Duration, in seconds, of each period in period\_number                                  |
+------------------+-----------+-------------+-----------------------------------------------------------------------------------------+

Auto-scaling Based on a Schedule
--------------------------------

Combined with the elasticity policies, each Role can have an array of ``scheduled_policies``. These policies define a time, or a time recurrence, and a cardinality adjustment.

.. code-block:: javascript

      "scheduled_policies" : [
        {
          // Set cardinality to 2 each 10 minutes
          "recurrence" : "*/10 * * * *",
     
          "type" : "CARDINALITY",
          "adjust" : 2
        },
        {
          // +10 percent at the given date and time
          "start_time" : "2nd oct 2017 15:45",
     
          "type" : "PERCENTAGE_CHANGE",
          "adjust" : 10
        }
      ]

+---------------+----------+-------------+-----------------------------------------------------------------------------------------------------------------------+
| Attribute     | Type     | Mandatory   | Description                                                                                                           |
+===============+==========+=============+=======================================================================================================================+
| recurrence    | string   | No          | Time for recurring adjustements. Time is specified with the `Unix cron sytax <http://en.wikipedia.org/wiki/Cron>`__   |
+---------------+----------+-------------+-----------------------------------------------------------------------------------------------------------------------+
| start\_time   | string   | No          | Exact time for the adjustement                                                                                        |
+---------------+----------+-------------+-----------------------------------------------------------------------------------------------------------------------+

Visualize in the CLI
====================

The ``oneflow show / top`` commands show the defined policies. When a Service is scaling, the VMs being created or terminated can be identified by an arrow next to their ID:

.. code::

    SERVICE 7 INFORMATION                                                           
    ...

    ROLE frontend
    ROLE STATE          : SCALING             
    CARNIDALITY         : 4                   
    VM TEMPLATE         : 0                   
    NODES INFORMATION
     VM_ID NAME                    STAT UCPU    UMEM HOST                       TIME
         4 frontend_0_(service_7)  runn    0   74.2M host03                 0d 00h04
         5 frontend_1_(service_7)  runn    0  112.6M host02                 0d 00h04
       ↑ 6                         init           0K                        0d 00h00
       ↑ 7                         init           0K                        0d 00h00

    ELASTICITY RULES
    MIN VMS             : 1                   
    MAX VMS             : 5                   

    ADJUST       EXPRESSION                                        EVALUATION PERIOD
    + 2          (ATT > 50) && !(OTHER_ATT = 5.5 || ABC <= 30)     0 / 3         10s
    - 10 % (2)   ATT < 20                                          0 / 1          0s

    ADJUST       TIME                                                               
    = 6          0 9 * * mon,tue,wed,thu,fri
    = 10         0 13 * * mon,tue,wed,thu,fri
    = 2          30 22 * * mon,tue,wed,thu,fri


    LOG MESSAGES                                                                    
    06/10/13 18:22 [I] New state: DEPLOYING
    06/10/13 18:22 [I] New state: RUNNING
    06/10/13 18:26 [I] Role frontend scaling up from 2 to 4 nodes
    06/10/13 18:26 [I] New state: SCALING

Interaction with Individual VM Management
=========================================

All the VMs created by a Service can be managed as regular VMs. When VMs are monitored in an unexpected state, this is what OneFlow interprets:

-  VMs in a recoverable state ('suspend', 'poweroff', etc.) are considered healthy machines. The user will eventually decide to resume these VMs, so OneFlow will keep monitoring them. For the elasticity module, these VMs are just like 'running' VMs.
-  VMs in the final 'done' state are cleaned from the Role. They do not appear in the nodes information table, and the cardinality is updated to reflect the new number of VMs. This can be seen as an manual scale-down action.
-  VMs in 'unknown' or 'failed' are in an anomalous state, and the user must be notified. The Role and Service are set to the 'WARNING' state.

|image1|

Examples
========

.. code-block:: javascript

    /*
    Testing:
     
    1) Update one VM template to contain
    ATT = 40
    and the other VM with
    ATT = 60
     
    Average will be 50, true evaluation periods will not increase in CLI output
     
    2) Increase first VM ATT value to 45. True evaluations will increase each
    10 seconds, the third time a new VM will be deployed.
     
    3) True evaluations are reset. Since the new VM does not have ATT in its
    template, the average will be still bigger than 50, and new VMs will be
    deployed each 30s until the max of 5 is reached.
     
    4) Update VM templates to trigger the scale down expression. The number of
    VMs is adjusted -10 percent. Because 5 * 0.10 < 1, the adjustment is rounded to 1;
    but the min_adjust_step is set to 2, so the final adjustment is -2 VMs.
    */
    {
      "name": "Scalability1",
      "deployment": "none",
      "roles": [
        {
          "name": "frontend",
          "cardinality": 2,
          "vm_template": 0,
     
          "min_vms" : 1,
          "max_vms" : 5,
     
          "elasticity_policies" : [
            {
              // +2 VMs when the exp. is true for 3 times in a row,
              // separated by 10 seconds
              "expression" : "ATT > 50",
     
              "type" : "CHANGE",
              "adjust" : 2,
     
              "period_number" : 3,
              "period" : 10
            },
            {
              // -10 percent VMs when the exp. is true.
              // If 10 percent is less than 2, -2 VMs.
              "expression" : "ATT < 20",
     
              "type" : "PERCENTAGE_CHANGE",
              "adjust" : -10,
              "min_adjust_step" : 2
            }
          ]
        }
      ]
    }

.. code-block:: javascript

    {
      "name": "Time_windows",
      "deployment": "none",
      "roles": [
        {
          "name": "frontend",
          "cardinality": 1,
          "vm_template": 0,
     
          "min_vms" : 1,
          "max_vms" : 15,
     
          // These policies set the cardinality to:
          //  6 from  9:00 to 13:00
          // 10 from 13:00 to 22:30
          //  2 from 22:30 to 09:00, and the weekend
     
          "scheduled_policies" : [
            {
              "type" : "CARDINALITY",
              "recurrence" : "0 9 * * mon,tue,wed,thu,fri",
              "adjust" : 6
            },
            {
              "type" : "CARDINALITY",
              "recurrence" : "0 13 * * mon,tue,wed,thu,fri",
              "adjust" : 10
            },
            {
              "type" : "CARDINALITY",
              "recurrence" : "30 22 * * mon,tue,wed,thu,fri",
              "adjust" : 2
            }
          ]
        }
      ]
    }

.. |image1| image:: /images/oneflow-service.png
