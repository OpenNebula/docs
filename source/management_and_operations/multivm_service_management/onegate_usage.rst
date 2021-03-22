.. _onegate_overview:
.. _onegate_usage:

=======================
OneGate Usage
=======================

The OneGate component allows Virtual Machine guests to pull and push VM information from OpenNebula. Users and administrators can use it to gather metrics, detect problems in their applications, and trigger OneFlow elasticity rules from inside the VM.

For Virtual Machines that are part of a Multi-VM Application (:ref:`OneFlow Service <oneflow_overview>`), they can also retrieve the Service information directly from OneGate and trigger actions to reconfigure the Service or pass information among different VMs.

OneGate Workflow Explained
==========================

OneGate is a server that listens to http connections from the Virtual Machines. OpenNebula assigns an individual token to each VM instance, and Applications running inside the VM use this token to interact with the OneGate API. This token is generated using VM information and signed with the owner User template attribute TOKEN_PASSWORD. This password can be changed updating the User template, but tokens from existing VMs will not work anymore.

|onegate_arch|

OneGate Usage
=============

First, the cloud administrator must configure and start the :ref:`OneGate server <onegate_conf>`.

Setup the VM Template
---------------------

Your VM Template must set the ``CONTEXT/TOKEN`` attribute to ``YES``.

.. code-block:: none

    CPU     = "0.5"
    MEMORY  = "1024"

    DISK = [
      IMAGE_ID = "0" ]
    NIC = [
      NETWORK_ID = "0" ]

    CONTEXT = [
      TOKEN = "YES" ]

or check the OneGate checkbox in Sunstone:

|onegate_context|

When this Template is instantiated, OpenNebula will automatically add the ONEGATE_ENDPOINT context variable, and a token.txt will be placed in the :ref:`context cdrom <context_overview>`. This token.txt file is only accessible from inside the VM.

.. code-block:: none

    ...

    CONTEXT=[
      DISK_ID="1",
      ONEGATE_ENDPOINT="http://192.168.0.1:5030",
      TARGET="hdb",
      TOKEN="YES" ]

In vCenter this information is available in the extraConfig section of the VM metadata, available in the guest OS through the VMware tools as explained in the :ref:`contextualization guide <vcenter_contextualization>`.


Using the OneGate Client inside the Guest VM
--------------------------------------------

A ruby client that implements the OneGate API is included in the official `OpenNebula context packages <https://github.com/OpenNebula/addon-context-linux>`__. This is a simple command line interface to interact with the OneGate server, it will handle the authentication and requests complexity.

OneGate Client Usage
--------------------

Available commands and usage are shown with ``onegate -h``.

With the appropriate policies implemented in the Service, these mechanisms allow Services to be self-managed, enabling self-configuration, self-healing, self-optimization and self-protection.

Self-Awareness
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are several actions available to retrieve information of the Virtual Machine and the Service it belongs to. A Virtual Machine can also retrieve information of other Virtual Machines that are part of the Service.

Retrieving Information of the VM
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Using the ``onegate vm show`` command the information of the Virtual Machine will be retrieved. For a detailed version use the ``--json`` option and all the information will be returned in JSON format.

If no argument is provided, the information of the current Virtual Machine will be retrieved. Alternatively, a VM ID can be provided to retrieve the information of a specific Virtual Machine.

.. code::

    $ onegate vm show
    VM 8
    NAME                : master_0_(service_1)
    STATE               : RUNNING
    IP                  : 192.168.122.23

.. note:: Specifying a VM ID different of a different VM will only works to retrieve information of VMs in the same OneFlow Service or the same Virtual Router.

Retrieving information of the Service
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Using the ``onegate service show`` command the information of the Service will be retrieved.

.. code::

    $ onegate service show
    SERVICE 1
    NAME                : PANACEA service
    STATE               : RUNNING

    ROLE master
    VM 8
    NAME                : master_0_(service_1)

    ROLE slave
    VM 9
    NAME                : slave_0_(service_1)


