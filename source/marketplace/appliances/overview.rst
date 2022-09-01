.. _service_overview:
.. _one_service_appliance:

========
Overview
========

The public OpenNebula `Marketplace <https://marketplace.opennebula.io/>`_ includes easy-to-use appliances, which are preconfigured Virtual Machines that can be used to deploy different services. These appliance include the images with all necessary packages installed for the service run, including the :ref:`OpenNebula contextualization packages <context_overview>` and specific scripts that bring the service up on boot. This allows to customize the final service state by the cloud user via special contextualization parameters.

No security credentials are persisted in the distributed appliances. Initial passwords are provided via the contextualization parameters or are dynamically generated for each new virtual machine. No two virtual machines with default contextualization parameters share the same passwords or database credentials.

.. _one_service_script:

Appliance Life Cycle
--------------------

Every appliance goes through the following stages:

1. :ref:`Installation <one_service_stage_install>` (build time)
2. :ref:`Configuration <one_service_stage_configure>` (instantiation time)
3. :ref:`Bootstrap <one_service_stage_bootstrap>` (instantiation time)

Each stage is handled by a script installed in the appliance in ``/etc/one-appliance/service``. In the the **install** stage this script is triggered during the image build. For the remaining stages, it's triggered as part of the regular OS contextualization. The selected stage is an argument of this script.

To find out more about the service script and the appliance-specific contextualization parameters, run with argument ``help``:

.. prompt:: text $ auto

    $ /etc/one-appliance/service help

.. _one_service_stage_install:

Installation
~~~~~~~~~~~~

This stage was already done during the image build for all the appliance in the OpenNebula Marketplace. It includes the configuration of the package repositories and installation of all packages required by the service the appliance is meant to deliver.

Steps on :ref:`WordPress Appliance <service_wp>`: install Apache, MySQL, download and extract WordPress

.. _one_service_stage_configure:

Configure
~~~~~~~~~

This stage configures the installed services on the virtual machine (with defaults or user-provided contextualization parameters), enables and runs them. At the end of this stage, the services are ready to use.

Steps on :ref:`WordPress Appliance <service_wp>`: create database, configure connections, setup web virtual hosts and place SSL certificates, enable and start web server and database

.. _one_service_stage_bootstrap:

Bootstrap
~~~~~~~~~

Bootstrap is an optional stage, It makes additional configuration of the running service based on user-provided contextualization parameters. There are no defaults for this stage, it's skipped if all required parameters aren't specified.

It offers an opportunity to streamline the service start to a fully configured service, avoiding any manual steps which would be necessary (e.g., click through the initial web wizard).

Steps on :ref:`WordPress Appliance <service_wp>`: configure initial WordPress blog name and administrator

.. _one_service_logs:

Reports and Logs
----------------

After the successful run of :ref:`configure <one_service_stage_configure>` and :ref:`bootstrap <one_service_stage_bootstrap>` stages, you can find service-related information (credentials, connection settings) in the file ``/etc/one-appliance/config``. If any of the stages fail, there are debug logs for each stage which can help with problem troubleshooting:

- ``/var/log/one-appliance/ONE_install.log``
- ``/var/log/one-appliance/ONE_configure.log``
- ``/var/log/one-appliance/ONE_bootstrap.log``
