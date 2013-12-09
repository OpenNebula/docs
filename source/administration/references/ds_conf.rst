=======================
Datastore configuration
=======================

Datastores can be parametrized with several parameters. In the following
list there are the meaning of the different parameters for all the
datastores.

-  **RESTRICTED\_DIRS**: Paths not allowed for image importing
-  **SAFE\_DIRS**: Paths allowed for image importing
-  **NO\_DECOMPRESS**: Do not decompress images downloaded
-  **LIMIT\_TRANSFER\_BW**: Maximum bandwidth used to download images.
By default is bytes/second but you can use k, m and g for
kilo/mega/gigabytes.
-  **BRIDGE\_LIST**: List of hosts used for image actions. Used as a
roundrobin list.
-  **POOL\_NAME**: Name of the Ceph pool to use
-  **VG\_NAME**: Volume group to use
-  **BASE\_IQN**: iscsi base identifier
-  **STAGING\_DIR**: Temporary directory where images are downloaded
-  **DS\_TMP\_DIR**: Temporary directory where images are downloaded
-  **CEPH\_HOST**: Space-separated list of Ceph monitors.
-  **CEPH\_SECRET**: A generated UUID for a LibVirt secret.
-  **LIMIT\_MB**: Limit, in MB, of storage that OpenNebula will use for
this datastore

Not all these parameters have meaning for all the datastores. Here is
the matrix of parameters accepted by each one:

+-----------------------+--------+-------+---------+-------+--------+
| Parameter             | ceph   | fs    | iscsi   | lvm   | vmfs   |
+=======================+========+=======+=========+=======+========+
| RESTRICTED\_DIRS      | yes    | yes   | yes     | yes   | yes    |
+-----------------------+--------+-------+---------+-------+--------+
| SAFE\_DIRS            | yes    | yes   | yes     | yes   | yes    |
+-----------------------+--------+-------+---------+-------+--------+
| NO\_DECOMPRESS        | yes    | yes   | yes     | yes   | yes    |
+-----------------------+--------+-------+---------+-------+--------+
| LIMIT\_TRANSFER\_BW   | yes    | yes   | yes     | yes   | yes    |
+-----------------------+--------+-------+---------+-------+--------+
| BRIDGE\_LIST          | -      | yes   | -       | -     | -      |
+-----------------------+--------+-------+---------+-------+--------+
| POOL\_NAME            | yes    | -     | -       | -     | -      |
+-----------------------+--------+-------+---------+-------+--------+
| VG\_NAME              | -      | -     | yes     | yes   | -      |
+-----------------------+--------+-------+---------+-------+--------+
| BASE\_IQN             | -      | -     | yes     | -     | -      |
+-----------------------+--------+-------+---------+-------+--------+
| STAGING\_DIR          | yes    | -     | -       | -     | -      |
+-----------------------+--------+-------+---------+-------+--------+
| DS\_TMP\_DIR          | yes    | -     | -       | -     | -      |
+-----------------------+--------+-------+---------+-------+--------+
| CEPH\_HOST            | yes    | -     | -       | -     | -      |
+-----------------------+--------+-------+---------+-------+--------+
| CEPH\_SECRET          | yes    | -     | -       | -     | -      |
+-----------------------+--------+-------+---------+-------+--------+
| LIMIT\_MB             | yes    | yes   | yes     | yes   | yes    |
+-----------------------+--------+-------+---------+-------+--------+

