.. _ddc_template:

==================
Template Reference
==================

The provision is a process of allocating new physical resources from the remote providers. All the information needed is stored in the provision template file and passed to the ``oneprovision create`` command.

In this chapter, we'll describe the format and content of the provision template.

.. _ddc_provision_template:

A **provision template** is a YAML-formatted file with parameters specifying the new physical resources to be provisioned. It contains:

* header (name, configuration playbook, parent template)
* global default parameters for

  * remote connection (SSH),
  * host provision driver,
  * host configuration tunales.

* list of OpenNebula infrastructure objects (cluster, hosts, datastores, virtual networks) to deploy with overrides to the global defaults above.

* list of OpenNebula virtual objects (images, templates, vnet templates, marketplace apps, service templates). :ref:`See here for more information <ddc_virtual>`.

.. _ddc_provision_template_header:

Header
--------------------------------------------------------------------------------

+-----------------+----------------------------------------------------------------------------------+
| Parameter       | Description                                                                      |
+=================+==================================================================================+
| ``name``        | Name of provision.                                                               |
+-----------------+----------------------------------------------------------------------------------+
| ``playbook``    | Ansible playbook used for hosts configuration.                                   |
+-----------------+----------------------------------------------------------------------------------+
| ``extends``     | Parent template to include and extend. Provide the custom **absolute filename**. |
+-----------------+----------------------------------------------------------------------------------+

Shared sections
--------------------------------------------------------------------------------

The following shared sections can be specified inside the template ``defaults``, or directly inside each OpenNebula provision object (cluster, datastore, virtual network, and host). Parameters specified on the object side have higher priority and override the parameters from ``defaults``.

.. _ddc_provision_template_connection:

connection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This section contains parameters for the remote SSH connection on the privileged user or the user with escalation rights (via ``sudo``) of the newly provisioned host(s).

+-----------------+-----------------------------------------------+-------------------------------------------+
| Parameter       | Default                                       | Description                               |
+=================+===============================================+===========================================+
| ``remote_user`` | ``root``                                      | Remote user to connect via SSH.           |
+-----------------+-----------------------------------------------+-------------------------------------------+
| ``remote_port`` | ``22``                                        | Remote SSH service port.                  |
+-----------------+-----------------------------------------------+-------------------------------------------+
| ``public_key``  | ``/var/lib/one/.ssh-oneprovision/id_rsa.pub`` | Path or content of the SSH public key.    |
+-----------------+-----------------------------------------------+-------------------------------------------+
| ``private_key`` | ``/var/lib/one/.ssh-oneprovision/id_rsa``     | Path or content of the SSH private key.   |
+-----------------+-----------------------------------------------+-------------------------------------------+

.. _ddc_provision_template_provision:

provision
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This section contains parameters for the provisioning provider.

+-----------------+--------------------------------------+-----------------------------------------------+
| Parameter       | Default                              | Description                                   |
+=================+======================================+===============================================+
| ``provider``    | none, needs to be specified          | Host provision driver.                        |
+-----------------+--------------------------------------+-----------------------------------------------+

.. _ddc_provision_template_configuration:

configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This section provides parameters for the host configuration process (e.g. KVM installation, host networking etc.). All parameters are passed to the external configuration tool (Ansible), and all available parameters are covered by the :ref:`configuration <ddc_config_roles>` chapter.

.. _ddc_provision_template_devices:

OpenNebula infrastructure objects
--------------------------------------------------------------------------------

Sections ``cluster``, ``hosts``, ``datastores``, ``networks`` contain list of OpenNebula infrastructure objects to be deployed with all the necessary parameters for deployment and creation in OpenNebula. The object structure is a YAML representation of an OpenNebula template with additional shared sections (``connection``, ``provision``, ``configuration``).

.. note::

    It's possible to deploy only a single cluster. The section ``cluster`` is a dictionary. All other sections are lists.

.. note::

    Hosts have an special attribute ``count``, this attribute allow you to deploy the same host multiple times, without having to specify all of them.

    The following example, deploy two hosts with the same configuration:

    .. prompt:: bash $ auto

        hosts:
        - reserved_cpu: 100
          im_mad: kvm
          vm_mad: kvm
          provision:
            hostname: "myhost1"
          count: 2

    The resulting hostanmes would be ``myhost1_0`` and ``myhost1_1``.

Example of datastore defined from regular template:

.. prompt:: bash $ auto

    $ cat ds.tpl
    NAME="myprovision-images"
    TM_MAD="ssh"
    DS_MAD="fs"

    $ onedatastore create ds.tpl
    ID: 328

Example of the same datastore defined in provision template:

.. code::

    datastores:
      - name: "myprovision-images"
        ds_mad: fs
        tm_mad: ssh

OpenNebula virtual objects
--------------------------------------------------------------------------------

Sections ``images``, ``marketplaceapps``, ``templates``, ``vnetemplates``, ``flowtemplates`` contain list of OpenNebula virtual objects to be created with all the necessary parameters for the creation in OpenNebula. The object structure is a YAML representation of and OpenNebula template.

Example of VM template defined from regular template:

.. prompt:: bash $ auto

    $ cat template.tpl
    NAME="test_template"
    MEMORY=128
    CPU=1

    $ onetemplate create template.tpl
    ID: 0

Example of the same VM template defined in provision template:

.. code::

    templates:
      - name: "test_template"
        memory: 1
        cpu: 1
