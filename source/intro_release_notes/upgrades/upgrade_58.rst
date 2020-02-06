=================================
Upgrading from OpenNebula 5.8.x
=================================

This section describes the installation procedure for systems that are already running a 5.8.x OpenNebula. The upgrade to OpenNebula |version| can be done directly following this section; you don't need to perform intermediate version upgrades. The upgrade will preserve all current users, hosts, resources and configurations, for both Sqlite and MySQL backends.

Read the :ref:`Compatibility Guide <compatibility>` and `Release Notes <http://opennebula.org/software/release/>`_ to know what is new in OpenNebula |version|.


Upgrading Single Front-end Deployments
================================================================================

Step 1. Check Virtual Machine Status
--------------------------------------------------------------------------------
Before proceeding, make sure you don't have any VMs in a transient state (prolog, migr, epil, save). Wait until these VMs get to a final state (runn, suspended, stopped, done). Check the :ref:`Managing Virtual Machines guide <vm_guide_2>` for more information on the VM life-cycle.

Step 2. Stop OpenNebula
--------------------------------------------------------------------------------
Stop OpenNebula and any other related services you may have running: OneFlow, EC2, and Sunstone. Preferably use the system tools, like `systemctl` or `service` as `root` in order to stop the services.


Step 3. Backup OpenNebula Configuration
--------------------------------------------------------------------------------
Backup the configuration files located in **/etc/one** and **/var/lib/one/remotes/etc**. You don't need to do a manual backup of your database, the ``onedb`` command will perform one automatically.

.. prompt:: text # auto

    # cp -r /etc/one /etc/one.$(date +'%Y-%m-%d')
    # cp -r /var/lib/one/remotes/etc /var/lib/one/remotes/etc.$(date +'%Y-%m-%d')

Step 4. Upgrade to the New Version
--------------------------------------------------------------------------------

Upgrade the OpenNebula software using the package manager of your OS. Refer to the :ref:`Installation guide <ignc>` for a complete list of the OpenNebula packages installed in your system. Package repos need to be pointing to the latest version (|version|).

Ubuntu/Debian

.. prompt:: text # auto

    # apt-get install --only-upgrade opennebula opennebula-sunstone opennebula-gate opennebula-flow python-pyone

CentOS

.. prompt:: text # auto

    # yum upgrade opennebula-server opennebula-sunstone opennebula-ruby opennebula-gate opennebula-flow


Step 5. Update Configuration Files
--------------------------------------------------------------------------------
If you haven't modified any configuration files, you can skip this step and proceed to the next one.

In order to update the configuration files with your existing customizations you'll need to:

#. Compare the old and new configuration files: ``diff -ur /etc/one.YYYY-MM-DD /etc/one`` and ``diff -ur /var/lib/one/remotes/etc.YYYY-MM-DD /var/lib/one/remotes/etc``. You can use graphical diff-tools like ``meld`` to compare both directories, which are very useful in this step.
#. Edit the **new** files and port all the customizations from the previous version.

Step 6. Upgrade the Database version
--------------------------------------------------------------------------------
.. note:: Make sure at this point that OpenNebula is not running. If you installed from packages, the service may have been started automatically.

Simply run the ``onedb upgrade -v`` command. The connection parameters have to be supplied with the command line options, see the :ref:`onedb manpage <cli>` for more information. For example:

.. prompt:: text $ auto

    $ onedb upgrade -v -S localhost -u oneadmin -p oneadmin -d opennebula

Step 6.1 Possible character set issues
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the upgrade command outputs a message similar to: ``Table and database charset (latin1, utf8mb4) differs``. You'll need to adjust the encoding of your database to match that used by the tables. This may happen when upgrading your MySQL version.

First, check the encoding of the opennebula DB tables with the following query:

.. code-block:: sql

    select CCSA.character_set_name FROM information_schema.`TABLES` T, information_schema.`COLLATION_CHARACTER_SET_APPLICABILITY` CCSA WHERE CCSA.collation_name = T.table_collation AND T.table_schema = "opennebula" AND T.table_name = "system_attributes"


Example output:

.. code-block:: sql

    MariaDB [opennebula]> select CCSA.character_set_name FROM information_schema.`TABLES` T,    information_schema.`COLLATION_CHARACTER_SET_APPLICABILITY` CCSA WHERE CCSA.collation_name = T.table_collation AND T.table_schema =     "opennebula" AND T.table_name = "system_attributes"
        -> ;
    +--------------------+
    | character_set_name |
    +--------------------+
    | utf8mb4            |
    +--------------------+
    1 row in set (0.00 sec)

Now, check the database encoding:

