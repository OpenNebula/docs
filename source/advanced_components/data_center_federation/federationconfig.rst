.. _federationconfig:

================================================================================
OpenNebula Federation Configuration
================================================================================

This section will explain how to configure two (or more) OpenNebula zones to work as federation master and slave. The process described here can be applied to new installations, or existing OpenNebula instances.

OpenNebula master zone server replicates database changes in slaves using a federated log that include the SQL commands that are to be applied in all zones.


Configure the OpenNebula Federation Master Zone
================================================================================

Adding OpenNebula Federation Slave Zones
================================================================================

Importing Existing OpenNebula Zones
================================================================================

Federation and HA deployements
================================================================================


.. todo:: This is obsolete now, TBR





MySQL needs to be configured to enable the master-slave replication. Please read `the MySQL documentation <http://dev.mysql.com/doc/refman/5.7/en/replication.html>`_ for complete instructions. The required steps are summarized here, but it may happen that your MySQL version needs a different configuration.

Step 1. Configure the OpenNebula Federation Master
================================================================================

- Start with an existing OpenNebula, or install OpenNebula as usual following the :ref:`installation guide <ignc>`. For new installations, you may need to create a MySQL user for OpenNebula, read more in the :ref:`MySQL configuration guide <mysql>`.

.. prompt:: bash # auto

    # mysql -u root -p
    mysql> GRANT ALL PRIVILEGES ON opennebula.* TO 'oneadmin' IDENTIFIED BY 'oneadmin';

- Configure OpenNebula to use the **master MySQL**, and to act as a **federation master**.

.. prompt:: bash $ auto

    $ sudo vi /etc/one/oned.conf
    #DB = [ backend = "sqlite" ]

    # Sample configuration for MySQL
     DB = [ backend = "mysql",
            server  = "<ip>",
            port    = 0,
            user    = "oneadmin",
            passwd  = "oneadmin",
            db_name = "opennebula" ]

    FEDERATION = [
        MODE = "MASTER",
        ZONE_ID = 0,
        MASTER_ONED = ""
    ]

- Restart OpenNebula
- Edit the local (master) Zone Endpoint. This can be done via Sunstone, or with the onezone command.

.. code-block:: none

    $ onezone update 0
    ENDPOINT = http://<master-ip>:2633/RPC2

- Create a Zone for each one of the slaves, and write down the new Zone ID. This can be done via Sunstone, or with the onezone command.

.. prompt:: bash $ auto

    $ vim /tmp/zone.tmpl
    NAME     = slave-name
    ENDPOINT = http://<slave-ip>:2633/RPC2

    $ onezone create /tmp/zone.tmpl
    ID: 100

    $ onezone list
       ID NAME
        0 OpenNebula
      100 slave-name

- Stop OpenNebula.

2. Import the Existing Slave OpenNebula
================================================================================

.. note:: If your slave OpenNebula is going to be installed from scratch, you can skip this step.

If the OpenNebula to be added as a Slave is an existing installation, and you need to preserve its database (users, groups, VMs, hosts...), you need to import the contents with the ``onedb`` command.

- Stop the slave OpenNebula. Make sure the master OpenNebula is also stopped.
- Run the ``onedb import-slave`` command. Use ``-h`` to get an explanation of each option.

.. prompt:: bash $ auto

    $ onedb import-slave -h
    ## USAGE
    import-slave
        Imports an existing federation slave into the federation master database

    ## OPTIONS
    ...

    $ onedb import-slave -v \
    --username oneadmin --password oneadmin \
    --server 192.168.122.3 --dbname opennebula  \
    --slave-username oneadmin --slave-password oneadmin \
    --slave-server 192.168.122.4 --slave-dbname opennebula

The tool will ask for the Zone ID you created in step 1.

.. code-block:: none

    Please enter the Zone ID that you created to represent the new Slave OpenNebula:
    Zone ID:

You will also need to decide if the users, groups and VDCs will be merged.

If you had different people using the master and slave OpenNebula instances, then choose not to merge users. In case of name collision, the slave account will be renamed to ``<username>-1``.

You will want to merge if your users were accessing both the master and slave OpenNebula instances before the federation. To put it more clearly, the same person had previous access to the ``alice`` user in master and ``alice`` user in the slave. This will be the case if, for example, you had more than one OpenNebula instances pointing to the same LDAP server for authentication.

When a user is merged, its user template is also copied, using the master contents in case of conflict. This means that if alice had a different password or 'SSH_KEY' in her master and slave OpenNebula users, only the one in master will be preserved.

In any case, the ownership of existing resources and group membership is preserved.

