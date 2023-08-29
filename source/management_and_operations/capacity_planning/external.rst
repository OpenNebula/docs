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
- ``ID``: VM's ID
- ``STATE``: Current state in string form
- ``USER_TEMPLATE``: including all attributes

For instance, the following JSON illustrates a request for 3 VMs along with their corresponding matching hosts:

.. code-block:: json

    {
      "VMS": [
        {
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
          "STATE": "PENDING",
          "USER_TEMPLATE": {}
        },
        {
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
          "STATE": "PENDING",
          "USER_TEMPLATE": {}
        },
        {
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
          "ID": 34,
          "STATE": "PENDING",
          "USER_TEMPLATE": {}
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

To configure, simply assign the URL for contacting the external scheduler to the ``EXTERNAL_SCHEDULER`` attribute. For more details, refer to the :ref:`scheduler configuration <schg_configuration>`.
