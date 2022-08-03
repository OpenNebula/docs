.. _service_overview:

========
Overview
========

.. _one_service_appliance:

Service appliance
-----------------

The service appliances extend the OpenNebula `Marketplace <https://marketplace.opennebula.io/>`_ with easy-to-use deployable services. These are the images with all necessary packages installed for the service run, but they go through the final configuration on the very first run on the users' side. It allows to customize the final service state by the cloud user via special contextualization parameters.

Thanks to the dynamic nature of the service appliances, no security credentials are persisted in the distributed appliances. Initial passwords are provided via the contextualization parameters or are dynamically generated for each new virtual machine. No two virtual machines with default contextualization parameters share the same passwords or database credentials.

Each service appliance comes with the script which does the heavy lifting of bringing the service up.

.. _one_service_script:

Life Cycle
----------

Every appliance goes through the following stages:

1. :ref:`install <one_service_stage_install>` (build time)
2. :ref:`configure <one_service_stage_configure>` (instantiation time)
3. :ref:`bootstrap <one_service_stage_bootstrap>` (instantiation time)

Each stage is handled by the shell script ``/etc/one-appliance/service`` installed in the appliance. For the **install** stage, it's triggered during the image build. For the remaining stages, it's triggered as part of the regular OS contextualization. The selected stage is an argument of this script.

To find out more about the service script and the appliance-specific contextualization parameters, run with argument ``help``:

.. prompt:: text $ auto

    $ /etc/one-appliance/service help

.. _one_service_stage_install:

Install
~~~~~~~

For the service appliances downloaded from the OpenNebula Marketplace, this stage was already done during the image build.

It's responsible for configuration of the package repositories, installation of all required packages, and download of everything the service would need for the proper start. Service isn't started nor configured, it's left on the next stages which run on the very first run in the users' environment.

**Example steps:** install Apache, MySQL, download and extract WordPress

.. _one_service_stage_configure:

Configure
~~~~~~~~~

The most important stage, which runs on every new instantiation in the users' environment. It configures the installed services on the virtual machine (with defaults or user-provided contextualization parameters), enables and runs them. At the end of this stage, the services are ready to use.

**Example steps:** create database, configure connections, setup web virtual hosts and place SSL certificates, enable and start web server and database

.. _one_service_stage_bootstrap:

Bootstrap
~~~~~~~~~

Bootstrap is an optional stage and, if available, makes additional configuration of the running service based on user-provided contextualization parameters. There are no defaults for this stage, it's skipped if all required parameters aren't specified. It offers an opportunity to streamline the service start to a fully configured service, avoiding any manual steps which would be necessary (e.g., click through the initial web wizard).

**Example steps:** configure initial WordPress blog name and administrator

.. _one_service_logs:

Reports and Logs
----------------

After the successful run of :ref:`configure <one_service_stage_configure>` and  :ref:`bootstrap <one_service_stage_bootstrap>` stages, you can find service-related information (credentials, connection settings) in the file ``/etc/one-appliance/config``. If any of the stages fail, there are debug logs for each stage which can help with problem troubleshooting:

- ``/var/log/one-appliance/ONE_install.log``
- ``/var/log/one-appliance/ONE_configure.log``
- ``/var/log/one-appliance/ONE_bootstrap.log``