.. code-block:: none

    The import process will move the users from the slave OpeNenbula to the master
    OpenNebula. In case of conflict, it can merge users with the same name.
    For example:
    +----------+-------------++------------+---------------+
    | Master   | Slave       || With merge | Without merge |
    +----------+-------------++------------+---------------+
    | 5, alice | 2, alice    || 5, alice   | 5, alice      |
    | 6, bob   | 5, bob      || 6, bob     | 6, bob        |
    |          |             ||            | 7, alice-1    |
    |          |             ||            | 8, bob-1      |
    +----------+-------------++------------+---------------+

    In any case, the ownership of existing resources and group membership
    is preserved.

    Do you want to merge USERS (Y/N): y

    Do you want to merge GROUPS (Y/N): y

When the import process finishes, onedb will write in ``/var/log/one/onedb-import.log`` the new user IDs and names if they were renamed.

3. Configure the MySQL Replication Master
================================================================================

- In your **master MySQL**: enable the binary log for the OpenNebula database and set a server ID. Change the 'opennebula' database name to the one set in oned.conf.

.. prompt:: bash $ auto

    $ sudo vi /etc/my.cnf
    [mysqld]
    log-bin             = mysql-bin
    server-id           = 1
    binlog-do-db        = opennebula

    $ sudo service mysqld restart

- **Master MySQL**: You also need to create a special user that will be used by the MySQL replication slaves.

.. _federationconfig_create_user:

.. prompt:: bash # auto

    # mysql -u root -p
    mysql> CREATE USER 'one-slave'@'%' IDENTIFIED BY 'one-slave-pass';
    mysql> GRANT REPLICATION SLAVE ON *.* TO 'one-slave'@'%';

.. warning:: In the previous example we are granting access to user one-replication from any host. You may want to restrict the hosts with the hostnames of the mysql slaves

- **Master MySQL**: Lock the tables and perform a dump.

First you need to lock the tables before dumping the federated tables.

.. code-block:: none

    mysql> FLUSH TABLES WITH READ LOCK;

Then you can safely execute the mysqldump command in another terminal. Please note the ``--master-data`` option, it must be present to allow the slaves to know the current position of the binary log.

.. code-block:: none

    mysqldump -u root -p --master-data opennebula user_pool group_pool marketplace_pool marketplaceapp_pool vdc_pool zone_pool db_versioning acl > dump.sql

Once you get the dump you can unlock the DB tables again.

.. code-block:: none

    mysql> UNLOCK TABLES;

- MySQL replication cannot use Unix socket files. You must be able to connect from the slaves to the master MySQL server using TCP/IP and port 3306 (default mysql port). Please update your firewall accordingly.

- You can start the master OpenNebula at this point.

4. Configure the MySQL Replication Slave
================================================================================

For each one of the slaves, configure the MySQL server as a replication slave. Pay attention to the ``server-id`` set in my.cnf, it must be unique for each one.

- Set a server ID for the **slave MySQL**, and configure these tables to be replicated. You may need to change 'opennebula' to the database name used in oned.conf. The database name must be the same for the master and slaves OpenNebulas.

.. prompt:: bash $ auto

    $ sudo vi /etc/my.cnf
    [mysqld]
    server-id           = 100
    replicate-do-table  = opennebula.user_pool
    replicate-do-table  = opennebula.group_pool
    replicate-do-table  = opennebula.marketplace_pool
    replicate-do-table  = opennebula.marketplaceapp_pool
    replicate-do-table  = opennebula.vdc_pool
    replicate-do-table  = opennebula.zone_pool
    replicate-do-table  = opennebula.db_versioning
    replicate-do-table  = opennebula.acl

    $ sudo service mysqld restart

- Set the master configuration on the **slave MySQL**.

.. prompt:: bash $ auto

    $ sudo mysql -u root -p
    mysql> CHANGE MASTER TO
        ->     MASTER_HOST='master_host_name',
        ->     MASTER_USER='one-slave',
        ->     MASTER_PASSWORD='one-slave-pass';

- Copy the mysql dump file from the **master**, and import its contents to the **slave**.

.. code-block:: none

    mysql> CREATE DATABASE IF NOT EXISTS opennebula;
    mysql> USE opennebula;
    mysql> SOURCE /path/to/dump.sql;

- Start the **slave MySQL** process and check its status.

.. code-block:: none

    mysql> START SLAVE;
    mysql> SHOW SLAVE STATUS\G

The ``SHOW SLAVE STATUS`` output will provide detailed information, but to confirm that the slave is connected to the master MySQL, take a look at these columns:

.. code-block:: none

       Slave_IO_State: Waiting for master to send event
     Slave_IO_Running: Yes
    Slave_SQL_Running: Yes


