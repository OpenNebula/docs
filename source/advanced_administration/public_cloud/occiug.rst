.. _occiug:

===========================
OpenNebula OCCI User Guide
===========================

The OpenNebula OCCI API is a RESTful service to create, control and monitor cloud resources using an implementation of the `OGF OCCI API specification <http://www.occi-wg.org>`__ based on the `draft 0.8 <http://forge.ogf.org/sf/docman/do/downloadDocument/projects.occi-wg/docman.root.drafts/doc15731/3>`__. This implementation also includes some extensions, requested by the community, to support OpenNebula specific functionality. Interactions with the resources are done through HTTP verbs (**GET**, **POST**, **PUT** and **DELETE**).

Commands
========

There are four kind of resources, listed below with their implemented actions:

-  **Storage**:

   -  ``occi-storage list [–verbose]``
   -  ``occi-storage create xml_template``
   -  ``occi-storage update xml_template``
   -  ``occi-storage show resource_id``
   -  ``occi-storage delete resource_id``

-  **Network**:

   -  ``occi-network list [–verbose]``
   -  ``occi-network create xml_template``
   -  ``occi-network update xml_template``
   -  ``occi-network show resource_id``
   -  ``occi-network delete resource_id``

-  **Compute**:

   -  ``occi-compute list [–verbose]``
   -  ``occi-compute create xml_template``
   -  ``occi-compute update xml_template``
   -  ``occi-compute show resource_id``
   -  ``occi-compute delete resource_id``
   -  ``occi-compute attachdisk resource_id storage_id``
   -  ``occi-compute detachdisk resource_id storage_id``

-  **Instance\_type**:

   -  ``occi-instance-type list [–verbose]``
   -  ``occi-instance-type show resource_id``

User Account Configuration
==========================

An account is needed in order to use the OpenNebula OCCI cloud. The cloud administrator will be responsible for assigning these accounts, which have a one to one correspondence with OpenNebula accounts, so all the cloud administrator has to do is check the :ref:`managing users guide <manage_users>` to setup accounts, and automatically the OpenNebula OCCI cloud account will be created.

In order to use such an account, the end user can make use of clients programmed to access the services described in the previous section. For this, she has to set up her environment, particularly the following aspects:

-  **Authentication**: This can be achieved in two different ways, listed here in order of priority (i.e. values specified in the argument line supersede environmental variables)

   -  Using the **commands arguments**. All the commands accept a **username** (as the OpenNebula username) and a **password** (as the OpenNebula password)
   -  If the above is not available, the **ONE\_AUTH** variable will be checked for authentication (with the same used for OpenNebula CLI, pointing to a file containing a single line: ``username:password``).

-  **Server location**: The command need to know where the OpenNebula OCCI service is running. You can pass the OCCI service endpoint using the ``-url`` flag in the commands. If that is not present, the **OCCI\_URL** environment variable is used (in the form of a http URL, including the port if it is not the standard 80). Again, if the **OCCI\_URL** variable is not present, it will default to ``http://localhost:4567``

.. warning:: The **OCCI\_URL** has to use the FQDN of the OCCI Service

Create Resources
================

Lets take a walk through a typical usage scenario. In this brief scenario it will be shown how to upload an image to the OCCI OpenNebula Storage repository, how to create a Network in the OpenNebula OCCI cloud and how to create Compute resource using the image and the network previously created.

-  **Storage**

Assuming we have a working Ubuntu installation residing in an **.img** file, we can upload it into the OpenNebula OCCI cloud using the following OCCI representation of the image:

.. code::

    <STORAGE>
        <NAME>Ubuntu Desktop</NAME>
        <DESCRIPTION>Ubuntu 10.04 desktop for students.</DESCRIPTION>
        <TYPE>OS</TYPE>
        <URL>file:///images/ubuntu/jaunty.img</URL>
    </STORAGE>

Next, using the **occi-storage** command we will create the Storage resource:

.. code::

    $ occi-storage --url http://cloud.server:4567 --username oneadmin --password opennebula create image.xml
    <STORAGE href='http://cloud.server:4567/storage/0'>
        <ID>3</ID>
        <NAME>Ubuntu Desktop</NAME>
        <TYPE>OS</TYPE>
        <DESCRIPTION>Ubuntu 10.04 desktop for students.</DESCRIPTION>
        <PUBLIC>NO</PUBLIC>
        <PERSISTENT>NO</PERSISTENT>
        <SIZE>41943040</SIZE>
    </STORAGE>

