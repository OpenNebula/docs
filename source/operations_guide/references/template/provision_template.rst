.. _ddc_provision_template_document:

==================
Provision Template
==================

The provision template is used to deploy an infrastructure, it defines all the objects that are going to be created in OpenNebula and the remote provider.
This provision template is a YAML format file that is used by the `oneprovision` tool, but this file is almost always the same, so instead of using
all the times the same file, it can be stored in the OpenNebula database.

The provision template object is a JSON representation of the provision template file. It stores the same information, but in a different format.
You can create the provision template directly from your file without doing any change, just using the command ``oneprovision-template create``.
It can be instantiated as any other template in OpenNebula using the command ``oneprovision-template instantiate``.

Command Usage
=============

The CLI command to manage provision templates is ``oneprovision-template``, it follows the same structure as the other CLI commands in OpenNebula.
You can check all the available commands with the option ``-h`` or ``--help``.

.. warning:: Provision template information is encrypted, so it can only be managed by oneadmin or oneadmin's group user.

Create
^^^^^^

To create a provision template use the command ``oneprovision-template create``, e.g:

.. prompt:: bash $ auto

    $ cat template.yaml
    ---
    name: docs
    playbook:
      - default

    # Global defaults:
    defaults:
      provision:
          provider: packet
      connection:
          public_key: '/var/lib/one/.ssh/id_rsa.pub'
          private_key: '/var/lib/one/.ssh/id_rsa'
      configuration:
          opennebula_node_kvm_param_nested: true

    cluster:
      name: docs

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          plan: baremetal_0
          os: centos_7
          hostname: "docs-host"

    $ oneprovision-template create template.yaml
    ID: 1

.. note:: You need to first create the provider you can to use. Check :ref:this <ddc_provider> for more information.

Check Information
^^^^^^^^^^^^^^^^^

To check provision template information use the command ``oneprovision-template show``, e.g:

.. prompt:: bash $ auto

    $ oneprovision-template show 1
    PROVISION TEMPLATE 2 INFORMATION
    ID   : 1
    NAME : docs

    PROVISION TEMPLATE
    {
      "name": "docs",
      "provider": "0",
      "registration_time": 1602065880,
      "playbooks": [
          "default"
      ],
      "defaults": {
          "provision": {
            "provider": "packet"
          },
          "connection": {
            "public_key": "/var/lib/one/.ssh/id_rsa.pub",
            "private_key": "/var/lib/one/.ssh/id_rsa"
          },
          "configuration": {
            "opennebula_node_kvm_param_nested": true
          }
      },
      "hosts": [
          {
            "reserved_cpu": 100,
            "im_mad": "kvm",
            "vm_mad": "kvm",
            "provision": {
                "hostname": "docs-host",
                "plan": "baremetal_0",
                "os": "centos_7"
            }
          }
      ],
      "cluster": {
          "name": "docs"
      }
    }

Update
^^^^^^

You can update the provision template information using the command ``oneprovision-template update``.

Instantiate
^^^^^^^^^^^

When you instantiate a provision template, it will deploy all the objects defined in the template. To do it you need to use the command ``oneprovision-template instantiate``, e.g:

.. prompt:: bash $ auto

    $ oneprovision-template instantiate 1
    ID: 2

    $ oneprovision list --no-expand
    ID NAME            CLUSTERS HOSTS NETWORKS DATASTORES         STAT
     2 docs                   1     1        0          0      RUNNING

.. note:: All the options in the command ``oneprovision create`` are supported.

You can also overwrite provision information by using an extra file when instantiating, e.g:

.. prompt:: bash $ auto

    $ cat extra.yaml
    ---
    defaults:
    provision:
        plan: 'baremetal_0'
        os: 'centos_7'

    $ oneprovision-template instantiate 1 extra.yaml
    ID: 3

This will overwrite template defaults section. You can also combine this with ``--provider`` to be able to have a provision template that works
in any provider.

Delete
^^^^^^

To delete the provision template use the command ``oneprovision-template delete``, e,g:

.. prompt:: bash $ auto

    $ oneprovision-template delete 2
