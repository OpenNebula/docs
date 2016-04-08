.. _accounting:

==================
Accounting Client
==================

The accounting toolset visualizes and reports resource usage data. This accounting tool addresses the accounting of the virtual resources. It includes resource consumption of the virtual machines as reported from the hypervisor.

Usage
=====

``oneacct`` - prints accounting information for virtual machines

.. code::

    Usage: oneacct [options]
      -s, --start TIME        Start date and time to take into account
      -e, --end TIME          End date and time
      -u, --user user         User id to filter the results
      -g, --group group       Group id to filter the results
      -H, --host hostname     Host id to filter the results
          --xpath expression  Xpath expression to filter the results. For example: oneacct --xpath 'HISTORY[ETIME>0]'
      -j, --json              Output in json format
      -x, --xml               Output in xml format
      --csv                   Write table in csv format
          --split             Split the output in a table for each VM
      -h, --help              Show this message

The time can be written as ``month/day/year hour:minute:second``, or any other similar format, e.g ``month/day hour:minute``.

To integrate this tool with other systems you can use ``-j``, ``-x`` or ``--csv`` flags to get all the information in an easy computer readable format.

Accounting Output
=================

The oneacct command shows individual Virtual Machine history records. This means that for a single VM you may get several accounting entries, one for each migration or stop/suspend action. A resize or disk/nic attachement will also create a new entry.

Each entry contains the complete information of the Virtual Machine, including the Virtual Machine monitoring information. By default, only network consumption is reported, see the `Tuning & Extending <#tuning-extending>`__ section for more information.

When the results are filtered with the ``-s`` and/or ``-e`` options, all the history records that were active during that time interval are shown, but they may start or end outside that interval.

For example, if you have a VM that was running from 01/01/2012 to 05/15/2012, and you request the accounting information with this command:

.. code::

    $ oneacct -s '02/01/2012' -e '01/03/2012'
    Showing active history records from Wed Feb 01 00:00:00 +0100 2012 to Tue Jan 03 00:00:00 +0100 2012

     VID HOSTNAME        REAS     START_TIME       END_TIME MEMORY CPU NET_RX NET_TX
       9 host01          none 01/01 14:03:27 05/15 16:38:05  1024K   2   1.5G    23G

The record shows the complete history record, and total network consumption. It will not reflect the consumption made only during the month of February.

Other important thing to pay attention to is that active history records, those with END\_TIME **'-'**, refresh their monitoring information each time the VM is monitored. Once the VM is shut down, migrated or stopped, the END\_TIME is set and the monitoring information stored is frozen. The final values reflect the total for accumulative attributes, like NET\_RX/TX.

Sample Output
-------------

Obtaining all the available accounting information:

.. code::

    $ oneacct
    # User 0 oneadmin

     VID HOSTNAME        REAS     START_TIME       END_TIME MEMORY CPU NET_RX NET_TX
       0 host02          user 06/04 14:55:49 06/04 15:05:02  1024M   1     0K     0K

    # User 2 oneuser1

     VID HOSTNAME        REAS     START_TIME       END_TIME MEMORY CPU NET_RX NET_TX
       1 host01          stop 06/04 14:55:49 06/04 14:56:28  1024M   1     0K     0K
       1 host01          user 06/04 14:56:49 06/04 14:58:49  1024M   1     0K   0.6K
       1 host02          none 06/04 14:58:49              -  1024M   1     0K   0.1K
       2 host02          erro 06/04 14:57:19 06/04 15:03:27     4G   2     0K     0K
       3 host01          none 06/04 15:04:47              -     4G   2     0K   0.1K

The columns are:

+-------------+---------------------------------------------------------------------------------------------+
|    Column   |                                           Meaning                                           |
+=============+=============================================================================================+
| VID         | Virtual Machine ID                                                                          |
+-------------+---------------------------------------------------------------------------------------------+
| HOSTNAME    | Host name                                                                                   |
+-------------+---------------------------------------------------------------------------------------------+
| REASON      | VM state change reason:                                                                     |
|             |                                                                                             |
|             | - **none**: Normal termination                                                              |
|             | - **erro**: The VM ended in error                                                           |
|             | - **stop**: Stop/resume request                                                             |
|             | - **user**: Migration request                                                               |
|             | - **canc**: Cancel request                                                                  |
+-------------+---------------------------------------------------------------------------------------------+
| START\_TIME | Start time                                                                                  |
+-------------+---------------------------------------------------------------------------------------------+
| END\_TIME   | End time                                                                                    |
+-------------+---------------------------------------------------------------------------------------------+
| MEMORY      | Assigned memory. This is the requested memory, not the monitored memory consumption         |
+-------------+---------------------------------------------------------------------------------------------+
| CPU         | Number of CPUs. This is the requested number of Host CPU share, not the monitored cpu usage |
+-------------+---------------------------------------------------------------------------------------------+
| NETRX       | Data received from the network                                                              |
+-------------+---------------------------------------------------------------------------------------------+
| NETTX       | Data sent to the network                                                                    |
+-------------+---------------------------------------------------------------------------------------------+