The user should take note of this **ID**, as it will be needed to add it to the Compute resource.

-  **Network**

The next step would be to create a Network resource

.. code::

    <NETWORK>
        <NAME>MyServiceNetwork</NAME>
        <ADDRESS>192.168.1.1</ADDRESS>
        <SIZE>200</SIZE>
        <PUBLIC>NO</PUBLIC>
    </NETWORK>

Next, using the **occi-network** command we will create the Network resource:

.. code::

    $ occi-network --url http://cloud.server:4567 --username oneadmin --password opennebula create vnet.xml
    <NETWORK href='http://cloud.server:4567/network/0'>
        <ID>0</ID>
        <NAME>MyServiceNetwork</NAME>
        <ADDRESS>192.168.1.1/ADDRESS>
        <SIZE>200/SIZE>
        <PUBLIC>NO</PUBLIC>
    </NETWORK>

-  **Compute**

The last step would be to create a Compute resource referencing the Storage and Networks resource previously created by means of their ID, using a representation like the following:

.. code::

        <COMPUTE>
            <NAME>MyCompute</NAME>
            <INSTANCE_TYPE href="http://www.opennebula.org/instance_type/small"/>
            <DISK>
                <STORAGE href="http://www.opennebula.org/storage/0"/>
            </DISK>
            <NIC>
                <NETWORK href="http://www.opennebula.org/network/0"/>
                <IP>192.168.1.12</IP>
            </NIC>
            <CONTEXT>
                <HOSTNAME>MAINHOST</HOSTNAME>
                <DATA>DATA1</DATA>
            </CONTEXT>
        </COMPUTE>

Next, using the **occi-compute** command we will create the Compute resource:

.. code::

    $ occi-compute --url http://cloud.server:4567 --username oneadmin --password opennebula create vm.xml
    <COMPUTE href='http://cloud.server:4567/compute/0'>
      <ID>0</ID>
      <CPU>1</CPU>
      <MEMORY>1024</MEMORY>
      <NAME>MyCompute</NAME>
      <INSTANCE_TYPE href="http://www.opennebula.org/instance_type/small"/>
      <STATE>PENDING</STATE>
      <DISK id='0'>
        <STORAGE href='http://cloud.server:4567/storage/3' name='Ubuntu Desktop'/>
        <TYPE>DISK</TYPE>
        <TARGET>hda</TARGET>
      </DISK>
      <NIC>
        <NETWORK href='http://cloud.server:4567/network/0' name='MyServiceNetwork'/>
        <IP>192.168.1.12</IP>
        <MAC>02:00:c0:a8:01:0c</MAC>
      </NIC>
      <CONTEXT>
        <DATA>DATA1</DATA>
        <HOSTNAME>MAINHOST</HOSTNAME>
        <TARGET>hdb</TARGET>
      </CONTEXT>
    </COMPUTE>

Updating Resources
==================

Storage
-------

Some of the characteristics of an storage entity can be modified using the occi-storage update command:

.. warning:: Only one characteristic can be updated per request

Storage Persistence
~~~~~~~~~~~~~~~~~~~

In order to make a storage entity persistent we can update the resource using the following xml:

.. code::

    <STORAGE href='http://cloud.server:4567/storage/0'>
        <ID>3</ID>
        <PERSISTENT>YES</PERSISTENT>
    </STORAGE>

Next, using the **occi-storage** command we will create the Storage resource:

.. code::

    $ occi-storage --url http://cloud.server:4567 --username oneadmin --password opennebula update image.xml
    <STORAGE href='http://cloud.server:4567/storage/0'>
        <ID>3</ID>
        <NAME>Ubuntu Desktop</NAME>
        <TYPE>OS</TYPE>
        <DESCRIPTION>Ubuntu 10.04 desktop for students.</DESCRIPTION>
        <PUBLIC>NO</PUBLIC>
        <PERSISTENT>YES</PERSISTENT>
        <SIZE>41943040</SIZE>
    </STORAGE>

