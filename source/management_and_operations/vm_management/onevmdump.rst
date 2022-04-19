.. _onevmdump:

================================================================================
onevmdump Tool
================================================================================

.. warning:: This tool is at Technology Preview stage, it's not recommended for production environments.

``onevmdump`` tool can be used for exporting VMs into a bundle file which will contains the VM definition (XML body) and the contents of the VM disks. This bundle file can be later used to restore the VM.

.. note:: The tool is intended to work with every supported hypervisor in the future. But at this moment it's only being tested for KVM based VMs.

Exporting VMs
================================================================================

``onevmdump export`` command can be used for exporting the VM into a bundle file containing a copy of the estate of each of the VM disks and the VM definition (i.e XML body) at the moment of the command execution.

.. prompt:: text $ auto

    $ tar -ztvf /tmp/onevmdump-8-1650272211.tar.gz
    drwx------ oneadmin/oneadmin 0 2022-04-18 08:56 ./
    -rw-r--r-- oneadmin/oneadmin 268435456 2022-04-18 08:56 ./backup.disk.0
    -rw-rw-r-- oneadmin/oneadmin      7431 2022-04-18 08:56 ./vm.xml


VMs can be exported in any of the following states: ``RUNNING``, ``POWEROFF``, ``UNDEPLOYED``.

Available options
--------------------------------------------------------------------------------

+-----------------------------------------+------------------------------------------------------------------------------------------+
|                  Option                 |                                     Description                                          |
+=========================================+==========================================================================================+
|``-d``, ``--destination-path=PATH``      | Path where the bundle will be created (default /tmp)                                     |
+-----------------------------------------+------------------------------------------------------------------------------------------+
| ``--destination-host=HOST``             | Destination host for the bundle                                                          |
+-----------------------------------------+------------------------------------------------------------------------------------------+
| ``-L``, ``--no-lock``                   | Avoid locking the VM while doing the backup (another security messures should be taken   |
|                                         | to avoid un expected status changes.)                                                    |
+-----------------------------------------+------------------------------------------------------------------------------------------+
| ``--destination-user=USER``             | Remote user for accessing destination host via SSH                                       |
+-----------------------------------------+------------------------------------------------------------------------------------------+
| ``-h``, ``--remote-host=HOST``          | Remote host, used when the VM storage is not available from the curren node              |
+-----------------------------------------+------------------------------------------------------------------------------------------+
| ``-l``, ``--remote-user=USER``          | Remote user for accessing remote host via SSH                                            |
+-----------------------------------------+------------------------------------------------------------------------------------------+
| ``--stdin``                             | Instead of retrieving the VM XML querying the endpoint, it will be readed from STDIN.    |
|                                         | The VM id will be automatically retrieved from the XML                                   |
+-----------------------------------------+------------------------------------------------------------------------------------------+


Restoring VMs
================================================================================

``onevmdump restore`` commands allows to restore a VM from a bundle file. It will uncompress the file, register the disk files as new OpenNebula Images and create a new VM Template from the VM definition.

Available options
--------------------------------------------------------------------------------

+-----------------------------------------+------------------------------------------------------------------------------------------+
|                  Option                 |                                     Description                                          |
+=========================================+==========================================================================================+
| ``--instantiate``                       | Instantiate backup resulting template automatically                                      |
+-----------------------------------------+------------------------------------------------------------------------------------------+
| ``-n``, ``--name=NAME``                 | Name for the resulting VM Template                                                       |
+-----------------------------------------+------------------------------------------------------------------------------------------+
| ``--restore-nics``                      | Force restore of original VM NICs                                                        |
+-----------------------------------------+------------------------------------------------------------------------------------------+

Supported Drivers
================================================================================

The following storage types are supported by ``onevmdump``:

+-----------------------------------------+------------------------------------------------------------------------------------------+
|                  Storage                |                                     Description                                          |
+=========================================+==========================================================================================+
| FILE                                    | Depending on the FILE type, either ``raw`` or ``qcow2``, a plain file copy or            |
|                                         | libvirt/qemu-img tools are used                                                          |
+-----------------------------------------+------------------------------------------------------------------------------------------+
| LVM                                     | LVM snapshot are used to reduce the file system freeze time while copying the disks when |
|                                         | the VM is running. When the VM is not running the data is just dumped from the LV.       |
+-----------------------------------------+------------------------------------------------------------------------------------------+
| RBD                                     | Libvirt and rbd tools are used.                                                          |
+-----------------------------------------+------------------------------------------------------------------------------------------+


Extending onevmdump
================================================================================

.. warning:: Note that as the tool is still in Technology Preview stage and under development for improvements, the information below might change slightly.

The ``onevmdump`` tool source code is structured like shown below:

.. prompt:: text $ auto

  $ tree src/onevmdump
  src/onevmdump
  ├── lib
  │   ├── command.rb
  │   ├── commons.rb
  │   ├── exporters
  │   │   ├── base.rb
  │   │   ├── file.rb
  │   │   ├── lv.rb
  │   │   └── rbd.rb
  │   └── restorers
  │       └── base.rb
  ├── onevmdump
  └── onevmdump.rb

onevmdump
--------------------------------------------------------------------------------

The ``onevmdump`` script implement the main logic of the tool, while ``onevmdum.rb`` implement the module importing every supported exporter and restorers classes and static method to automatically get the implementation corresponding to the right ``TM_MAD`` driver.

Exporters
--------------------------------------------------------------------------------

The ``exporters`` folder contains the export implementation for every supported storage mean. The ``base.rb`` exporter implement common methods for every exporter.

In order to implement support for a new storage mean the corresponding exporter needs to be added under the exporters folder containing the logic for exporting the VM disks into plain files, once the exporter is ready it must be imported in ``onevmdump.rb`` and the corresponding ``get_exporter`` method needs to be updated to take the new exporter into account.

Restorers
--------------------------------------------------------------------------------

The base restorer class take care of registering the exported VM disks files into the same Image Datastore where the original images was stored. Hence no extra implementation should be require as long as the existing ``DS_MAD`` driver support it.
