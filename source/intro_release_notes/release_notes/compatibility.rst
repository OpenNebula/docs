
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 5.9.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or prone to cause confusion. You can check the upgrade process in the following :ref:`section <upgrade>`

Visit the :ref:`Features list <features>` and the `Release Notes <http://opennebula.org/software/release/>`_ for a comprehensive list of what's new in OpenNebula 5.9.

Network Driver actions interface
--------------------------------
The way arguments are passed to the pre/post/clean/update_sg has changed as follows:

- The old argument 1 ``vm xml template`` it is now sent through by ``stdin``
- The old argument 2 ``vm deploy id`` now is argument 1
- There is no argument 2

This change has been introduced `because of this bug <https://github.com/OpenNebula/one/issues/2851>`_.

Bridge Interface options
------------------------
As ``Bridge utils (brctl)`` bacame obsolete they were replaced by ``ip-route2``. Bridge options for ``ip command`` could be specified in ``:ip_bridge_conf`` but for backward compatibility the section ``:bridge_conf`` is still accepted and options are transformed to the ``ip-route2`` format.

Password Hashing Algorithm Update
---------------------------------
User passwords and login tokens are now generated using SHA256 instead of SHA1. OpenNebula core will update users passwords
in the database when they first login in the system. It is recommened to request your users to login after the upgrade.

Packages
--------

OpenNebula now ships with distribution packages for all required Ruby gems, executing of the ``install_gems`` script after installation or upgrade is not necessary anymore. Ruby dependencies are installed into a dedicated directory ``/usr/share/one/gems-dist/`` and OpenNebula uses them exclusively via symlinked location ``/usr/share/one/gems/``. **System-wide Ruby gems are not used anymore!** Any Ruby gems needed by the custom drivers need to be installed again into a new dedicated location. Check the details in :ref:`Front-end Installation <ruby_runtime>`.

If Sunstone is running via Passenger in Apache, it might be necessary to set ``GEMS_HOME`` and ``GEMS_PATH`` environment variables to ``/usr/share/one/gems/`` to force the Ruby running inside the web server to use these new location. Check the details in :ref:`Sunstone for Large Deployments <suns_advance>`.

IPAM Drivers
------------

IPAM driver scripts now recieve the template of the AR via STDIN instead of via arguments.

OpenNebula Core
---------------

The ``DEFAULT_DEVICE_PREFIX`` configuration variable is now set to ``sd`` by default.

Hooks
---------------

.. TODO Extend this section with to link to the upgrade guide with specific upgrade instructions for each hook

.. TODO Extend upgrade guide with detailed examples to upgrade hooks

Hooks are not managed via oned.conf anymore. Currently the hooks need to be created by using the API or CLI so any hook defined in the oned.conf will need to be created.

Also, the hooks definition has changed. Currently the only way to set a Hook for other resources than VM or Host is via :ref:`API Hooks <api_hooks>` (e.g `ON=CREATE` hook for user now will be an API hook for `one.user.allocate` call).

The hooks for VMs and Hosts are defined the same way than before, but it's needed to define a hook template and create it as mentioned before. More info about State Hooks are available :ref:`here <state_hooks>`

The ``$ID`` attribute is not supported anymore so the ID of the resource must be retrieved from the resource template.


