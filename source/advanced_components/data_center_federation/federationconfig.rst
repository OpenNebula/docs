.. _federationconfig:

================================================================================
OpenNebula Federation Configuration
================================================================================

This section will explain how to configure two (or more) OpenNebula zones to work as federation master and slave. The process described here can be applied to new installations, or existing OpenNebula instances.

OpenNebula master zone server replicates database changes in slaves using a federated log that include the SQL commands that are to be applied in all zones.

.. important:: In the following, each configuration step starts with **@master** or **@slave** to indicate the server where the step must be performed.

.. important:: Master and slave servers need to talk to each other through their XML-RPC API. You may need to update the ``LISTEN_ADDRESS``, and or ``PORT`` in oned.conf or any firewall rule blocking this communication. Note that by default this traffic is not secured, so if you are using public links you need to secure the communication.

.. important:: The federation can be setup with MySQL or Sqlite backends, but you cannot mix them across zones. MySQL is recommended for production deployments.

Step 1. Configure the OpenNebula Federation Master Zone
================================================================================

- **@master** Start by picking an OpenNebula to act as master of the federation. The master OpenNebula will be responsible for updating shared information across zones, and replicating the updates to the slaves. You may start with an existing installation or with a new one (see the :ref:`installation guide <ignc>`). 

.. note:: When installing a new master from scratch be sure to start it at least once to properly bootstrap the database.

- **@master** Edit the master zone endpoint. This can be done via Sunstone, or with the onezone command. Write down this endpoint to use it later when configuring the slaves.

.. code-block:: none

    $ onezone update 0
    ENDPOINT = http://<master-ip>:2633/RPC2

.. note:: In a HA setup, the master-ip should be set to the ```floating``` IP address, see :ref:`the HA installation guide <oneha>` for more details. In single server zones, just use the IP of the server.

You are now ready to start adding slave zones.

Step 2. Adding a New Federation Slave Zone
================================================================================

- **@slave** Install OpenNebula in the slave as usual following the :ref:`installation guide <ignc>`. Start OpenNebula at least once to bootstrap the zone database and then stop it.

- **@master** Create a zone for the slave, and write down the new Zone ID. This can be done via Sunstone, or with the onezone command.

.. prompt:: bash $ auto

    $ vim /tmp/zone.tmpl
    NAME     = slave-name
    ENDPOINT = http://<slave-zone-ip>:2633/RPC2

    $ onezone create /tmp/zone.tmpl
    ID: 100

    $ onezone list
       ID NAME
        0 OpenNebula
      100 slave-name

.. note:: In HA setups use the ```floating``` IP address for the slave-zone-ip, in single server zones just use the IP of the server.

- **@master** Make a snapshot of the federated tables with the following command:

.. prompt:: bash $ auto

    $  onedb backup --federated -s one.db 
    Sqlite database backup of federated tables stored in /var/lib/one/one.db_federated_2017-6-15_8:52:51.bck
    Use 'onedb restore' to restore the DB.

.. note:: This example shows how to make a database snapshot with Sqlite. For MySQL just change the -s option with the corresponding MySQL options: -u <username> -p <password> -d <database_name>. For Sqlite you need to stop OpenNebula before taking the DB snapshot. This is not required for MySQL.

- **@master**  Copy the database snapshot to the slave

- **@master** Copy the directory ``/var/lib/one/.one`` to the slave. This directory and its contents must have **oneadmin as owner**. The directory should contain these files:

.. prompt:: bash $ auto

    $ ls -1 /var/lib/one/.one
    ec2_auth
    one_auth
    oneflow_auth
    onegate_auth
    sunstone_auth

- **@slave** Update ``oned.conf`` to include the ID obtained when the zone was created in the master

.. code-block:: none

    FEDERATION = [
        MODE = "SLAVE",
        ZONE_ID = 100,
        MASTER_ONED = "http://<oned-master-ip>:2633/RPC2"
    ]

- **@slave** restore the database snapshot:

.. prompt:: bash $ auto

    $ onedb restore --federated -s /var/lib/one/one.db /var/lib/one/one.db_federated_2017-6-14_16:0:36.bck
    Sqlite database backup restored in one.db

- **@slave** Start OpenNebula

- **@slave** Register the server in the zone:

.. prompt:: bash $ auto

    $onezone server-add 100 --name one_salve --rpc http://<server_ip>:2633/RPC2

The zone should be now configured and ready to use.

Step 3 [Optional]. Adding HA to a Federation Slave Zone
--------------------------------------------------------------------------------

Now you can start adding additional servers to the slave zone to provide it with HA capabilities. The procedure is the same as the one described for stand-alone zones in :ref:`the HA installation guide <oneha>`. In this case, the replication works in a multi-tier fashion. The master replicates a database change to one of the zone servers. Then this server replicates the change across the zone servers.

It is **important** to double check that the federation is working before adding HA servers to the zone, as you will be updating the zone metadata which is a federated information.

Importing Existing OpenNebula Zones
================================================================================

There is no automatic procedure to import existing users and groups into a running federation. However you can preserve everything else like datastores, VMs, networks...

- **@slave** Backup details of users, groups and VDCs you want to recreate in the federated environment.

- **@slave** Stop OpenNebula. If the zone was running an HA cluster, stop all servers and pick one of them to add the zone to the federation. Put this server in solo mode by setting ``SERVER_ID`` to ``-1`` in oned.conf.

- **@master, @slave** Follow the procedure described in Step 2 to add a new zone.

- **@slave** Recreate any user, group or VDC you need to preserve in the federated environment.

The Zone is now ready to use. If you want to add additional HA servers, follow the standard procedure.