You can use the option ``onegate service show --extended`` to get all the information from virtual machines.

.. code::

    $ onegate service show --extended
    SERVICE 1
    NAME                : PANACEA service
    STATE               : RUNNING

    ROLE master
    VM 8
    NAME                : master_0_(service_1)
    STATE               : RUNNING
    IP                  : 192.168.122.23


    ROLE slave
    VM 9
    NAME                : slave_0_(service_1)
    STATE               : RUNNING

For a detailed version use the ``--json`` option and all the information will be returned in JSON format. You can combine **extended** and **json** to get all the information in JSON format.

Retrieving Information of the Virtual Router
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Using the ``onegate vrouter show`` command the information of the Virtual Machine will be retrieved. For a detailed version use the ``--json`` option and all the information will be returned in JSON format.

.. code::

    $ onegate vrouter show
    VROUTER 0
    NAME                : vr
    VMS                 : 1

Retrieving Information of the Virtual Network
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Using the ``onegate vnet show <ID>`` command the information of a Virtual Network will be retrieved. For a detailed version use the ``--json`` option and all the information will be returned in JSON format, when using this option the ``--extended`` option can be used to increase the information retrieved by the command.

.. code::

    $ onegate vnet show 0
      VNET
      ID                  : 0

.. note:: This option is only available for Virtual Routers and only Virtual Networks related to that Virtual Router (i.e Virtual Network attached or related somehow in the reservation hierarchy with another attached Virtual Network) can be retrieved.

Updating the VM Information
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The Virtual Machine can update the information of itself or other Virtual Machine of the Service. This information can be retrieved from any of the Virtual Machines.

For example, the master Virtual Machine can change the ``ACTIVE`` attribute from one Virtual Machine to another one. Then, this information can be used to trigger any kind of action in the other Virtual Machine.

.. code::

    $ onegate vm update 9 --data ACTIVE=YES
    $ onegate vm show 9 --json
    {
      "VM": {
        "NAME": "slave_0_(service_1)",
        "ID": "9",
        "STATE": "3",
        "LCM_STATE": "3",
        "USER_TEMPLATE": {
          "ACTIVE": "YES",
          "FROM_APP": "4fc76a938fb81d3517000003",
          "FROM_APP_NAME": "ttylinux - kvm",
          "LOGO": "images/logos/linux.png",
          "ROLE_NAME": "slave",
          "SERVICE_ID": "1"
        },
        "TEMPLATE": {
          "NIC": [

          ]
        }
      }
    }

Deleting attribute from VM Information
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The Virtual Machine can delete attributes from its own template or from other Virtual Machines in its Service.

For example, to erase the ``ACTIVE`` attribute from Virtual Machine 9 you can execute the following in any Service VM:

.. code::

    $ onegate vm update 9 --erase ACTIVE
    $ onegate vm show 9 --json
    {
      "VM": {
        "NAME": "slave_0_(service_1)",
        "ID": "9",
        "STATE": "3",
        "LCM_STATE": "3",
        "USER_TEMPLATE": {
          "FROM_APP": "4fc76a938fb81d3517000003",
          "FROM_APP_NAME": "ttylinux - kvm",
          "LOGO": "images/logos/linux.png",
          "ROLE_NAME": "slave",
          "SERVICE_ID": "1"
        },
        "TEMPLATE": {
          "NIC": [

           ]
        }
      }
    }

Self-Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are several actions to adapt the Service to a given situation. Actions on any of the Virtual Machines can be performed individually. Also, the size of the Service can be customized just specifying a cardinality for each of the roles.

Performing actions on a VM
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The following actions can be performed in any of the Virtual Machines of the Service.