Publish a Storage
~~~~~~~~~~~~~~~~~

In order to publish a storage entity so that other users can use it, we can update the resource using the following xml:

.. code::

    <STORAGE href='http://cloud.server:4567/storage/0'>
        <ID>3</ID>
        <PUBLIC>YES</PUBLIC>
    </STORAGE>

Next, using the **occi-storage** command we will create the Storage resource:

.. code::

    $ occi-storage --url http://cloud.server:4567 --username oneadmin --password opennebula update image.xml
    <STORAGE href='http://cloud.server:4567/storage/0'>
        <ID>3</ID>
        <NAME>Ubuntu Desktop</NAME>
        <TYPE>OS</TYPE>
        <DESCRIPTION>Ubuntu 10.04 desktop for students.</DESCRIPTION>
        <PUBLIC>YES</PUBLIC>
        <PERSISTENT>YES</PERSISTENT>
        <SIZE>41943040</SIZE>
    </STORAGE>

Network
-------

Some of the characteristics of an network entity can be modified using the occi-network update command:

.. warning:: Only one characteristic can be updated per request

Publish a Network
~~~~~~~~~~~~~~~~~

In order to publish a network entity so that other users can use it, we can update the resource using the following xml:

.. code::

    <NETWORK href='http://cloud.server:4567/network/0'>
        <ID>0</ID>
        <PUBLIC>YES</PUBLIC>
    </NETWORK>

Next, using the **occi-network** command we will update the Network resource:

.. code::

    $ occi-network --url http://cloud.server:4567 --username oneadmin --password opennebula update vnet.xml
    <NETWORK href='http://cloud.server:4567/network/0'>
        <ID>0</ID>
        <NAME>MyServiceNetwork</NAME>
        <ADDRESS>192.168.1.1/ADDRESS>
        <SIZE>200/SIZE>
        <PUBLIC>YES</PUBLIC>
    </NETWORK>

Compute
-------

Some of the characteristics of a compute entity can be modified using the occi-compute update command:

.. warning:: Only one characteristic can be updated per request

Change the Compute State
~~~~~~~~~~~~~~~~~~~~~~~~

In order to change the Compute state, we can update the resource using the following xml:

.. code::

    <COMPUTE href='http://cloud.server:4567/compute/0'>
      <ID>0</ID>
      <STATE>STOPPED</STATE>
    </COMPUTE>

Next, using the **occi-compute** command we will update the Compute resource:

The available states to update a Compute resource are:

-  STOPPED
-  SUSPENDED
-  RESUME
-  CANCEL
-  SHUTDOWN
-  REBOOT
-  RESET
-  DONE

Save a Compute Disk in a New Storage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to save a Compute disk in a new image, we can update the resource using the following xml. The disk will be saved after shutting down the Compute.

.. code::

    <COMPUTE href='http://cloud.server:4567/compute/0'>
      <ID>0</ID>
      <DISK id="0">
        <STORAGE href="http://cloud.server:4567/storage/0" name="first_image"/>
        <SAVE_AS name="save_as1"/>
      </DISK>
    </COMPUTE>

Next, using the **occi-compute** command we will update the Compute resource:

.. code::

    $ occi-compute --url http://cloud.server:4567 --username oneadmin --password opennebula update vm.xml
    <COMPUTE href='http://cloud.server:4567/compute/0'>
      <ID>0</ID>
      <CPU>1</CPU>
      <MEMORY>1024</MEMORY>
      <NAME>MyCompute</NAME>
      <INSTANCE_TYPE>small</INSTANCE_TYPE>
      <STATE>STOPPED</STATE>
      <DISK id='0'>
        <STORAGE href='http://cloud.server:4567/storage/3' name='Ubuntu Desktop'/>
        <SAVE_AS href="http://cloud.server:4567/storage/7"/>
        <TYPE>DISK</TYPE>
        <TARGET>hda</TARGET>
      </DISK>
      <NIC>
        <NETWORK href='http://cloud.server:4567/network/0' name='MyServiceNetwork'/>
        <IP>192.168.1.12</IP>
        <MAC>02:00:c0:a8:01:0c</MAC>
      </NIC>
      <CONTEXT>
        <DATA>DATA1</DATA>
        <HOSTNAME>MAINHOST</HOSTNAME>
        <TARGET>hdb</TARGET>
      </CONTEXT>
    </COMPUTE>