.. code-block:: sql

    select default_character_set_name FROM information_schema.SCHEMATA where schema_name = "opennebula"

Example output

.. code-block:: sql

    MariaDB [opennebula]> select default_character_set_name FROM information_schema.SCHEMATA where schema_name = "opennebula"
    -> ;
    +----------------------------+
    | default_character_set_name |
    +----------------------------+
    | latin1                    |
    +----------------------------+
    1 row in set (0.00 sec)

Then, change the database encoding to match the one on the system properties table, in our example from latin1 to utf8mb4:

.. code-block:: sql

    ALTER DATABASE opennebula CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

Step 7. Check DB Consistency
--------------------------------------------------------------------------------
First, move the |version| backup file created by the upgrade command to a safe place. If you face any issues, the ``onedb`` command can restore this backup, but it won't downgrade databases to previous versions. Then execute the ``onedb fsck`` command, providing the same connection parameter used during the database upgrade:

.. code::

    $ onedb fsck -S localhost -u oneadmin -p oneadmin -d opennebula
    MySQL dump stored in /var/lib/one/mysql_localhost_opennebula.sql
    Use 'onedb restore' or restore the DB using the mysql command:
    mysql -u user -h server -P port db_name < backup_file

    Total errors found: 0


Step 8. Start OpenNebula
--------------------------------------------------------------------------------

Make the system re-read the service configuration files of the new packages:

.. prompt:: text # auto

    # systemctl daemon-reload

Now you should be able to start OpenNebula as usual, running ``service opennebula start`` as ``root``. Do not forget to restart also any associated service like Sunstone, OneGate or OneFlow.

At this point OpenNebula will continue the monitoring and management of your previous Hosts and VMs.  As a measure of caution, look for any error messages in ``oned.log``, and check that all drivers are loaded successfully. You may also try some  **show** subcommand for some resources to check everything is working (e.g. ``onehost show``, or ``onevm show``).

Step 9. Update ServerAdmin password to SHA256
--------------------------------------------------------------------------------

Since 5.10 passwords and tokens are generated using SHA256. OpenNebula will update the DB automatically for your regular users (including oneadmin). However, you need to do the update for serveradmin manually. You can do so, with:

.. prompt:: text # auto

    $ oneuser passwd --sha256 serveradmin `cat /var/lib/one/.one/sunstone_auth|cut -f2 -d':'`


Step 10. Update the Hypervisors (LXD & KVM only)
------------------------------------------------

First update the virtualization, storage and networking drivers.  As the ``oneadmin`` user execute:

.. prompt:: text $ auto

   $ onehost sync

Then log into your hypervisor hosts and update the ``opennebula-node`` packages:

Ubuntu/Debian

.. prompt:: text # auto

    # apt-get install --only-upgrade opennebula-node
    # service libvirtd restart # debian
    # service libvirt-bin restart # ubuntu

If upgrading the LXD drivers on Ubuntu

.. prompt:: text # auto

    # apt-get install --only-upgrade opennebula-node-lxd

CentOS

.. prompt:: text # auto

    # yum upgrade opennebula-node-kvm
    # systemctl restart libvirtd

Upgrading High Availability Clusters
================================================================================

Step 1. Stop the HA Cluster
--------------------------------------------------------------------------------

You need to stop all the nodes in the cluster to upgrade them at the same time. Start from the followers and leave the leader to the end.

Step 2. Upgrade the Leader
--------------------------------------------------------------------------------

Follow Steps 3 to 7 described in the previous Section (Upgrading Single Front-end deployments). Finally create a database backup to replicate the *upgraded* state to the followers:

.. prompt:: bash $ auto

  $ onedb backup -u oneadmin -p oneadmin -d opennebula
  MySQL dump stored in /var/lib/one/mysql_localhost_opennebula_2019-9-27_11:52:47.sql
  Use 'onedb restore' or restore the DB using the mysql command:
  mysql -u user -h server -P port db_name < backup_file

Step 3. Upgrade OpenNebula in the Followers
--------------------------------------------------------------------------------

Upgrade OpenNebula packages as described in Step 4 in the previous section (Upgrading Single Front-end deployments)

Step 4. Replicate Database and configuration
--------------------------------------------------------------------------------

Copy the database backup of the leader to each follower and restore it:

.. prompt:: bash $ auto

  $ scp /var/lib/one/mysql_localhost_opennebula_2019-9-27_11:52:47.sql <follower_ip>:/tmp

  $ onedb restore -f -u oneadmin -p oneadmin -d opennebula /tmp/mysql_localhost_opennebula_2019-9-27_11:52:47.sql
  MySQL DB opennebula at localhost restored.

