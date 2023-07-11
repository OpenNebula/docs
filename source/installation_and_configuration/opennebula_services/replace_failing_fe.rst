.. _Replace failing front-end:

=========================
Replace failing front-end
=========================

Follow this guide as the ``oneadmin`` user. To switch the user run:

.. code:: shell

    sudo -i -u oneadmin

Back up files
=============

This command has to be executed in the failing host.

Create the backup directory:

.. code:: shell

    BAK_DIR=~/one_backup
    mkdir -p $BAK_DIR

Copy configuration directory ``/etc/one`` to backup directory:

.. code:: shell

    cp -rp --parents /etc/one $BAK_DIR

Copy remotes directory ``/var/lib/one/remotes`` to backup directory:

.. code:: shell

    cp -rp --parents /var/lib/one/remotes $BAK_DIR

Copy keys directory ``/var/lib/one/.one`` to backup directory:

.. code:: shell

    cp -rp --parents /var/lib/one/.one $BAK_DIR

Back up the database:

.. code:: shell

    onedb backup -S <database_host> -u <user> -p <password> -d <database_name> -P <port>

Copy the database backup file to the backup directory:

.. code:: shell

    cp -rp <onedb_backup> $BAK_DIR


Remove failing frontend from HA
===============================

Stop all the OpenNebula services ``systemctl stop opennebula*``. This command has to be executed in the failing host.

.. code:: shell

    systemctl stop opennebula*


Remove it from HA using the CLI command onezone ``onezone server-del <zone_id> <server_id>``. This command has to be executed in the leader.

.. code:: shell

    onezone server-del <zone_id> <server_id>
    

Add the server back to the HA
=============================

To add the a replacement server into the HA cluster, please follow this
`guide <http://docs.opennebula.org/5.8/advanced_components/ha/frontend_ha_setup.html#adding-more-servers>`__.
