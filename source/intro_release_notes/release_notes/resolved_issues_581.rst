.. _resolved_issues_581:

Resolved Issues in 5.8.1
--------------------------------------------------------------------------------

A complete list of solved issues for 5.8.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/24>`__.

The following new features has been backported to 5.8.1:

- `Add timepicker in relative scheduled actions <https://github.com/OpenNebula/one/issues/2961>`__.
- `Check vCenter cluster health in monitoring <https://github.com/OpenNebula/one/issues/2968>`_
- `Updated ceph requirements for LXD setups <https://github.com/OpenNebula/one/issues/2998>`_
- `Improved loggig in LXD actions <https://github.com/OpenNebula/one/issues/3099>`_

The following issues has been solved in 5.8.1:

- `Fix an issue that could make oned to crash when creating a Virtual Network <https://github.com/OpenNebula/one/issues/2985>`__.
- `Fix an issue with the generation of the short body at the DB migrator <https://github.com/OpenNebula/one/issues/2995>`__.
- `Fix an issue with oneprovision batch mode <https://github.com/OpenNebula/one/issues/2964>`__.
- `Fix an issue with oneprovision ansible errors <https://github.com/OpenNebula/one/issues/3002>`__.
- `Fix an issue with oneprovision custom ansible connection parameters <https://github.com/OpenNebula/one/issues/3005>`__.
- `Fix an issue where VIRTIO_SCSI_QUEUES parameter is not updated through Update Configuration <https://github.com/OpenNebula/one/issues/2880>`__.
- `Fix an issue in MarketPlace where obsolote apps weren't deleted <https://github.com/OpenNebula/one/issues/3017>`__.
- `Fix an issue that prevents qcow2 datastores to work in ssh mode. You need to trigger a datastore update (e.g. onedatastore update <ds_id>, and exit without changes will do) to load the new attributes <https://github.com/OpenNebula/one/issues/3038>`__.
- `Fix bug in vcenter_downloader failing to download vcenter images <https://github.com/OpenNebula/one/issues/3044>`__.
- `Packaged Passenger can't be installed <https://github.com/OpenNebula/one/issues/2994>`__.
- `Fix and issue in MarketPlace where all apps needs an image to import <https://github.com/OpenNebula/one/issues/1666>`__.
- `Fix and issue in Linuxcontainers MarketPlace that didn't update the appliance list <https://github.com/OpenNebula/one/issues/3060>`__.
- `Fix an issue with LXD VNC connection in Ubuntu 1810 <https://github.com/OpenNebula/one/issues/3069>`_.
- `Fix an issue in provision with retry option <https://github.com/OpenNebula/one/issues/3068>`__.
- `Fix an issue where LXD marketplace was opening too many connections. <https://github.com/OpenNebula/one/issues/3014>`_
- `Fix authentication errors due to misapplied LXD snap patch <https://github.com/OpenNebula/one/issues/3029>`_
- `Fix an error when monitoring the size of a ceph pool if it has quotas <https://github.com/OpenNebula/one/issues/1232>`_
- `Fix return code for oned <https://github.com/OpenNebula/one/issues/3088>`_
- `Fix svncterm child process exit routine so it does not segfault <https://github.com/OpenNebula/one/issues/3052>`_
- `Fix LXD misbehaving when having an openvswitch nic <https://github.com/OpenNebula/one/issues/3058>`_
- `Fix XFS LXD images faling to be replicated due to having the same fs uuid <https://github.com/OpenNebula/one/issues/3103>`_
- `Fix LXD storage error handling when deploy failed to start the container <https://github.com/OpenNebula/one/issues/3098>`_
- `Fix an issue so hourly sched action executes just one time <https://github.com/OpenNebula/one/issues/3119>`__.
- `Fix leader transition for big log sizes <https://github.com/OpenNebula/one/issues/3123>`_
- `Fix missing wait_for_completion in some vCenter async tasks <https://github.com/OpenNebula/one/issues/3125>`_
- `Fix an issue with LXD raw images on NFS datastores <https://github.com/OpenNebula/one/issues/3127>`_
- `Fix typo in oneflow CLI <https://github.com/OpenNebula/one/issues/3086>`__.
- `Fix an issue of LVM datastore when LV remove was called on frontend for undeployed VM <https://github.com/OpenNebula/one/issues/2981>`_
