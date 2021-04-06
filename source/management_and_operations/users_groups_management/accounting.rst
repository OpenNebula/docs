.. _accounting:

==================
Accounting Client
==================

The accounting toolset visualizes and reports resource usage data. This accounting tool addresses the accounting of the virtual resources. It includes resource consumption of the virtual machines as reported from the hypervisor.

Usage
=====

``oneacct`` - prints accounting information for virtual machines

.. code-block:: text

    Usage: oneacct [options]
     -s, --start TIME          First day of the data to retrieve
     -e, --end TIME            Last day of the data to retrieve
     -u, --userfilter user     User name or id to filter the results
     -g, --group group         Group name or id to filter the results
     -H, --host HOST           Host name or id to filter the results
     --xpath XPATH_EXPRESSION  Xpath expression to filter the results. For
                               example: oneacct --xpath 'HISTORY[ETIME>0]'
     -x, --xml                 Show the resource in xml format
     -j, --json                Show the resource in json format
     --split                   Split the output in a table for each VM
     -v, --verbose             Verbose mode
     -h, --help                Show this message
     -V, --version             Show version and copyright information
     --describe                Describe list columns
     -l, --list x,y,z          Selects columns to display with list command
     --csv                     Write table in csv format
     --user name               User name used to connect to OpenNebula
     --password password       Password to authenticate with OpenNebula
     --endpoint endpoint       URL of OpenNebula XML-RPC front-end

The time can be written as ``month/day/year hour:minute:second``, or any other similar format, e.g ``month/day hour:minute``.

To integrate this tool with other systems you can use ``-j``, ``-x`` or ``--csv`` flags to get all the information in an easy computer readable format.

Accounting Output
=================

The oneacct command shows individual Virtual Machine history records. This means that for a single VM you may get several accounting entries, one for each migration or stop/suspend action. A resize or disk/nic attachment will also create a new entry.

Each entry contains the complete information of the Virtual Machine, including the Virtual Machine monitoring information. By default, only network consumption is reported, see the `Tuning & Extending <#tuning-extending>`__ section for more information.

When the results are filtered with the ``-s`` and/or ``-e`` options, all the history records that were active during that time interval are shown, but they may start or end outside that interval.

For example, if you have a VM that was running from May 1st to June 1st, and you request the accounting information with this command:

.. prompt:: text $ auto

	$ oneacct -s 05/01 -e 06/01
	Showing active history records from 2016-05-01 00:00:00 +0200 to 2016-06-02 00:00:00 +0200

	# User 0

	 VID HOSTNAME        ACTION           REAS     START_TIME       END_TIME MEMORY CPU  NETRX  NETTX   DISK
	  28 host01          terminate        user 05/27 16:40:47 05/27 17:09:20  1024M 0.1     0K     0K  10.4G
	  29 host02          none             none 05/27 17:09:28              -   256M   1   2.4M   1.3K    10G

The record shows the complete history record, and total network consumption. It will not reflect the consumption made only during the month of May.

Other important thing to pay attention to is that active history records, those with ``END_TIME`` **'-'**, refresh their monitoring information each time the VM is monitored. Once the VM is shut down, migrated or stopped, the ``END_TIME`` is set and the monitoring information stored is frozen. The final values reflect the total for accumulative attributes, like ``NETRX``/``NETTX``.

Sample Output
-------------

Obtaining all the available accounting information:

.. prompt:: text $ auto

	$ oneacct
	# User 0

	 VID HOSTNAME        ACTION           REAS     START_TIME       END_TIME MEMORY CPU  NETRX  NETTX   DISK

	  13 host01          nic-attach       user 05/17 17:10:57 05/17 17:12:48   256M 0.1  19.2K  15.4K     8G
	  13 host01          nic-detach       user 05/17 17:12:48 05/17 17:13:48   256M 0.1  36.9K    25K     8G
	  13 host01          nic-attach       user 05/17 17:13:48 05/17 17:14:54   256M 0.1  51.2K  36.4K     8G
	  13 host01          nic-detach       user 05/17 17:14:54 05/17 17:17:19   256M 0.1  79.8K  61.7K     8G
	  13 host01          nic-attach       user 05/17 17:17:19 05/17 17:17:27   256M 0.1  79.8K  61.7K     8G
	  13 host01          terminate-hard   user 05/17 17:17:27 05/17 17:37:52   256M 0.1 124.6K  85.9K     8G
	  14 host02          nic-attach       user 05/17 17:38:16 05/17 17:40:00   256M 0.1  16.5K  13.2K     8G
	  14 host02          poweroff         user 05/17 17:40:00 05/17 17:53:40   256M 0.1  38.3K  18.8K     8G
	  14 host02          terminate-hard   user 05/17 17:55:55 05/18 14:54:19   256M 0.1     1M  27.3K     8G

The columns are:

+-------------+---------------------------------------------------------------------------------------------+
|    Column   |                                           Meaning                                           |
+=============+=============================================================================================+
| VID         | Virtual Machine ID                                                                          |
+-------------+---------------------------------------------------------------------------------------------+
| HOSTNAME    | Host name                                                                                   |
+-------------+---------------------------------------------------------------------------------------------+
| ACTION      | Virtual Machine action that created a new history record                                    |
+-------------+---------------------------------------------------------------------------------------------+
| REASON      | VM state change reason:                                                                     |
|             |                                                                                             |
|             | - **none**: Virtual Machine still running                                                   |
|             | - **erro**: The VM ended in error                                                           |
|             | - **user**: VM action started by the user                                                   |
+-------------+---------------------------------------------------------------------------------------------+
| START_TIME  | Start time                                                                                  |
+-------------+---------------------------------------------------------------------------------------------+
| END_TIME    | End time                                                                                    |
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

.. prompt:: text $ auto

	$ oneacct -u 0 --split
	# User 0

	 VID HOSTNAME        ACTION           REAS     START_TIME       END_TIME MEMORY CPU  NETRX  NETTX   DISK
	  12 host01          none             user 05/09 19:20:42 05/09 19:35:23  1024M   1  29.8M 638.8K     0K

	 VID HOSTNAME        ACTION           REAS     START_TIME       END_TIME MEMORY CPU  NETRX  NETTX   DISK
	  13 host01          nic-attach       user 05/17 17:10:57 05/17 17:12:48   256M 0.1  19.2K  15.4K     8G
	  13 host01          nic-detach       user 05/17 17:12:48 05/17 17:13:48   256M 0.1  36.9K    25K     8G
	  13 host01          nic-attach       user 05/17 17:13:48 05/17 17:14:54   256M 0.1  51.2K  36.4K     8G
	  13 host01          nic-detach       user 05/17 17:14:54 05/17 17:17:19   256M 0.1  79.8K  61.7K     8G
	  13 host01          nic-attach       user 05/17 17:17:19 05/17 17:17:27   256M 0.1  79.8K  61.7K     8G
	  13 host01          terminate-hard   user 05/17 17:17:27 05/17 17:37:52   256M 0.1 124.6K  85.9K     8G

	 VID HOSTNAME        ACTION           REAS     START_TIME       END_TIME MEMORY CPU  NETRX  NETTX   DISK
	  14 host02          nic-attach       user 05/17 17:38:16 05/17 17:40:00   256M 0.1  16.5K  13.2K     8G
	  14 host02          poweroff         user 05/17 17:40:00 05/17 17:53:40   256M 0.1  38.3K  18.8K     8G
	  14 host02          terminate-hard   user 05/17 17:55:55 05/18 14:54:19   256M 0.1     1M  27.3K     8G

	 VID HOSTNAME        ACTION           REAS     START_TIME       END_TIME MEMORY CPU  NETRX  NETTX   DISK
	  29 host02          none             none 05/27 17:09:28              -   256M   1   2.4M   1.3K    10G

In case you use CSV output (``--csv``) you will het a header with the name of each column and then the data. For example:

.. prompt:: text $ auto

	$ oneacct --csv
	UID,VID,HOSTNAME,ACTION,REASON,START_TIME,END_TIME,MEMORY,CPU,NETRX,NETTX,DISK
	0,12,host01,none,user,05/09 19:20:42,05/09 19:35:23,1024M,1,29.8M,638.8K,0K
	0,13,host01,nic-attach,user,05/17 17:10:57,05/17 17:12:48,256M,0.1,19.2K,15.4K,8G
	0,13,host01,nic-detach,user,05/17 17:12:48,05/17 17:13:48,256M,0.1,36.9K,25K,8G
	0,13,host01,nic-attach,user,05/17 17:13:48,05/17 17:14:54,256M,0.1,51.2K,36.4K,8G
	0,13,host01,nic-detach,user,05/17 17:14:54,05/17 17:17:19,256M,0.1,79.8K,61.7K,8G
	0,13,host01,nic-attach,user,05/17 17:17:19,05/17 17:17:27,256M,0.1,79.8K,61.7K,8G
	0,13,host01,terminate-hard,user,05/17 17:17:27,05/17 17:37:52,256M,0.1,124.6K,85.9K,8G
	0,14,host02,nic-attach,user,05/17 17:38:16,05/17 17:40:00,256M,0.1,16.5K,13.2K,8G
	0,14,host01,poweroff,user,05/17 17:40:00,05/17 17:53:40,256M,0.1,38.3K,18.8K,8G
	0,14,host02,terminate-hard,user,05/17 17:55:55,05/18 14:54:19,256M,0.1,1M,27.3K,8G
	0,29,host02,none,none,05/27 17:09:28,-,256M,1,2.4M,1.3K,10G

Output Reference
----------------

If you execute oneacct with the ``-x`` option, you will get an XML output defined by the following xsd:

.. code-block:: xml

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
			<xs:element name="CID" type="xs:integer"/>
			<xs:element name="STIME" type="xs:integer"/>
			<xs:element name="ETIME" type="xs:integer"/>
			<xs:element name="VM_MAD" type="xs:string"/>
			<xs:element name="TM_MAD" type="xs:string"/>
			<xs:element name="DS_ID" type="xs:integer"/>
			<xs:element name="PSTIME" type="xs:integer"/>
			<xs:element name="PETIME" type="xs:integer"/>
			<xs:element name="RSTIME" type="xs:integer"/>
			<xs:element name="RETIME" type="xs:integer"/>
			<xs:element name="ESTIME" type="xs:integer"/>
			<xs:element name="EETIME" type="xs:integer"/>

			<!-- REASON values:
			  NONE  = 0 History record is not closed yet
			  ERROR = 1 History record was closed because of an error
			  USER  = 2 History record was closed because of a user action
			-->
			<xs:element name="REASON" type="xs:integer"/>

			<!-- ACTION values:
			  NONE_ACTION             = 0
			  MIGRATE_ACTION          = 1
			  LIVE_MIGRATE_ACTION     = 2
			  SHUTDOWN_ACTION         = 3
			  SHUTDOWN_HARD_ACTION    = 4
			  UNDEPLOY_ACTION         = 5
			  UNDEPLOY_HARD_ACTION    = 6
			  HOLD_ACTION             = 7
			  RELEASE_ACTION          = 8
			  STOP_ACTION             = 9
			  SUSPEND_ACTION          = 10
			  RESUME_ACTION           = 11
			  BOOT_ACTION             = 12
			  DELETE_ACTION           = 13
			  DELETE_RECREATE_ACTION  = 14
			  REBOOT_ACTION           = 15
			  REBOOT_HARD_ACTION      = 16
			  RESCHED_ACTION          = 17
			  UNRESCHED_ACTION        = 18
			  POWEROFF_ACTION         = 19
			  POWEROFF_HARD_ACTION    = 20
			  DISK_ATTACH_ACTION      = 21
			  DISK_DETACH_ACTION      = 22
			  NIC_ATTACH_ACTION       = 23
			  NIC_DETACH_ACTION       = 24
			  DISK_SNAPSHOT_CREATE_ACTION = 25
			  DISK_SNAPSHOT_DELETE_ACTION = 26
			  TERMINATE_ACTION        = 27
			  TERMINATE_HARD_ACTION   = 28
			-->
			<xs:element name="ACTION" type="xs:integer"/>

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
				  see http://docs.opennebula.org/stable/user/references/vm_states.html
				  -->
				  <xs:element name="STATE" type="xs:integer"/>

				  <!-- LCM_STATE values, this sub-state is relevant only when STATE is
					   ACTIVE (4)
				  see http://docs.opennebula.org/stable/user/references/vm_states.html
				  -->
				  <xs:element name="LCM_STATE" type="xs:integer"/>
				  <xs:element name="PREV_STATE" type="xs:integer"/>
				  <xs:element name="PREV_LCM_STATE" type="xs:integer"/>
				  <xs:element name="RESCHED" type="xs:integer"/>
				  <xs:element name="STIME" type="xs:integer"/>
				  <xs:element name="ETIME" type="xs:integer"/>
				  <xs:element name="DEPLOY_ID" type="xs:string"/>
				  <xs:element name="MONITORING">
				  <!--
					<xs:complexType>
					  <xs:all>
						<- Percentage of 1 CPU consumed (two fully consumed cpu is 200) ->
						<xs:element name="CPU" type="xs:decimal" minOccurs="0" maxOccurs="1"/>

						<- MEMORY consumption in kilobytes ->
						<xs:element name="MEMORY" type="xs:integer" minOccurs="0" maxOccurs="1"/>

						<- NETTX: Sent bytes to the network ->
						<xs:element name="NETTX" type="xs:integer" minOccurs="0" maxOccurs="1"/>

						<- NETRX: Received bytes from the network ->
						<xs:element name="NETRX" type="xs:integer" minOccurs="0" maxOccurs="1"/>
					  </xs:all>
					</xs:complexType>
				  -->
				  </xs:element>
				  <xs:element name="TEMPLATE" type="xs:anyType"/>
				  <xs:element name="USER_TEMPLATE" type="xs:anyType"/>
				  <xs:element name="HISTORY_RECORDS">
				  </xs:element>
				  <xs:element name="SNAPSHOTS" minOccurs="0" maxOccurs="unbounded">
					<xs:complexType>
					  <xs:sequence>
						<xs:element name="DISK_ID" type="xs:integer"/>
						<xs:element name="SNAPSHOT" minOccurs="0" maxOccurs="unbounded">
						  <xs:complexType>
							<xs:sequence>
							  <xs:element name="ACTIVE" type="xs:string" minOccurs="0" maxOccurs="1"/>
							  <xs:element name="CHILDREN" type="xs:string" minOccurs="0" maxOccurs="1"/>
							  <xs:element name="DATE" type="xs:integer"/>
							  <xs:element name="ID" type="xs:integer"/>
							  <xs:element name="NAME" type="xs:string" minOccurs="0" maxOccurs="1"/>
							  <xs:element name="PARENT" type="xs:integer"/>
							  <xs:element name="SIZE" type="xs:integer"/>
							</xs:sequence>
						  </xs:complexType>
						</xs:element>
					  </xs:sequence>
					</xs:complexType>
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

* Instantaneous values: For example, ``VM/CPU`` or ``VM/MEMORY`` show the memory consumption last reported by the monitoring probes.
* Accumulative values: For example, ``VM/NETRX`` and ``VM/NETTX`` show the total network consumption since the history record started.

Developers interacting with OpenNebula using the Ruby bindings can use the `VirtualMachinePool.accounting method <http://docs.opennebula.io/doc/6.1/oca/ruby/OpenNebula/VirtualMachinePool.html#accounting-instance_method>`__ to retrieve accounting information filtering and ordering by multiple parameters.

.. |image1| image:: /images/accounting_admin_view.png
