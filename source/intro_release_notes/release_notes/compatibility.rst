
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.6.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`. If upgrading from previous versions, please make sure you read all the intermediate versions' Compatibility Guides for possible pitfalls.

Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 7.0.

..
    Database
    =========================
    - The table ``vm_pool`` now contains the column ``json_body`` which provides searching for values using JSON keys, and no longer contains the ``search_token`` column, effectively removing FULLTEXT searching entirely. This should greatly improve performance when performing search filters on virtual machines as well as remove the need for regenerating FULLTEXT indexing.  Due to this change, the search now uses a JSON path to search, for example: ``VM.NAME=production`` would match all VM's which have name containing ``production``.
    - The migrator has been updated to make these changes automatically with the ``onedb upgrade`` tool. When tested on a database containing just over 150,000 VM entries, the upgrade took roughly 4100 seconds using an HDD and about 3500 seconds using a ramdisk.

Configuration Files Headers
================================================================================

In order to avoid breaking compatibility with older versions of OpenNebula headers have been removed from all the configuration files. This change will be taken care transparently by the onecfg tool, but it will show in manual diffs with older versions of the configuration files.

::

  /* -------------------------------------------------------------------------- */
  /* Copyright 2002-2023, OpenNebula Project, OpenNebula Systems                */
  /*                                                                            */
  /* Licensed under the Apache License, Version 2.0 (the "License"); you may    */
  /* not use this file except in compliance with the License. You may obtain    */
  /* a copy of the License at                                                   */
  /*                                                                            */
  /* http://www.apache.org/licenses/LICENSE-2.0                                 */
  /*                                                                            */
  /* Unless required by applicable law or agreed to in writing, software        */
  /* distributed under the License is distributed on an "AS IS" BASIS,          */
  /* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   */
  /* See the License for the specific language governing permissions and        */
  /* limitations under the License.                                             */
  /* -------------------------------------------------------------------------- */


Datastore Drivers Arguments
================================================================================

Datastore driver actions take the information from stdin to prevent a ``Argument list too long`` error when there is a large number of images in a datastore. All configuration and driver files has been updated and no special action needs to be performed. However if you have develop your own datastore drivers those should be updated accordingly.

CLI
================================================================================

Some CLI commands that accept template files are able to receive the same template via STDIN, thus bypassing the need of a temporary file to hold the template contents. This means the file argument is now optional
and the OpenNebula CLI will check for STDIN if the file argument is missing.