5. Configure the OpenNebula Federation Slave
================================================================================

For each slave, follow these steps.

- If it is a new installation, install OpenNebula as usual following the :ref:`installation guide <ignc>`.
- Configure OpenNebula to use MySQL, first you'll need to create a database user for OpenNebula and grant access to the OpenNebula database:

.. prompt:: bash $ auto

    $ sudo mysql -u root -p
    mysql> GRANT ALL PRIVILEGES ON opennebula.* TO 'oneadmin' IDENTIFIED BY 'oneadmin';

and update oned.conf to use these values:

.. prompt:: bash $ auto

    $ sudo vi /etc/one/oned.conf
    #DB = [ backend = "sqlite" ]

    # Sample configuration for MySQL
     DB = [ backend = "mysql",
            server  = "<ip>",
            port    = 0,
            user    = "oneadmin",
            passwd  = "oneadmin",
            db_name = "opennebula" ]

- Configure OpenNebula to act as a **federation slave**. Remember to use the ID obtained when the zone was created.

.. code-block:: none

    FEDERATION = [
        MODE = "SLAVE",
        ZONE_ID = 100,
        MASTER_ONED = "http://<oned-master-ip>:2633/RPC2"
    ]


- Copy the directory ``/var/lib/one/.one`` from the **master** front-end to the **slave**. This directory and its contents must have **oneadmin as owner**. The directory should contain these files:

.. prompt:: bash $ auto

    $ ls -1 /var/lib/one/.one
    ec2_auth
    one_auth
    oneflow_auth
    onegate_auth
    sunstone_auth

Make sure ``one_auth`` (the oneadmin credentials) is present. If it's not, copy it from **master** oneadmin's ``$HOME/.one`` to the **slave** oneadmin's ``$HOME/.one``. For most configurations, oneadmin's home is ``/var/lib/one`` and this won't be necessary.

- Start the slave OpenNebula.

6. Configure Sunstone for a Federation
================================================================================

If Sunstone is behind a proxy, make sure you follow :ref:`these <suns_advance_federated>` instructions in order to enable the proper header support required by a federation.

.. _federationconfig_ha:

High-Availability and Federation
================================================================================

In order to add :ref:`federation <federationconfig>` to an HA set-up you will need to use `MariaDB <https://mariadb.org/>`__ >= 10.0.2. If this version is not available in your distribution, please use the `repositories provided by MariaDB <https://downloads.mariadb.org/mariadb/repositories/#mirror=tedeco>`__.

The procedure to enable both HA and Federation uses the `multi source replication <https://mariadb.com/kb/en/mariadb/multi-source-replication/>`__ capabilities of MariaDB.

* Every zone must have a 2-node master-master MariaDB cluster.
* Every zone except for the master zone should configure DB replcation for the federated tables from **both** MariaDB nodes of the master zone.

This is illustrated by the following diagram:

|image0|

The **HA** arrows represent a full master-master replication of all the OpenNebula tables. The **Fed** arrows represent a replication of only the federation tables.

Each replication arrow is implemented in MariaDB by a slave configured with the `CHANGE MASTER <https://mariadb.com/kb/en/mariadb/change-master-to/>`__ directive. Note that we will be using a `connection_name` in order to identify each slave.

.. note:: The HA cluster can must be composed of at least 2 nodes, but you can scale up to as many nodes as you need. In order to so, you should set up a circular replication for HA: A->B->C->...->A and pull the federated tables from all the nodes of the master zone in the rest of the zones.

Configuration
--------------------------------------------------------------------------------

To set-up the HA replication in each cluster enable the following in the MariaDB configuration file, e.g. `/etc/my.cnf.d/server.cnf` of both nodes:

.. code-block:: none

    [mysqld]
    server-id    = 1 # Use a different ID for all the servers
    log-bin      = mysql-bin
    binlog-do-db = opennebula

Additionally, in all the zones but the master zone, configure the federation replication. This is how `/etc/my.cnf.d/server.cnf` looks like for these nodes

