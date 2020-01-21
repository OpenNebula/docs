.. _ec2qcg:

================================================================================
EC2 Server Configuration
================================================================================

The OpenNebula EC2 Query is a web service that enables you to launch and manage virtual machines in your OpenNebula installation through the `Amazon EC2 Query Interface <http://docs.amazonwebservices.com/AWSEC2/2009-04-04/DeveloperGuide/index.html?using-query-api.html>`__. In this way, you can use any EC2 Query tool or utility to access your Private Cloud. The EC2 Query web service is implemented upon the **OpenNebula Cloud API** (OCA) layer that exposes the full capabilities of an OpenNebula private cloud; and `Sinatra <http://www.sinatrarb.com/>`__, a widely used light web framework.

|image0|

The current implementation includes the basic routines to use a Cloud, namely: image upload and registration, and the VM run, describe and terminate operations. The following sections explain you how to install and configure the EC2 Query web service on top of a running OpenNebula cloud.

.. note:: The OpenNebula EC2 Query service provides an Amazon EC2 Query API-compatible interface to your cloud, that can be used alongside the native OpenNebula CLI or OpenNebula Sunstone. The OpenNebula distribution includes the tools needed to use the EC2 Query service.

Requirements & Installation
================================================================================

You must have an OpenNebula site properly configured and running. Be sure to check the :ref:`OpenNebula Installation and Configuration Guides <design_and_installation_guide>` to set up your private cloud first. This guide also assumes that you are familiar with the configuration and use of OpenNebula.

The OpenNebula EC2 Query service was installed during the OpenNebula installation, and also the dependencies of this service, as explained in the :ref:`installation guide <ignc>`

.. _ec2qcg_configuration:

Configuration
================================================================================

The service is configured through the ``/etc/one/econe.conf`` file, where you can set up the basic operational parameters for the EC2 Query web service. The available options are:

**Server configuration**

* ``tmpdir``: Directory to store temp files when uploading images
* ``one_xmlrpc``: ``oned`` XML-RPC service, default ``http://localhost:2633/RPC2``
* ``host``: Host where the ``econe`` server will run
* ``port``: Port which the ``econe`` server will use
* ``ssl_server``: URL for the EC2 service endpoint, when configured through a proxy

**Log**

* ``debug_level``: Log debug level, ``0`` for ``ERROR``, ``1`` for ``WARNING``, ``2`` for ``INFO``, ``3`` for ``DEBUG``.

**Auth**

* ``auth``: Authentication driver for incoming requests
* ``core_auth``: Authentication driver to communicate with OpenNebula core. Check :ref:`this guide <cloud_auth>` for more information about the core\_auth system.

**File based templates**

* ``use_file_templates``: Use former file-based templates for instance types instead of OpenNebula templates
* ``instance_types``: DEPRECATED.  The VM types for your cloud

**Resources**

* ``describe_with_terminated_instances``: Include terminated instances in the ``describe_instances`` XML. When this parameter is enabled, all the VMs in the DONE state will be retrieved in each ``describe_instances`` action and then filtered. This can cause performance issues when the pool of VMs in the DONE state is huge.
* ``terminated_instances_expiration_time``: Terminated VMs will be included in the list until the termination date + terminated\_instances\_expiration\_time is reached.
* ``datastore_id``: Datastore in which the Images uploaded through EC2 will be allocated, by default 1.
* ``cluster_id``: Cluster associated with the EC2 resources. By default no Cluster is defined.

**Elastic IP**

* ``elasticips_vnet_id``: Virtual Network containing the elastic IPs to be used with EC2. If not defined, the Elastic IP functionality is disabled.
* ``associate_script``: Script to associate a public IP with a private IP. Arguments: *elastic\_ip* *private\_ip vnet\_template* (where the template is base64-encoded).

.. Fixme: Are the args now correct here?:

* ``disassociate_script``: Script to disassociate a public IP. Arguments: *elastic\_ip*  *private\_ip vnet\_template* (where the template is base64-encoded).

**EBS**

* ``ebs_fstype``: FSTYPE that will be used when creating new volumes (DATABLOCKs)

.. Fixme: should this be under "Server configured"?

.. warning:: The ``:host`` **must** be a FQDN; do not use IPs here.

