.. _external_scheduler:

================================================================================
External Schedulers
================================================================================

The default OpenNebula scheduler can interface with external schedulers to implement additional algorithms tailored to your specific use case or business logic. Communication is established through a straightforward REST API. This guide will walk you through configuring and developing your own external scheduler.

External Scheduler API
================================================================================

The scheduler employs a simple REST API. When the external scheduler is configured, the OpenNebula scheduler triggers a `POST` operation to the designated URL. The request body consists of an array of `VMs`, each encapsulating the following information:

- ``CAPACITY``: An array indicating the VM's capacity requirements:

  - ``CPU``: Requested relative CPU shares (e.g. 0.5)
  - ``MEMORY``: Memory in kilobytes
  - ``DISK``: Additional disk space in the system datastore (in megabytes)

- ``HOST_IDS``: A list of IDs for hosts meeting the VM requirements
- ``HOST_ID``: Host ID, where the VM is deployed. Used only if the VM is requested to reschedule (migrate) to other host.
- ``ID``: VM's ID
- ``STATE``: Current state in string form
- ``ATTRIBUTES``: Custom attributes as specified in :ref:`scheduler configuration <schg_configuration>` in ``EXTERNAL_VM_ATTR``.

For instance, the following JSON illustrates a request for 3 VMs along with their corresponding matching hosts:

.. code-block:: json

    {
      "VMS": [
        {
          "VM_ATTRIBUTES": {
            "GNAME": "oneadmin",
            "UNAME": "oneadmin"
          },
          "CAPACITY": {
            "CPU": 1.5,
            "DISK_SIZE": 1024,
            "MEMORY": 131072
          },
          "HOST_IDS": [
            3,
            4,
            5
          ],
          "ID": 32,
          "STATE": "PENDING"
        },
        {
          "VM_ATTRIBUTES": {
            "GNAME": "users",
            "UNAME": "userA"
          },
          "CAPACITY": {
            "CPU": 1.5,
            "DISK_SIZE": 1024,
            "MEMORY": 131072
          },
          "HOST_IDS": [
            3,
            4,
            5
          ],
          "ID": 33,
          "STATE": "PENDING"
        },
        {
          "VM_ATTRIBUTES": {
            "GNAME": "users",
            "UNAME": "userA"
          },
          "CAPACITY": {
            "CPU": 1.5,
            "DISK_SIZE": 1024,
            "MEMORY": 131072
          },
          "HOST_IDS": [
            4,
            5
          ],
          "HOST_ID": 3,
          "ID": 34,
          "STATE": "RUNNING"
        }
      ]
    }

The external scheduler should respond with a similar structure, incorporating the chosen HOST_ID for each VM. For example, the response to the aforementioned request might appear as follows:

.. code-block:: json

    {
      "VMS": [
        {
          "ID": 32,
          "HOST_ID": 3
        },
        {
          "ID": 33,
          "HOST_ID": 3
        },
        {
          "ID": 34,
          "HOST_ID": 5
        }
      ]
    }


Configuration
================================================================================

To configure, simply assign the URL for contacting the external scheduler to the ``EXTERNAL_SCHEDULER`` attribute, and optionally add additional ``VM_ATTRIBUTES`` to the JSON request document. For more details, refer to the :ref:`scheduler configuration <schg_configuration>`.

External Scheduler Server Example
================================================================================
Below is a straightforward template to help you in creating your custom external schedulers. This template is written in Ruby and uses the Sinatra web framework. The primary function of this scheduler is to take the initial list of hosts for each virtual machine and randomize the host allocation based on the Virtual Machine ID:

.. code-block:: ruby

    require 'sinatra'

    before do
        content_type 'application/json'
    end

    post '/' do
        body = request.body.read
        data = JSON.parse body

        vms = []
        response = { :VMS => vms }

        # Go through all Virtual Machines
        data['VMS'].each do |vm|
            hosts = vm['HOST_IDS']

            next if hosts.nil? || hosts.empty?

            # Randomize the host based on the VM ID
            host_id = hosts[vm['ID'].to_i % hosts.size]

            vms << { :ID => vm['ID'], :HOST_ID => host_id }
        end

        response.to_json
    end
