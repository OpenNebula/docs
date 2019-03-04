
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

Password Hashing Algorithm Update
---------------------------------
User passwords and login tokens are now generated using SHA256 instead of SHA1. OpenNebula core will update users passwords
in the database when they first login in the system. It is recommened to request your users to login after the upgrade.
