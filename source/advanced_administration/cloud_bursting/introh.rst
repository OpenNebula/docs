.. _introh:

===============
Cloud Bursting
===============

Cloud bursting is a model in which the local resources of a Private Cloud are combined with resources from remote Cloud providers. The remote provider could be a commercial Cloud service, such as Amazon EC2, IBM SoftLayer or Microsoft Azure, or a partner infrastructure running a different OpenNebula instance. Such support for cloud bursting enables highly scalable hosting environments.

|image0|

As you may know, OpenNebula’s approach to cloud bursting is quite unique. The reason behind this uniqueness is the transparency to both end users and cloud administrators to use and maintain the cloud bursting functionality. The **transparency to cloud administrators** comes from the fact that a AWS EC2 region, SoftLayer datacenter or an Azure location is modelled as any other host (albeit of potentially a much bigger capacity), so the scheduler can place VMs in the external cloud as it will do in any other local host. For instance, in EC2:

.. code::

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       2 kvm-            -           0       0 / 800 (0%)      0K / 16G (0%) on
       3 kvm-1           -           0       0 / 100 (0%)     0K / 1.8G (0%) on
       4 us-east-1       ec2         0       0 / 500 (0%)     0K / 8.5G (0%) on

On the other hand, the **transparency to end users** is offered through the hybrid template functionality: the same VM template in OpenNebula can describe the VM if it is deployed locally and also if it gets deployed in EC2, SoftLayer or Azure. So users just have to instantiate the template, and OpenNebula will transparently choose if that is executed locally or remotely. A simple template like the following is enough to launch Virtual Machines in EC2:

.. code::

    NAME=ec2template
    CPU=1
    MEMORY=1700

    EC2=[
      AMI="ami-6f5f1206",
      BLOCKDEVICEMAPPING="/dev/sdh=:20",
      INSTANCETYPE="m1.small",
      KEYPAIR="gsg-keypair" ]

    SCHED_REQUIREMENTS="PUBLIC_CLOUD=YES"

.. code::

    $ onetemplate create ec2template.one
    ID: 112
    $ onetemplate instantiate 112
    VM ID: 234

For more information on how to configure an Amazon EC2 host see the following guide:

-  :ref:`Amazon EC2 driver <ec2g>`

For more information on how to configure a SoftLayer host see the following guide:

-  :ref:`SoftLayer driver <slg>`

For more information on how to configure an Azure host see the following guide:

-  :ref:`Azure driver <azg>`

.. |image0| image:: /images/hybridcloud.png