.. _ec2qcg_cloud_users:

Cloud Users
--------------------------------------------------------------------------------

The cloud users have to be created in OpenNebula by ``oneadmin`` using the ``oneuser`` utility. Once a user is registered in the system, using the same procedure as to create private cloud users, they can start using the system.

The users will authenticate using the `Amazon EC2 procedure <http://docs.amazonwebservices.com/AWSEC2/latest/DeveloperGuide/index.html?using-query-api.html>`__ with ``AWSAccessKeyId`` (their OpenNebula user name) and ``AWSSecretAccessKey`` (their OpenNebula hashed password).

The cloud administrator can limit the interfaces that these users can use to interact with OpenNebula by setting the driver ``public`` for them. Using that driver, cloud users will not be able to interact with OpenNebula through Sunstone, CLI or XML-RPC.

.. code::

    $ oneuser chauth cloud_user public

Defining VM Types
--------------------------------------------------------------------------------

You can define as many Virtual Machine types as you want. Just:

-  Create a new OpenNebula template for the new type and make it available for the users group. You can use restricted attributes and set permissions like any other OpenNebula resource. **You must include the EC2\_INSTANCE\_TYPE parameter inside the template definition**, otherwise the template will not be available to be used as an instance type in EC2.

.. code::

    # This is the content of the /tmp/m1.small file
    NAME = "m1.small"
    EC2_INSTANCE_TYPE = "m1.small"
    CPU = 1
    MEMORY = 1700
    ...

.. prompt:: bash $ auto

    $ onetemplate create /tmp/m1.small
    $ onetemplate chgrp m1.small users
    $ onetemplate chmod m1.small 640

The template must include all the required information to instantiate a new virtual machine, such as network configuration, capacity, placement requirements, etc. This information will be used as a base template and will be merged with the information provided by the user.

The user will select an instance type, along with the AMI id, keypair and user data, when creating a new instance. Therefore, **the template should not include the OS**, since it will be specified by the user with the selected AMI.

.. note:: The templates are processed by the EC2 server to include specific data for the instance.

Starting the Cloud Service
================================================================================

To start the EC2 Query service, just issue the following command:

.. prompt:: text $ auto

    $ econe-server start

You can find the econe server log file in ``/var/log/one/econe-server.log``.

To stop the EC2 Query service:

.. prompt:: text $ auto

    $ econe-server stop

Advanced Configuration
================================================================================

Enabling Keypairs
--------------------------------------------------------------------------------

.. Fixme: Should the reference be updated?

In order to benefit from the Keypair functionality, the images that will be used by the econe users must be prepared to read the EC2\_PUBLIC\_KEY and EC2\_USER\_DATA from the CONTEXT disk. This can be achieved easily with the new `contextualization packages <http://opennebula.org/documentation:rel3.8:cong#contextualization_packages_for_vm_images>`__, generating a new custom contextualization package like this one:

.. prompt:: text $ auto

    #!/bin/bash
    echo "$EC2_PUBLIC_KEY" > /root/.ssh/authorized_keys

Enabling Elastic IP Functionality
--------------------------------------------------------------------------------

An Elastic IP address is associated with the user, not a particular instance, and users control that address until they choose to release it. This way, users can remap their public IP addresses to any of their instances.

In order to enable this functionality you have to follow the following steps in order to create a VNET containing the elastic IPs:

-  Create a new Virtual Network as oneadmin, containing the public IPs that will be controlled by the EC2 users. Each IP **must be placed in its own AR**:

.. code::

    NAME    = "ElasticIPs"

    PHYDEV  = "eth0"
    VLAN    = "YES"
    VLAN_ID = 50
    BRIDGE  = "brhm"

    AR  = [IP=10.0.0.1, TYPE=IP4, SIZE=1]
    AR  = [IP=10.0.0.2, TYPE=IP4, SIZE=1]
    AR  = [IP=10.0.0.3, TYPE=IP4, SIZE=1]
    AR  = [IP=10.0.0.4, TYPE=IP4, SIZE=1]

    # Custom Attributes to be used in Context
    GATEWAY = 130.10.0.1

.. prompt:: text $ auto

    $ onevnet create /tmp/fixed.vnet
    ID: 8