* ``onegate vm resume``: Resumes the execution of the a saved VM. Valid states: STOPPED, SUSPENDED, UNDEPLOYED, POWEROFF
* ``onegate vm stop``: Stops a running VM. The VM state is saved and transferred back to the front-end along with the disk files. Valid states: RUNNING
* ``onegate vm suspend``:  Saves a running VM. It is the same as ``onegate vm stop``, but the files are left in the remote machine to later restart the VM there (i.e. the resources are not freed and there is no need to re-schedule the VM). Valid states: RUNNING
* ``onegate vm terminate``: Terminates the given VM. The VM life cycle will end. With --hard it unplugs the VM. Valid states: any except those with a pending driver response
* ``onegate vm reboot``: Reboots the given VM, this is equivalent to execute the reboot command from the VM console. The VM will be ungracefully rebooted if --hard is used. Valid states: RUNNING
* ``onegate vm poweroff``: Powers off the given VM. The VM will remain in the poweroff state, and can be powered on with the ``onegate vm resume`` command. Valid states: RUNNING
* ``onegate vm resched``: Sets the rescheduling flag for the VM. The VM will be moved to a different host based on the scheduling policies. Valid states: RUNNING, POWEROFF
* ``onegate vm unresched``:  Unsets the rescheduling flag for the VM. Valid states: RUNNING, POWEROFF
* ``onegate vm hold``: Sets the given VM on hold. A VM on hold is not scheduled until it is released. Valid states: PENDING
* ``onegate vm release``: Releases a VM on hold. See `onegate vm hold` Valid states: HOLD

.. prompt:: text $ auto

    $ onegate vm terminate --hard 9


Change Service cardinality
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The number of Virtual Machines of a Service can be also modified from any of the Virtual Machines that have access to the OneGate Server. The Virtual Machines of Services are grouped in Roles and each Role has a cardinality (number of Virtual Machines). This cardinality can be increased or decreased, in case the given cardinality is lower than the current one, Virtual Machines will be terminated to meet the given number. If the cardinality is greater than the current one, new Virtual Machines will be instantiated using the VM Template associated to the Role.

.. code::

    $ onegate service scale --role slave --cardinality 2
    $ onegate service show
    SERVICE 1
    NAME                : PANACEA service
    STATE               : SCALING

    ROLE master
    VM 8
    NAME                : master_0_(service_1)
    STATE               : RUNNING
    IP                  : 192.168.122.23

    ROLE slave
    VM 9
    NAME                : slave_0_(service_1)
    STATE               : RUNNING
    VM 10
    NAME                : slave_1_(service_1)
    STATE               : PENDING


OneGate API
===========

OneGate provides a REST API. To use this API you will need to get some data from the CONTEXT file.

The contextualization cdrom should contain the ``context.sh`` and ``token.txt`` files.

.. prompt:: text # auto

    # mkdir /mnt/context
    # mount /dev/hdb /mnt/context
    # cd /mnt/context
    # ls
    context.sh  token.txt
    # cat context.sh
    # Context variables generated by OpenNebula
    DISK_ID='1'
    ONEGATE_ENDPOINT='http://192.168.0.1:5030'
    VMID='0'
    TARGET='hdb'
    TOKEN='yes'

    # cat token.txt
    yCxieDUS7kra7Vn9ILA0+g==

With that data, you can obtain the headers required for all the ONEGATE API methods:

* **Headers**:

  * ``X-ONEGATE-TOKEN: token.txt contents``
  * ``X-ONEGATE-VMID: <vmid>``

OneGate supports these actions:

Self-awareness
--------------

* ``GET ${ONEGATE_ENDPOINT}/vm``: To request information about the current Virtual Machine.
* ``GET ${ONEGATE_ENDPOINT}/vms/${VM_ID}``: To request information about a specific Virtual Machine of the Service. The information is returned in JSON format and is ready for public cloud usage:

  .. prompt:: text $ auto

      $ curl -X "GET" "${ONEGATE_ENDPOINT}/vm" \
          --header "X-ONEGATE-TOKEN: `cat token.txt`" \
          --header "X-ONEGATE-VMID: $VMID"
      {
          "VM": {
              "ID": ...,
              "NAME": ...,
              "TEMPLATE": {
                  "NIC": [
                      {
                          "IP": ...,
                          "IP6_LINK": ...,
                          "MAC": ...,
                          "NETWORK": ...,
                      },
                      // more nics ...
                  ]
              },
              "USER_TEMPLATE": {
                  "ROLE_NAME": ...,
                  "SERVICE_ID": ...,
                  // more user template attributes
              }
          }
      }

