.. _ddc_virtual:

==========================================
Managing virtual objects with OneProvision
==========================================

In this section you can check how to create all the virtual objects you need to have a cluster ready to instantiate a virtual machine. This objects are
created with the provision itselt, with the command ``oneprovision create`` and can be deleted at once with the command ``oneprovision delete``.

The available objects are the following:

- Virtual Machine Templates
- Virtual Network Templates
- Images
- Marketplace apps
- Service templates

.. note:: The marketplace apps are exported from the marketplace, so they create a new imagen and a new template.

Let's check one by one how can they be created and what special options are available for each one.

Virtual Machine Templates
-------------------------

To create some virtual machine templates, you need to add the following to your provision template:

.. code::

    templates:
        - name: "test_template"
          memory: 1
          cpu: 1

These are the three mandatory values for a template in OpenNebula. Then you can add all the information you want, everything you put there will be copy
to the virtual machine template. Please refer to this :ref:`guide<template>` to know what attributes are available.

Virtual Network Templates
-------------------------

To create some virtual machine templates you need to add the following to your provision template:

.. code::

    vntemplates:
        - name: "test_vntemplate"
          vn_mad: "bridge"
          ar:
            - ip: "10.0.0.1"
            size: 10
            type: "IP4"
          cluster_ids: 100

These are the mandatory values for a virtual network template in OpenNebula. Then you can add all the information you want, everything you put there will be copy
to the virtual network template. Please refer to this :ref:`guide<vn_templates>` to know what attributes are available.

Images
------

To create some images you need to add the following to your provision template:

.. code::

    images:
        - name: "test_image"
          ds_id: 1
          size: 2048

These are the three mandatory values for an image in OpenNebula. Then you can add all the information you want, everything you put there will be copy
to the image template. Please refer to this :ref:`guide<img_template>` to know what attributes are available.

Marketplace Apps
----------------

In this case, the marketplace app is not created, but exported from marketplace. To do this you need to add the following to your provision template:

.. code::

    marketplaceapps:
        - appid: 238
          name: "test_image_2"
          dsid: 1

These are the three mandatory values to export an image from the marketplace. Please refer to this :ref:`guide<marketapp>` to know what more options are available.

Service Templates
-----------------

To create a service template you need to add the following to your provision template:

.. code::

    flowtemplates:
        - name: "test_service"
          deployment: "straight"
          roles:
             - name: "frontend"
               vm_template: 0
             - name: "backend"
               vm_template: 1

These are the mandatory values for a service template. Please refer to this :ref:`guide<appflow_use_cli>` to know more about OneFlow templates.

.. note:: You can create more than one object at once, just add more elements to the specific list.

Ownership and Permissions
-------------------------

As these objects are created by oneprovision itself, by default the ownership correspond to the user executing the tool, normally it's oneadmin. In case
you want to change the ownership or permissions you can add the following attributes to the template:

- **uid**: user ID for the object.
- **gid**: groupd ID for the object.
- **octet**: permissions in octet format for the object.

For example, if we want to change the user for an specific image, we should add the following:

.. code::

    images:
        - name: "test_image"
          ds_id: 1
          size: 2048
          uid: 1

In this example, the image owner after creation finished would be serveradmin, which is the user with ID 1.

This applies to all objects and you can combine the three of them, for example:

.. code::

    images:
        - name: "test_image"
          ds_id: 1
          size: 2048
          uid: 1
          gid: 1
          octet: 644

In this example, the image owner would be serveradmin, the group would be users and the permissions would be 644.

Synchronous and Synchronous Modes
---------------------------------

Some objects take a bit to be ready, concretely images depending on the size. To manage this, there are two modes available:

- **asynchronous**: just create the objects and continue.
- **synchronous**: create objects and wait until they are successfully imported.

To use them, you need to add the attribute **mode** to the template, this attribute accepts two possible values **sync** or **async**. For example:

.. code::

    images:
        - name: "test_image"
          ds_id: 1
          size: 2048
          mode: async
          octet: 644

In this example, the image would be created and there won't be any wait until it's ready, the programm would continue.

The timeout to wait until the resource is ready is also configurable, it can be done adding **timeout** attribute in the object. For example:

.. code::

    images:
        - name: "test_image"
          ds_id: 1
          size: 2048
          mode: sync
          timeout: 30

