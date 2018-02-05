.. _oneg:

================================================================================
OpenNebula hybrid Driver
================================================================================

Description
================================================================================

Cloud bursting is a model in which the local resources of a Private Cloud are combined with resources from remote Cloud providers. This driver offers the possibility to implement Cloud bursting by deploying Virtual Machines seamlessly on a remote OpenNebula installation.

OpenNebula Configuration
================================================================================

Configure the remote OpenNebula
--------------------------------------------------------------------------------

Ask the remote OpenNebula administrator to create a new user for you. This user should have access to VM Templates ready to be instantiated.

Configure the local Host
--------------------------------------------------------------------------------

First create a new Host with `im` and `vm` drivers set to `opennebula`.

Add a new attributes within local host template:

.. code::

    ONE_USER=<remote_username>
    ONE_PASSWORD=<remote_password>
    ONE_ENDPOINT=<remote_endpoint>
    ONE_CAPACITY=[
        CPU=0,
        MEMORY=0
    ]

Capacity is taken from the user and group quotas of the remote OpenNebula user. Alternatively, you can set a hard limit here

Create a local hybrid VM Template
--------------------------------------------------------------------------------

Your hybrid VM Template must contain this section. Set TEMPLATE_ID to the target VM Template ID in the **remote OpenNebula**.

.. code::

    PUBLIC_CLOUD=[
    TEMPLATE_ID=<remote_template_id>,
    TYPE="opennebula" ]


If this Template does not define a local disk and must be deployed only in the remote OpenNebula instance, add this requirement:

.. code::

    SCHED_REQUIREMENTS = "PUBLIC_CLOUD = YES"

To match the reported allocated Host resources with the actual usage in the remote OpenNebula, set the same CPU and MEMORY as the remote Template.