Obtaining the accounting information for a given user

.. code::

    $ oneacct -u 2 --split
    # User 2 oneuser1

     VID HOSTNAME        REAS     START_TIME       END_TIME MEMORY CPU NET_RX NET_TX
       1 host01          stop 06/04 14:55:49 06/04 14:56:28  1024M   1     0K     0K
       1 host01          user 06/04 14:56:49 06/04 14:58:49  1024M   1     0K   0.6K
       1 host02          none 06/04 14:58:49              -  1024M   1     0K   0.1K

     VID HOSTNAME        REAS     START_TIME       END_TIME MEMORY CPU NET_RX NET_TX
       2 host02          erro 06/04 14:57:19 06/04 15:03:27     4G   2     0K     0K

     VID HOSTNAME        REAS     START_TIME       END_TIME MEMORY CPU NET_RX NET_TX
       3 host01          none 06/04 15:04:47              -     4G   2     0K   0.1K

In case you use CSV output (``--csv``) you will het a header with the neame of each column and then the data. For example:

.. code::

    $ oneacct --csv
    UID,VID,HOSTNAME,ACTION,REASON,START_TIME,END_TIME,MEMORY,CPU,NET_RX,NET_TX
    3,68,esx2,none,none,02/17 11:16:06,-,512M,1,0K,0K
    0,0,piscis,none,erro,09/18 15:57:55,09/18 15:57:57,1024M,1,0K,0K
    0,0,piscis,shutdown-hard,user,09/18 16:01:55,09/18 16:19:57,1024M,1,0K,0K
    0,1,piscis,none,none,09/18 16:20:25,-,1024M,1,2G,388M
    0,2,esx1,shutdown-hard,user,09/18 19:27:14,09/19 12:23:45,512M,1,0K,0K

Output Reference
----------------

If you execute oneacct with the ``-x`` option, you will get an XML output defined by the following xsd:

.. code::

    <?xml version="1.0" encoding="UTF-8"?>
    <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified"
      targetNamespace="http://opennebula.org/XMLSchema" xmlns="http://opennebula.org/XMLSchema">
     
      <xs:element name="HISTORY_RECORDS">
        <xs:complexType>
          <xs:sequence maxOccurs="1" minOccurs="1">
            <xs:element ref="HISTORY" maxOccurs="unbounded" minOccurs="0"/>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
     
      <xs:element name="HISTORY">
        <xs:complexType>
          <xs:sequence>
            <xs:element name="OID" type="xs:integer"/>
            <xs:element name="SEQ" type="xs:integer"/>
            <xs:element name="HOSTNAME" type="xs:string"/>
            <xs:element name="HID" type="xs:integer"/>
            <xs:element name="STIME" type="xs:integer"/>
            <xs:element name="ETIME" type="xs:integer"/>
            <xs:element name="VMMMAD" type="xs:string"/>
            <xs:element name="VNMMAD" type="xs:string"/>
            <xs:element name="TMMAD" type="xs:string"/>
            <xs:element name="DS_ID" type="xs:integer"/>
            <xs:element name="PSTIME" type="xs:integer"/>
            <xs:element name="PETIME" type="xs:integer"/>
            <xs:element name="RSTIME" type="xs:integer"/>
            <xs:element name="RETIME" type="xs:integer"/>
            <xs:element name="ESTIME" type="xs:integer"/>
            <xs:element name="EETIME" type="xs:integer"/>
     
            <!-- REASON values:
              NONE        = 0  Normal termination
              ERROR       = 1  The VM ended in error
              STOP_RESUME = 2  Stop/resume request
              USER        = 3  Migration request
              CANCEL      = 4  Cancel request
            -->
            <xs:element name="REASON" type="xs:integer"/>
     
            <xs:element name="VM">
              <xs:complexType>
                <xs:sequence>
                  <xs:element name="ID" type="xs:integer"/>
                  <xs:element name="UID" type="xs:integer"/>
                  <xs:element name="GID" type="xs:integer"/>
                  <xs:element name="UNAME" type="xs:string"/>
                  <xs:element name="GNAME" type="xs:string"/>
                  <xs:element name="NAME" type="xs:string"/>
                  <xs:element name="PERMISSIONS" minOccurs="0" maxOccurs="1">
                    <xs:complexType>
                      <xs:sequence>
                        <xs:element name="OWNER_U" type="xs:integer"/>
                        <xs:element name="OWNER_M" type="xs:integer"/>
                        <xs:element name="OWNER_A" type="xs:integer"/>
                        <xs:element name="GROUP_U" type="xs:integer"/>
                        <xs:element name="GROUP_M" type="xs:integer"/>
                        <xs:element name="GROUP_A" type="xs:integer"/>
                        <xs:element name="OTHER_U" type="xs:integer"/>
                        <xs:element name="OTHER_M" type="xs:integer"/>
                        <xs:element name="OTHER_A" type="xs:integer"/>
                      </xs:sequence>
                    </xs:complexType>
                  </xs:element>
                  <xs:element name="LAST_POLL" type="xs:integer"/>
     
                  <!-- STATE values,
                  see http://opennebula.org/documentation:documentation:api#actions_for_virtual_machine_management
     
                    INIT      = 0
                    PENDING   = 1
                    HOLD      = 2
                    ACTIVE    = 3 In this state, the Life Cycle Manager state is relevant
                    STOPPED   = 4
                    SUSPENDED = 5
                    DONE      = 6
                    POWEROFF  = 8
                  -->
                  <xs:element name="STATE" type="xs:integer"/>
     
                  <!-- LCM_STATE values, this sub-state is relevant only when STATE is
                       ACTIVE (4)
     
                    LCM_INIT          = 0
                    PROLOG            = 1
                    BOOT              = 2
                    RUNNING           = 3
                    MIGRATE           = 4
                    SAVE_STOP         = 5
                    SAVE_SUSPEND      = 6
                    SAVE_MIGRATE      = 7
                    PROLOG_MIGRATE    = 8
                    PROLOG_RESUME     = 9
                    EPILOG_STOP       = 10
                    EPILOG            = 11
                    SHUTDOWN          = 12
                    CANCEL            = 13
                    FAILURE           = 14
                    CLEANUP           = 15
                    UNKNOWN           = 16
                    HOTPLUG           = 17
                    SHUTDOWN_POWEROFF = 18
                    BOOT_UNKNOWN      = 19
                    BOOT_POWEROFF     = 20
                    BOOT_SUSPENDED    = 21
                    BOOT_STOPPED      = 22
                  -->
                  <xs:element name="LCM_STATE" type="xs:integer"/>
                  <xs:element name="RESCHED" type="xs:integer"/>
                  <xs:element name="STIME" type="xs:integer"/>
                  <xs:element name="ETIME" type="xs:integer"/>
                  <xs:element name="DEPLOY_ID" type="xs:string"/>
     
                  <!-- MEMORY consumption in kilobytes -->
                  <xs:element name="MEMORY" type="xs:integer"/>
     
                  <!-- Percentage of 1 CPU consumed (two fully consumed cpu is 200) -->
                  <xs:element name="CPU" type="xs:integer"/>
     
                  <!-- NET_TX: Sent bytes to the network -->
                  <xs:element name="NET_TX" type="xs:integer"/>
     
                  <!-- NET_RX: Received bytes from the network -->
                  <xs:element name="NET_RX" type="xs:integer"/>
                  <xs:element name="TEMPLATE" type="xs:anyType"/>
                  <xs:element name="HISTORY_RECORDS">
                  </xs:element>
                </xs:sequence>
              </xs:complexType>
            </xs:element>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
    </xs:schema>

.. _accounting_sunstone:

Sunstone
========

Sunstone also displays information about accounting. Information is accessible via the User dialogs for the user and admin views. The cloud view can access the metering information in the dashboard, whereas the group admin user can access them under the users section.

|image1|

Tuning & Extending
==================

There are two kinds of monitoring values:

-  Instantaneous values: For example, ``VM/CPU`` or ``VM/MEMORY`` show the memory consumption last reported by the monitoring probes.
-  Accumulative values: For example, ``VM/NET_TX`` and ``VM/NET_TX`` show the total network consumption since the history record started.

Developers interacting with OpenNebula using the Ruby bindings can use the `VirtualMachinePool.accounting method <http://docs.opennebula.org/doc/5.0/oca/ruby/OpenNebula/VirtualMachinePool.html#accounting-instance_method>`__ to retrieve accounting information filtering and ordering by multiple parameters.

.. |image1| image:: /images/accounting_admin_view.png
