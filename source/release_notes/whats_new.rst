.. _whats_new:

============================
What's new in OpenNebula 4.4
============================

In the following list you can check the highlights of OpenNebula 4.4 Retina organised by component (`a detailed list of changes can be found here <http://dev.opennebula.org/projects/opennebula/issues?query_id=42>`__):

OpenNebula Core: End-user functionality
---------------------------------------

OpenNebula 4.4 brings multiple new features to manage virtual machines:

-  **Support rename for more resources**, users can now rename `hosts <http://opennebula.org/doc/4.4/cli/onehost.1.html>`__, `vnets <http://opennebula.org/doc/4.4/cli/onevnet.1.html>`__ and `datastores <http://opennebula.org/doc/4.4/cli/onedatastore.1.html>`__.
-  **Improved VM lifecycle**, it is possible to shutdown a VM from the ``unknown`` state. `An updated diagram can be found here <http://opennebula.org/documentation:rel4.4:vm_guide_2#virtual_machine_life-cycle>`__

OpenNebula Core: Internals & Administration Interface
-----------------------------------------------------

There has been also several improvements for administrators and new features to enhance the robustness and scalability of OpenNebula core:

-  **Multiple system datastores**, enables a much more efficient usage of the storage resources for running Virtual Machines. :ref:`Read this to configure and use this new feature <system_ds>`. This opens the possibility to use :ref:`storage policies <schg>`.
-  **Improved quota subsystem**, now with volatile disk support. :ref:`More info here <quota_auth>`.
-  **Multiple group support**, with the ability to define :ref:`primary and secondary groups <manage_users>`.
-  **Improved scalability**, new parameters support in oned.conf for xmlrpc parameters. :ref:`Seek information on how to configure this here <oned_conf>`.
-  **Check free disk space in system datastores**, to prevent deploying a VM in a host with no free space for it. This is taking into account in the :ref:`newly extended scheduling algorithm <schg>`, that now tales storage into account.

OpenNebula Drivers
------------------

The back-end of OpenNebula has been also improved in several areas, as described below:

Storage Drivers
~~~~~~~~~~~~~~~

-  **New LVM drivers model**, the shared KVM model, as well as support for compressed images in LVM. :ref:`Check more info on the new model here <lvm_drivers>`
-  **Many improvements in ceph drivers**, more info :ref:`here <ceph_ds>`.

Monitorization Drivers
~~~~~~~~~~~~~~~~~~~~~~

-  **New monitorization model**, changed from a pull model to a push model, thus increasing the scalability of an OpenNebula cloud. :ref:`More information here <mon>`

Virtualization Drivers
~~~~~~~~~~~~~~~~~~~~~~

-  **VMware drivers improvements**, like maintaining cloned target image format, improved vCenter integration

Networking Drivers
~~~~~~~~~~~~~~~~~~

-  **Security improvements in Open vSwitch**, block ARP cache poisoning.

Contextualization
-----------------

-  **Support for cloud init**, now OpenNebula is able to contextualize guests using :ref:`cloud init <cloud-init>`.
-  **Improvements in contextualization**, ability to add INIT\_SCRIPTS. Check :ref:`this guide <cong>` to learn how to define contextualization in your VM templates.

EC2 Public Cloud Improvements
-----------------------------

Multiple improvements in the EC2 Public API exposed by OpenNebula:

-  **VM snapshotting** and **VM tagging**. Read :ref:`this <ec2qug>` for more info on the offered EC2 functionality.
-  **Better use of ONE templates** in EC2 API, check more details :ref:`here <ec2qcg>`.

Cloud Bursting Improvements
---------------------------

The cloud bursting (previously called hybrid) drivers have been improved in a variety of areas:

-  **Allow mixed templates**, ability to have templates defining VMs locally and in Amazon EC2. More info :ref:`here <ec2g>`.
-  **Adoption of Ruby SDK**, for a better interaction with AWS.
-  **EBS optimized option**, now it can be passed to an Amazon VM. More info on EC2 :ref:`specific template attributes <ec2g>`.
-  **Extended host share variables**, to cope with big regions modelled in OpenNebula.

Sunstone
--------

-  **Improved Apache integration**, to allow uploading big images. More info on :ref:`Apache and Sunstone integration here <suns_advance>`.
-  **Better memcache integration**, for more details on Sunstone for large scale deployments :ref:`check this <suns_advance>`.
-  **Multiple minor bugfixes**: adding multiple tags of the same name, VM template wizard context fixes and updating, update quotas, attach disks problems, time format inconsistencies, tons of new tooltips, fixed typos, etc