Synchronize the configuration files to the followers:

.. prompt:: bash $ auto

  $ rsync -r /etc/one root@<follower_ip>:/etc

  $ rsync -r /var/lib/one/remotes/etc root@<follower_ip>:/var/lib/one/remotes

Step 5. Start OpenNebula in the Leader and Followers
--------------------------------------------------------------------------------

Start OpenNebula in the followers as described in Step 8 in the previous section (Upgrading Single Front-end deployments).


Step 6. Check Cluster Health
--------------------------------------------------------------------------------

At this point the ``onezone show`` command should display all the followers active and in sync with the leader.

Step 7. Update the Hypervisors (KVM & LXD)
--------------------------------------------------------------------------------

Finally upgrade the hypervisors as described in Step 9 in the previous section (Upgrading Single Front-end deployments).

Upgrading a Federation
================================================================================

This version of OpenNebula does not upgrade the shared database schema. The federation can be upgraded zone by zone. For each zone please follow the previous procedure that applies to your setup.


.. _update_hooks:

Update your Hooks
================================================================================

Hooks are no longer defined in ``oned.conf``. You need to recreate any hook you are using in the OpenNebula database. Specific upgrade actions for each hook type are described below.

RAFT/HA Hooks
--------------------------------------------------------------------------------
HA Hooks keep working as they did in previous versions. For design reasons, these are the only hooks which need to be defined in ``oned.conf`` and cannot be managed via the API or CLI. You should preserve your previous configuration in ``oned.conf``.

Fault Tolerance Hooks
--------------------------------------------------------------------------------
In order to migrate fault tolerance hooks, just follow the steps defined in :ref:`Fault Tolerance guide <ftguide>`.

vCenter Hooks
--------------------------------------------------------------------------------
The vCenter Hooks, used for creating virtual networks, will be created automatically when needed.

Custom Hooks
--------------------------------------------------------------------------------
Custom Hooks migration strongly depends on your use case for the hook. Below there is a list of examples which represent the most common use cases.

- Create/Remove hooks. Corresponds to the legacy ``ON=CREATE`` and ``ON=REMOVE`` hooks

These hooks are now triggered by an API hook on the corresponding create/delete API call. For example, the following hook sends an email to the user when her user account is created:

.. code::

   USER_HOOK = [
       name      = "mail",
       on        = "CREATE",
       command   = "email2user.rb",
       arguments = "$ID $TEMPLATE"]

Now, in OpenNebula 5.10, you need to create the following hook template:


.. code::

    NAME      = "mail",
    TYPE      = API
    CALL      = "one.user.allocate",
    COMMAND   = "email2user.rb",
    ARGUMENTS = "$TEMPLATE"

and define the hook with ``onehook create`` command.

.. important:: To emulate the ``ON=CREATE`` hook for VMs an API hook can be defined for ``one.template.instantiate`` and ``one.vm.allocate``.

In general, any create/remove hook can be migrated using the following template:

.. code::

    NAME = hook-create-resource
    TYPE = api
    COMMAND = "<same-script-path>"
    ARGUMENTS = "<same-arguments>"
    CALL = "one.<resource>.allocate"

More information on defining :ref:`API Hooks can be found here <api_hooks>`.

- State hooks

If there is a hook defined for a Host or VM state change, the hook template has to be inferred from the Hook definition in the 5.8 ``oned.conf`` file; see the example below:

.. code::

    # Legacy hook definition in oned.conf

        VM_HOOK = [
        name      = "advanced_hook",
        on        = "CUSTOM",
        state     = "ACTIVE",
        lcm_state = "BOOT_UNKNOWN",
        command   = "log.rb",
        arguments = "$ID $PREV_STATE $PREV_LCM_STATE" ]

    # Hook template file

        NAME = advanced_hook
        TYPE = state
        COMMAND = "log.rb"
        ARGUMENTS = "$TEMPLATE"
        RESOURCE = VM
        ON = CUSTOM
        STATE = ACTIVE
        LCM_STATE = BOOT_UNKNOWN

Note that you may need to adapt the arguments of your hook, as ``$ID`` is not currently supported. More information on defining :ref:`state Hooks can be found here <state_hooks>`.

.. note:: Note that, in both examples, ``ARGUMENTS_STDIN=yes`` can be used for passing the parameters via STDIN instead of command line argument.

Restoring the Previous Version
==============================

If for any reason you need to restore your previous OpenNebula, follow these steps:

-  With OpenNebula |version| still installed, restore the DB backup using ``onedb restore -f``
-  Uninstall OpenNebula |version|, and install again your previous version.
-  Copy back the backup of ``/etc/one`` you did to restore your configuration.
