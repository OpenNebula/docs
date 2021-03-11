==============
Advanced Usage
==============

This section describes all options on how to adjust the generation of the support bundle.

.. _supp_bundle_advanced:

Generate Support Bundle
=======================

The purpose of the ``onesupport`` tool is to gather as much as possible information about the environment so that customer support can give more accurate and faster responses. The usage is very simple, there are only a few configuration options. All are described in brief documentation available via argument ``--help``.

.. prompt:: bash $ auto

    $ sudo onesupport --help
    onesupport [host types] [dump types]

    Host types:
      all           ... start on frontend and inspect all hosts (default)
      frontend      ... gather only frontend specific data
      host          ... gather only KVM host specific data

    Dump types:
      nodb, db      ... (don't) dump database (ONE)
      noconf, conf  ... (don't) dump configuration (ONE, libvirt, Apache/NGINX)
      nologs, logs  ... (don't) dump logs (ONE and system logs)


There are 2 types of arguments to specify:

- **host type**
- **dump type**

Host Types
----------

What data are gathered depends mainly on the type of host we are running tool on. Each host type gets same common data (operating system, hardware, memory, installed software packages, system services, mounts, logs etc.) and differs only in data specific for the type.

Available options are:

+---------------+--------------------------------------------------------------------------------+
| Option        | Main Subject                                                                   |
+===============+================================================================================+
| ``frontend``  | OpenNebula front-end services configuration and state, database                |
|               | dump, various entities (e.g., VMs).                                            |
+---------------+--------------------------------------------------------------------------------+
| ``host``      | Virtualization services (libvirt, KVM) and network configuration.              |
+---------------+--------------------------------------------------------------------------------+
| ``all``       | Combination of ``frontend`` mode and ``host`` mode.                            |
|               | It starts with front-end specific data and connects to each virtualization     |
|               | host to get host-specific data. This mode is the **default**.                  |
+---------------+--------------------------------------------------------------------------------+

Examples
~~~~~~~~

Simple run gathers all information (runs are equivalent):

.. prompt:: bash $ auto

    $ sudo onesupport
    $ sudo onesupport all

Get only front-end specific data, must be run on front-end:

.. prompt:: bash $ auto

    $ sudo onesupport frontend

Get only host-specific data, must be run on virtualization host:

.. prompt:: bash $ auto

    $ sudo onesupport host

Dump Types
----------

Level of detail contained in the gathered data can be adjusted by dump type parameters. Following dump types are supported:

+----------------------+-------------------------------------------------------------------------+
| Option               | Description                                                             |
+======================+=========================================================================+
| ``db``, ``nodb``     | Enable / disable database dumps.                                        |
+----------------------+-------------------------------------------------------------------------+
| ``conf``, ``noconf`` | Enable / disable bundling of configuration files.                       |
+----------------------+-------------------------------------------------------------------------+
| ``logs``, ``nologs`` | Enable / disable bundling of logs.                                      |
+----------------------+-------------------------------------------------------------------------+

All dump types are enabled by default (``db conf logs``), but can be selectively disabled with negative options ``nodb``, ``noconf`` and/or ``nologs``.

.. important::

    If positive dump types (``db``, ``conf``, ``logs``) are used on the command line, only the specified types are gathered and no other ones.

    If negative dump types (``nodb``, ``noconf``, ``nologs``) are used, these types are excluded from the support bundle. All the rest types are included.

Examples
~~~~~~~~

Simple run gathers all information (runs are equivalent):

.. prompt:: bash $ auto

    $ sudo onesupport
    $ sudo onesupport db conf logs

Get support bundle without any database dumps and logs:

.. prompt:: bash $ auto

    $ sudo onesupport nodb nologs

Get support bundle with database dump, but no logs and configurations:

.. prompt:: bash $ auto

    $ sudo onesupport db

Dump types and host types parameters can be combined

.. prompt:: bash $ auto

    $ sudo onesupport frontend nodb