* ``PUT ${ONEGATE_ENDPOINT}/vm``: To add information to the template of the current VM. The new information is placed inside the VM's user template section. This means that the application metrics are visible from the command line, Sunstone, or the APIs, and can be used to trigger OneFlow elasticity rules.
* ``PUT ${ONEGATE_ENDPOINT}/vms/${VM_ID}``: To add information to the template of a specific VM of the Service.

  .. prompt:: text $ auto

      $ curl -X "PUT" "${ONEGATE_ENDPOINT}/vm" \
          --header "X-ONEGATE-TOKEN: `cat token.txt`" \
          --header "X-ONEGATE-VMID: $VMID" \
          -d "APP_LOAD = 9.7"

  The new metric is stored in the user template section of the VM:

  .. prompt:: text $ auto

      $ onevm show 0
      ...
      USER TEMPLATE
      APP_LOAD="9.7"

* ``PUT ${ONEGATE_ENDPOINT}/vm?type=2``: To delete information from the template of the current VM.
* ``PUT ${ONEGATE_ENDPOINT}/vms/${VM_ID}?type=2``: To delete information from the template of a specific VM of the Service.

  .. prompt:: text $ auto

      $ curl -X "PUT" "${ONEGATE_ENDPOINT}/vm?type=2" \
          --header "X-ONEGATE-TOKEN: `cat token.txt`" \
          --header "X-ONEGATE-VMID: $VMID" \
          -d "APP_LOAD"

  The new metric is stored in the user template section of the VM:

  .. prompt:: text $ auto

      $ onevm show 0
      ...
      USER TEMPLATE

* ``GET ${ONEGATE_ENDPOINT}/service``: To request information about the Service. The information is returned in JSON format and is ready for public cloud usage. By pushing data ``PUT /vm`` from one VM and pulling the Service data from another VM ``GET /service``, nodes that are part of a OneFlow Service can pass values from one to another.

  .. prompt:: text $ auto

      $ curl -X "GET" "${ONEGATE_ENDPOINT}/service" \
          --header "X-ONEGATE-TOKEN: `cat token.txt`" \
          --header "X-ONEGATE-VMID: $VMID"

      {
          "SERVICE": {
              "id": ...,
              "name": ...,
              "roles": [
                  {
                      "name": ...,
                      "cardinality": ...,
                      "state": ...,
                      "nodes": [
                          {
                              "deploy_id": ...,
                              "running": true|false,
                              "vm_info": {
                                  // VM template as return by GET /VM
                              }

                          },
                          // more nodes ...
                      ]
                  },
                  // more roles ...
              ]
          }
      }

* ``GET ${ONEGATE_ENDPOINT}``: returns information endpoints:

  .. prompt:: text $ auto

      $ curl -X "GET" "${ONEGATE_ENDPOINT}/service" \
          --header "X-ONEGATE-TOKEN: `cat token.txt`" \
          --header "X-ONEGATE-VMID: $VMID"

      {
          "vm_info": "http://<onegate_endpoint>/vm",
          "service_info": "http://<onegate_endpoint>/service"
      }

* ``GET ${ONEGATE_ENDPOINT}/vrouter``: To request information about the Virtual Router. The information is returned in JSON format and is ready for public cloud usage.

  .. prompt:: text $ auto

      $ curl -X "GET" "${ONEGATE_ENDPOINT}/vrouter" \
          --header "X-ONEGATE-TOKEN: `cat token.txt`" \
          --header "X-ONEGATE-VMID: $VMID"

      {
        "VROUTER": {
            "NAME": "vr",
            "ID": "0",
            "VMS": {
            "ID": [
                "1"
            ]
            },
            "TEMPLATE": {
            "NIC": [
                {
                "NETWORK": "vnet",
                "NETWORK_ID": "0",
                "NIC_ID": "0"
                }
            ],
            "TEMPLATE_ID": "0"
            }
        }
      }