.. code-block:: none

    [mysqld]
    server-id    = 100 # Use a different ID for all the servers
    log-bin      = mysql-bin
    binlog-do-db = opennebula

    zone0-master1.replicate-do-table  = opennebula.user_pool
    zone0-master1.replicate-do-table  = opennebula.group_pool
    zone0-master1.replicate-do-table  = opennebula.marketplace_pool
    zone0-master1.replicate-do-table  = opennebula.marketplaceapp_pool
    zone0-master1.replicate-do-table  = opennebula.vdc_pool
    zone0-master1.replicate-do-table  = opennebula.zone_pool
    zone0-master1.replicate-do-table  = opennebula.db_versioning
    zone0-master1.replicate-do-table  = opennebula.acl

    zone0-master2.replicate-do-table  = opennebula.user_pool
    zone0-master2.replicate-do-table  = opennebula.group_pool
    zone0-master2.replicate-do-table  = opennebula.marketplace_pool
    zone0-master2.replicate-do-table  = opennebula.marketplaceapp_pool
    zone0-master2.replicate-do-table  = opennebula.vdc_pool
    zone0-master2.replicate-do-table  = opennebula.zone_pool
    zone0-master2.replicate-do-table  = opennebula.db_versioning
    zone0-master2.replicate-do-table  = opennebula.acl

Restart the MariaDB service in all the nodes, e.g.:

.. prompt:: bash $ auto

    $ sudo /etc/init.d/mysql restart

Create the replication users as explained in :ref:`this section <federationconfig_create_user>`.

HA Replication
--------------------------------------------------------------------------------

Follow these steps in all the zones, including the master zone.

Obtain the master position in the first node:

.. code-block:: none

    > SHOW MASTER STATUS;
    +------------------+-----------+--------------+------------------+
    | File             | Position  | Binlog_Do_DB | Binlog_Ignore_DB |
    +------------------+-----------+--------------+------------------+
    | <LOG_FILE>       | <LOG_POS> | opennebula   |                  |
    +------------------+-----------+--------------+------------------+

Configure the second node to replicate using this data:

.. code-block:: none

    CHANGE MASTER 'zone<ZONE_ID>-master' TO  MASTER_HOST='<NODE1>', \
                                    MASTER_USER='<REPLICATION_USER>', \
                                    MASTER_PASSWORD='<REPLICATION_PASS>', \
                                    MASTER_LOG_FILE = '<LOG_FILE>', \
                                    MASTER_LOG_POS = <LOG_POS>;
    START SLAVE 'zone<ZONE_ID>-master';

Repeat the reverse process by running `SHOW MASTER STATUS` in the second node, and establishing it as the master in the first node:

.. code-block:: none

    CHANGE MASTER 'zone<ZONE_ID>-slave' TO  MASTER_HOST = '<NODE2>', \
                                    MASTER_USER = '<REPLICATION_USER>', \
                                    MASTER_PASSWORD ='<REPLICATION_PASS>', \
                                    MASTER_LOG_FILE = '<LOG_FILE>', \
                                    MASTER_LOG_POS = <LOG_POS>;
    START SLAVE 'zone<ZONE_ID>-slave';

Federation
--------------------------------------------------------------------------------

In all the nodes, except the nodes in the master zone, you will to set up the replication of the federated tables from both nodes in the master zone.

Repeat the following commands in both nodes of each zone:

.. code-block:: none

    CHANGE MASTER 'zone0-master1' TO    MASTER_HOST = '<ZONE0_MASTER1_IP>', \
                                        MASTER_USER = '<REPLICATION_USER>', \
                                        MASTER_PASSWORD = '<REPLICATION_PASS>';
    START SLAVE 'zone0-master1';

    CHANGE MASTER 'zone0-master2' TO    MASTER_HOST = '<ZONE0_MASTER2_IP>', \
                                        MASTER_USER = '<REPLICATION_USER>', \
                                        MASTER_PASSWORD = '<REPLICATION_PASS>';
    START SLAVE 'zone0-master2';


Verify
--------------------------------------------------------------------------------

Verify in all the nodes that the replication is up and running both for HA and for Federation:

.. prompt:: bash $ auto

    $ mysql -u root -p -e "SHOW ALL SLAVES STATUS \G" | grep -E 'Connection_name|_Running'
                  Connection_name: zone0-master1
                 Slave_IO_Running: Yes
                Slave_SQL_Running: Yes
                  Connection_name: zone0-master2
                 Slave_IO_Running: Yes
                Slave_SQL_Running: Yes
                  Connection_name: zone<ZONE_ID>-<master|slave>
                 Slave_IO_Running: Yes
                Slave_SQL_Running: Yes

If `Slave_IO_Running` or `Slave_SQL_Running` is not `Yes`, then the replication is not running.

Failover Scenario
--------------------------------------------------------------------------------

Should a failover event take place, the OpenNebula service will balance normally and everything will work. However, when the fenced node is brought up again, it should **not** be configured to enter the cluster automatically. It is very important that the node only enters the cluster again only if the replication is up to date, that is, only if `Slave_IO_Running` or `Slave_SQL_Running` are set to `Yes`.

.. |image0| image:: /images/ha_fed_opennebula.png