Create a Volume and Attach It to a Running VM
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this example we will show how to create a new volume using the following template and attach it to a running compute resource.

.. code::

    <STORAGE>
      <NAME>Volume1</NAME>
      <TYPE>DATABLOCK</TYPE>
      <DESCRIPTION>Volume to be hotplugged</DESCRIPTION>
      <PUBLIC>NO</PUBLIC>
      <PERSISTENT>NO</PERSISTENT>
      <FSTYPE>ext3</FSTYPE>
      <SIZE>10</SIZE>
    </STORAGE>

.. code::

    $ cat /tmp/storage
    <STORAGE>
        <NAME>Volume1</NAME>
        <TYPE>DATABLOCK</TYPE>
        <DESCRIPTION>Volume to be hotplugged</DESCRIPTION>
        <PUBLIC>NO</PUBLIC>
        <PERSISTENT>NO</PERSISTENT>
        <FSTYPE>ext3</FSTYPE>
        <SIZE>10</SIZE>
    </STORAGE>

    $ occi-storage create /tmp/storage
    <STORAGE href='http://127.0.0.1:4567/storage/5'>
      <ID>5</ID>
      <NAME>Volume1</NAME>
      <USER href='http://127.0.0.1:4567/user/0' name='oneadmin'/>
      <GROUP>oneadmin</GROUP>
      <STATE>READY</STATE>
      <TYPE>DATABLOCK</TYPE>
      <DESCRIPTION>Volume to be hotplugged</DESCRIPTION>
      <SIZE>10</SIZE>
      <FSTYPE>ext3</FSTYPE>
      <PUBLIC>NO</PUBLIC>
      <PERSISTENT>NO</PERSISTENT>
    </STORAGE>

    $ occi-compute list
    <COMPUTE_COLLECTION>
      <COMPUTE href='http://127.0.0.1:4567/compute/4' name='one-4'/>
      <COMPUTE href='http://127.0.0.1:4567/compute/6' name='one-6'/>
    </COMPUTE_COLLECTION>

    $ occi-storage list
    <STORAGE_COLLECTION>
      <STORAGE name='ttylinux - kvm' href='http://127.0.0.1:4567/storage/1'/>
      <STORAGE name='Ubuntu Server 12.04 (Precise Pangolin) - kvm' href='http://127.0.0.1:4567/storage/2'/>
      <STORAGE name='Volume1' href='http://127.0.0.1:4567/storage/5'/>
    </STORAGE_COLLECTION>

    $ occi-compute attachdisk 6 5
    <COMPUTE href='http://127.0.0.1:4567/compute/6'>
      <ID>6</ID>
      <USER name='oneadmin' href='http://127.0.0.1:4567/user/0'/>
      <GROUP>oneadmin</GROUP>
      <CPU>1</CPU>
      <MEMORY>512</MEMORY>
      <NAME>one-6</NAME>
      <STATE>ACTIVE</STATE>
      <DISK id='0'>
        <STORAGE name='Ubuntu Server 12.04 (Precise Pangolin) - kvm' href='http://127.0.0.1:4567/storage/2'/>
        <TYPE>FILE</TYPE>
        <TARGET>hda</TARGET>
      </DISK>
      <DISK id='1'>
        <STORAGE name='Volume1' href='http://127.0.0.1:4567/storage/5'/>
        <TYPE>FILE</TYPE>
        <TARGET>sda</TARGET>
      </DISK>
      <NIC>
        <NETWORK name='local-net' href='http://127.0.0.1:4567/network/0'/>
        <IP>192.168.122.6</IP>
        <MAC>02:00:c0:a8:7a:06</MAC>
      </NIC>
    </COMPUTE>

.. warning:: You can obtain more information on how to use the above commands accessing their Usage help passing them the **-h** flag. For instance, a -T option is available to set a connection timeout.

.. warning:: In platforms where 'curl' is not available or buggy (i.e. CentOS), a '-M' option is available to perform upload using the native ruby Net::HTTP using http multipart