In this example, the timeout to wait would be 30 seconds.

.. note:: Mode is also used when deleting the objects, so if it's sync the programm will wait until the object is deleted.

.. warning:: Mode attribute is only available for images and marketplace apps.

Combining the objects
---------------------

As these are objects that are created dinamically, there can be some relations between them. For example, we might want to use a new image that is created
in some template that is going to be created too.

For this, ERB expressions are available, so you can reference some objects that have been already created. Let's see some example about this.

.. code::

    datastores:
    - name: "test_images"
            ds_mad: fs
            tm_mad: ssh
    - name: "test_system"
            type: system_ds
            tm_mad: ssh
            safe_dirs: "/var/tmp /tmp"

    images:
        - name: "test_image"
          ds_id: <%= @datastores[0]['ID'] %>
          size: 2048

In this example, we create two datastores (system and images) and an image. We want to store the image in the image datastore we just created, so we can
reference it using the ERB expression ``@datastores[0]['ID']``.

.. code::

    images:
        - name: "test_image"
          ds_id: 1
          size: 2048

    templates:
        - name: "test_template"
          memory: 1
          cpu: 1
          disk:
            - image_id: <%= @images[0]['ID'] %>

In this example, we create an image and a template. We want the template to have a disk referencing to the new image, so we can reference it using
the ERB expression ``<%= @images[0]['ID'] %>``.

.. warning:: The order of objects creation is the following:

    - Images
    - Marketplace apps
    - Templates
    - VNetTemplates
    - Service templates

Full Example
------------

Here you can check a full provision template example:

.. code::

    name: myprovision
    playbook: default

    # Global defaults:
    defaults:
    provision:
        driver: packet
        packet_token: **************
        packet_project: ************
        facility: ams1
        plan: baremetal_0
        os: centos7
    connection:
        public_key: '/var/lib/one/.ssh/id_rsa.pub'
        private_key: '/var/lib/one/.ssh/id_rsa'
    configuration:
        opennebula_node_kvm_param_nested: true

    # List of provision objects to deploy with provision/connection/configuration overrides
    cluster:
    name: mycluster

    hosts:
    - reserved_cpu: 100
      im_mad: kvm
      vm_mad: kvm
      provision:
        hostname: "myhost1"
    - reserved_cpu: 100
      im_mad: kvm
      vm_mad: kvm
      provision:
        hostname: "myhost2"
        os: ubuntu18_04
      connection:
        remote_user: ubuntu

    datastores:
    - name: "myprovision-images"
      ds_mad: fs
      tm_mad: ssh
    - name: "myprovision-system"
      type: system_ds
      tm_mad: ssh
      safe_dirs: "/var/tmp /tmp"

    networks:
    - name: "myprovision-hostonly_nat"
      vn_mad: dummy
      bridge: br0
      dns: "8.8.8.8 8.8.4.4"
      gateway: "192.168.150.1"
      description: "Host-only networking with NAT"
      filter_ip_spoofing: "YES"
      filter_mac_spoofing: "YES"
      ar:
        - ip: 192.168.150.2
          size: 253
          type: IP4

    images:
        - name: "test_image"
          ds_id: <%= @datastores[0]['ID'] %>
          size: 2048
          uid: 1
          gid: 100
          octet: 644
          mode: 'async'

    marketplaceapps:
        - appid: 238
          name: "test_image2"
          dsid: <%= @datastores[0]['ID'] %>
          uid: 1
          gid: 100
          octet: 600
          mode: 'async'

    templates:
        - name: "test_template"
          memory: 1
          cpu: 1
          uid: 1
          gid: 100
          octet: 777
          disk:
            - image_id: <%= @images[1]['ID'] %>
          nic:
            - network_id: <%= @networks[0]['ID'] %>

    vntemplates:
        - name: "vntemplate"
          vn_mad: "bridge"
          ar:
            - ip: "10.0.0.1"
              size: 10
              type: "IP4"
        cluster_ids: <%= @clusters[0]['ID'] %>

    flowtemplates:
        - name: "my_service"
          deployment: "straight"
          roles:
            - name: "frontend"
              vm_template: <%= @templates[0]['ID'] %>
          uid: 1
          gid: 100