* ``GET ${ONEGATE_ENDPOINT}/vnet``: To request information about a Virtual Network. The information is returned in JSON format and is ready for public cloud usage.

  .. prompt:: text $ auto

      $ curl -X "GET" "${ONEGATE_ENDPOINT}/vnet/<VNET_ID>" \
          --header "X-ONEGATE-TOKEN: `cat token.txt`" \
          --header "X-ONEGATE-VMID: $VMID"

      {
        "VNET": {
            "ID": "0",
            "NAME": "vnet",
            "USED_LEASES": "1",
            "VROUTERS": {
            "ID": [
                "0"
            ]
            },
            "PARENT_NETWORK_ID": {
            },
            "AR_POOL": {
            "AR": [
                {
                "AR_ID": "0",
                "IP": "192.168.122.100",
                "MAC": "02:00:c0:a8:7a:64",
                "SIZE": "10",
                "TYPE": "IP4",
                "MAC_END": "02:00:c0:a8:7a:6d",
                "IP_END": "192.168.122.109",
                "USED_LEASES": "1",
                "LEASES": {
                    "LEASE": [
                    {
                        "IP": "192.168.122.100",
                        "MAC": "02:00:c0:a8:7a:64",
                        "VM": "1"
                    }
                    ]
                }
                }
            ]
            },
            "TEMPLATE": {
            "NETWORK_ADDRESS": "192.168.122.0",
            "NETWORK_MASK": "255.255.255.0",
            "GATEWAY": "192.168.122.1",
            "DNS": "1.1.1.1"
            }
          }
        }


Self-configuration
------------------

* ``PUT ${ONEGATE_ENDPOINT}/service/role/${ROLE_NAME}``: To change the cardinality of a specific role of the Service:

  .. prompt:: text $ auto

      $ curl -X "PUT" "${ONEGATE_ENDPOINT}/service/role/worker" \
          --header "X-ONEGATE-TOKEN: `cat token.txt`" \
          --header "X-ONEGATE-VMID: $VMID" \
          -d "{'cardinality' : 10}"

* ``POST ${ONEGATE_ENDPOINT}/vms/${VM_ID}/action``: To perform an action on a specific VM of the Service. Supported actions (resume, stop, suspend, terminate, reboot, poweroff, resched, unresched, hold, release)

  .. prompt:: text $ auto

      $ curl -X "POST" "${ONEGATE_ENDPOINT}/vms/18/action" \
          --header "X-ONEGATE-TOKEN: `cat token.txt`" \
          --header "X-ONEGATE-VMID: $VMID" \
          -d "{'action' : {'perform': 'resched'}}"


Sample Application Monitoring Script
====================================

