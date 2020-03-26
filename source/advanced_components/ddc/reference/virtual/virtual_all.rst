.. _ddc_virtual_all:

===================
Referencing Objects
===================

As all these are objects that are created dynamically, there can be some relations between them. For example, we might want to use a new image that is created
in a template that is going to be created too.

For this, ERB expressions are available, so you can reference objects that have been already created. Let's see some example about this.

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

    # List of OpenNebula infrastructure objects to deploy with provision/connection/configuration overrides
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
        meta:
          uid: 1
          gid: 100
          mode: 644

    marketplaceapps:
      - appid: 238
        name: "test_image2"
        dsid: <%= @datastores[0]['ID'] %>
        meta:
          uid: 1
          gid: 100
          mode: 600
          wait: true

    templates:
      - name: "test_template"
        memory: 1
        cpu: 1
        disk:
          - image_id: <%= @images[1]['ID'] %>
        nic:
          - network_id: <%= @networks[0]['ID'] %>
        meta:
          uid: 1
          gid: 100
          mode: 777

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
        meta:
          uid: 1
          gid: 100
