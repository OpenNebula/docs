.. _upgrade_federation:

================================================================================
Upgrading a Federation
================================================================================

.. todo: Describe federation update due to PostgreSql support

..
    TYPE A. NO CHANGES IN FEDERATION TABLES

    This version of OpenNebula does not modify the federation data model. You can upgrade each zone asynchronously following the corresponding guide:

    * :ref:`Follow the upgrading for single front-end deployments <upgrading_single>`
    * :ref:`Follow the upgrading for high availability clusters <upgrading_ha>`


..
    TYPE B. CHANGES IN FEDERATION TABLES

This version of OpenNebula introduces some changes in the federation data model. You need to coordinate the upgrade across zones and upgrade them at the same time.


Step 1. Check Federation Status
================================================================================

Check that federation is in sync and all zones are at the same index (FED_INDEX):

.. prompt:: text # auto

    # onezone list
    C   ID NAME                                         ENDPOINT                                      FED_INDEX
       101 S-US-CA                                      http://192.168.150.3:2633/RPC2                715438
       100 S-EU-GE                                      http://192.168.150.2:2633/RPC2                715438
    *    0 M-EU-FR                                      http://192.168.150.1:2633/RPC2                715438

It is a good idea to prevent any API access to the master zone during this step (e.g. by filtering out access to API).

Step 2. Stop All Zones
================================================================================

Stop OpenNebula and any other related services you may have running: OneFlow, EC2, and Sunstone, **in all zones**. Preferably use the system tools, like `systemctl` or `service` as `root` in order to stop the services.

Step 3. Upgrade Zones
================================================================================

You can upgrade now each zone following the corresponding guide. The master zone **must be the last one to upgrade**:

    * :ref:`Follow the upgrading for single front-end deployments <upgrade_single>`
    * :ref:`Follow the upgrading for high availability clusters <upgrade_ha>`

You will restart OpenNebula in each zone as part of the upgrade. Once you finish upgrading your master remove any access restriction to the API imposed in Step 1.