.. code-block:: bash
  :linenos:

    #!/bin/bash

    # -------------------------------------------------------------------------- #
    # Copyright 2002-2016, OpenNebula Project, OpenNebula Systems                #
    #                                                                            #
    # Licensed under the Apache License, Version 2.0 (the "License"); you may    #
    # not use this file except in compliance with the License. You may obtain    #
    # a copy of the License at                                                   #
    #                                                                            #
    # http://www.apache.org/licenses/LICENSE-2.0                                 #
    #                                                                            #
    # Unless required by applicable law or agreed to in writing, software        #
    # distributed under the License is distributed on an "AS IS" BASIS,          #
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
    # See the License for the specific language governing permissions and        #
    # limitations under the License.                                             #
    #--------------------------------------------------------------------------- #

    ################################################################################
    # Initialization
    ################################################################################

    ERROR=0

    if [ -z $ONEGATE_TOKEN ]; then
        echo "ONEGATE_TOKEN env variable must point to the token.txt file"
        ERROR=1
    fi

    if [ -z $ONEGATE_ENDPOINT ]; then
        echo "ONEGATE_ENDPOINT env variable must be set"
        ERROR=1
    fi

    if [ $ERROR = 1 ]; then
        exit -1
    fi

    TMP_DIR=`mktemp -d`
    echo "" > $TMP_DIR/metrics

    ################################################################################
    # Memory metrics
    ################################################################################

    MEM_TOTAL=`grep MemTotal: /proc/meminfo | awk '{print $2}'`
    MEM_FREE=`grep MemFree: /proc/meminfo | awk '{print $2}'`
    MEM_USED=$(($MEM_TOTAL-$MEM_FREE))

    MEM_USED_PERC="0"

    if ! [ -z $MEM_TOTAL ] && [ $MEM_TOTAL -gt 0 ]; then
        MEM_USED_PERC=`echo "$MEM_USED $MEM_TOTAL" | \
            awk '{ printf "%.2f", 100 * $1 / $2 }'`
    fi

    SWAP_TOTAL=`grep SwapTotal: /proc/meminfo | awk '{print $2}'`
    SWAP_FREE=`grep SwapFree: /proc/meminfo | awk '{print $2}'`
    SWAP_USED=$(($SWAP_TOTAL - $SWAP_FREE))

    SWAP_USED_PERC="0"

    if ! [ -z $SWAP_TOTAL ] && [ $SWAP_TOTAL -gt 0 ]; then
        SWAP_USED_PERC=`echo "$SWAP_USED $SWAP_TOTAL" | \
            awk '{ printf "%.2f", 100 * $1 / $2 }'`
    fi


    #echo "MEM_TOTAL = $MEM_TOTAL" >> $TMP_DIR/metrics
    #echo "MEM_FREE = $MEM_FREE" >> $TMP_DIR/metrics
    #echo "MEM_USED = $MEM_USED" >> $TMP_DIR/metrics
    echo "MEM_USED_PERC = $MEM_USED_PERC" >> $TMP_DIR/metrics

    #echo "SWAP_TOTAL = $SWAP_TOTAL" >> $TMP_DIR/metrics
    #echo "SWAP_FREE = $SWAP_FREE" >> $TMP_DIR/metrics
    #echo "SWAP_USED = $SWAP_USED" >> $TMP_DIR/metrics
    echo "SWAP_USED_PERC = $SWAP_USED_PERC" >> $TMP_DIR/metrics

    ################################################################################
    # Disk metrics
    ################################################################################

    /bin/df -k -P | grep '^/dev' > $TMP_DIR/df

    cat $TMP_DIR/df | while read line; do
        NAME=`echo $line | awk '{print $1}' | awk -F '/' '{print $NF}'`

        DISK_TOTAL=`echo $line | awk '{print $2}'`
        DISK_USED=`echo $line | awk '{print $3}'`
        DISK_FREE=`echo $line | awk '{print $4}'`

        DISK_USED_PERC="0"

        if ! [ -z $DISK_TOTAL ] && [ $DISK_TOTAL -gt 0 ]; then
            DISK_USED_PERC=`echo "$DISK_USED $DISK_TOTAL" | \
                awk '{ printf "%.2f", 100 * $1 / $2 }'`
        fi

        #echo "DISK_TOTAL_$NAME = $DISK_TOTAL" >> $TMP_DIR/metrics
        #echo "DISK_FREE_$NAME = $DISK_FREE" >> $TMP_DIR/metrics
        #echo "DISK_USED_$NAME = $DISK_USED" >> $TMP_DIR/metrics
        echo "DISK_USED_PERC_$NAME = $DISK_USED_PERC" >> $TMP_DIR/metrics
    done

    ################################################################################
    # PUT command
    ################################################################################

    VMID=$(source /mnt/context.sh; echo $VMID)

    curl -X "PUT" $ONEGATE_ENDPOINT/vm \
        --header "X-ONEGATE-TOKEN: `cat $ONEGATE_TOKEN`" \
        --header "X-ONEGATE-VMID: $VMID" \
        --data-binary @$TMP_DIR/metrics

.. |onegate_arch| image:: /images/onegate_arch.png
.. |onegate_context| image:: /images/onegate_context.png