This VNET will be managed by the oneadmin user; therefore ``USE`` permission for the EC2 users is not required.

-  Update the ``econe.conf`` file with the VNET ID:

.. code::

    :elastic_ips_vnet: 8


-  Provide associate and disassociate scripts

The interaction with the infrastructure has been abstracted. Therefore two scripts have to be provided by the cloud administrator in order to interact with each specific network configuration. These two scripts enable us to adapt this feature to different configurations and data centers.

These scripts are language agnostic and their path has to be specified in the econe configuration file:

.. code::

      :associate_script: /usr/bin/associate_ip.sh
      :disassociate_script: /usr/bin/disassociate_ip.sh

The associate script will receive three arguments: **elastic\_ip** to be associated; **private\_ip** of the instance; **Virtual Network template**, base64-encoded.

The disassociate script will receive similar arguments: **elastic\_ip** to be disassociated, **private_ip**, and **Virtual Network template**.

.. Fixme: Where is this now?

Scripts to interact with OpenFlow can be found in an `ecosystem project <http://www.opennebula.org/software:ecosystem:onenox>`__

Using a Specific Group for EC2
--------------------------------------------------------------------------------

It is recommended to create a new group to handle the EC2 cloud users:

.. prompt:: text $ auto

    $ onegroup create ec2
    ID: 100

Create and add the users to the EC2 group (ID:100):

.. prompt:: text $ auto

    $ oneuser create clouduser my_password
    ID: 12
    $ oneuser chgrp 12 100

Also, you will have to create ACL rules so that the cloud users are able to deploy their VMs in the allowed hosts.

.. prompt:: text $ auto

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM   STAT
       1 kvm1            -           2    110 / 200 (55%)  640M / 3.6G (17%)   on
       1 kvm2            -           2    110 / 200 (55%)  640M / 3.6G (17%)   on
       1 kvm3            -           2    110 / 200 (55%)  640M / 3.6G (17%)   on

These rules will allow users inside the EC2 group (ID:100) to deploy VMs in the hosts kvm01 (ID:0) and kvm03 (ID:3)

.. prompt:: text $ auto

    $ oneacl create "@100 HOST/#1 MANAGE"
    $ oneacl create "@100 HOST/#3 MANAGE"

You **have to create a VNet network** using the ``onevnet`` utility with the IPs you want to lease to the VMs created with the EC2 Query service.

.. prompt:: text $ auto

    $ onevnet create /tmp/templates/vnet
    ID: 12

Remember that you will have to add this VNet (ID:12) to the users group (ID:100) and give USE (640) permissions to the group in order to get leases from it.

.. prompt:: text $ auto

    $ onevnet chgrp 12 100
    $ onevnet chmod 12 640

.. warning:: You will have to update the NIC template, inside the ``/etc/one/ec2query_templates`` directory, in order to use this VNet ID.

Configuring an SSL Proxy
--------------------------------------------------------------------------------

The OpenNebula EC2 Query Service runs natively just on normal HTTP connections. If the extra security provided by SSL is needed, a proxy can be set up to handle the SSL connection that forwards the petition to the EC2 Query Service and returns the answer to the client.

This set up needs:

-  A server certificate for the SSL connections
-  An HTTP proxy that understands SSL
-  EC2Query Service configuration to accept petitions from the proxy

You can find instructions on configuring lighttpd as a proxy for the example ``cloudserver.org`` in the :ref:`Sunstone Setup guide <ss_proxy>`.  Follow those, but use ``4567``, not ``9869``, as the ``port`` for ``proxy.server``.

Then the ``econe.conf`` needs to define the following:

.. code::

    # Host and port where econe server will run
    :host: localhost
    :port: 4567

    #SSL proxy URL that serves the API (set if is being used)
    :ssl_server: https://cloudserver.org:8443/

Once the lighttpd server is started, EC2Query petitions using HTTPS URIs can be directed to ``https://cloudserver.org:8443``, that will then be unencrypted, passed to localhost, port 4567, satisfied (hopefully), encrypted again and then passed back to the client.

.. warning:: Note that ``:ssl_server`` **must** be a URL that may contain a custom path.

.. |image0| image:: /images/econe-arch_v2.png
