.. _virtual_overview:

========
Overview
========

With OneProvision you can grow up the physical resources available in your cloud. Once you have your infrastructure ready, you need to create virtual objects
in it, in order to use it. In this section we are going to show a way to deploy everything at once with OneProvision.

Template
--------

We are going to deploy a cluster with the following elements:

- 1 Host
- 2 Datastores
- 1 Virtual Network
- 1 Virtual Machine Template
- 1 Image

.. code::

    ---
    playbook: "static_vxlan"
    name: "packet_cluster"

    defaults:
    provision:
        driver: "packet"
        packet_token: "***************************"
        packet_project: "*************************"
        facility: "ams1"
        plan: "baremetal_0"
        os: "centos7"
    connection:
        public_key: '/var/lib/one/.ssh/id_rsa.pub'
        private_key: '/var/lib/one/.ssh/id_rsa'
    configuration:
        opennebula_node_kvm_param_nested: true

    cluster:
    name: "packet_cluster"

    hosts:
      - reserved_cpu: 100
        im_mad: kvm
        vm_mad: kvm
        provision:
          hostname: "<%= @name %>-host"

    datastores:
      - name: "<%= @name %>-images"
        ds_mad: fs
        tm_mad: ssh
      - name: "<%= @name %>-system"
        type: system_ds
        tm_mad: ssh
        safe_dirs: "/var/tmp /tmp"

    networks:
      - name: "<%= @name %>-hostonly_nat"
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

    marketplaceapps:
      - appname: "Ttylinux - KVM"
        name: "TTY"
        dsid: <%= @datastores[0]['ID'] %>
        meta:
          wait: true
          wait_timeout: 30

.. prompt:: bash $ auto

    $ oneprovision validate virtual.yaml && echo OK
    OK

Deployment
----------

We can now deploy the template using the command ``oneprovision create``:

.. prompt:: bash $ auto

    $ oneprovision create virtual.yaml
    ID: 24959b5c-8eca-4cd8-a3bb-dac36a7b5c1d

This will deploy the host in Packet, will configure it and will create all the objects in OpenNebula. With this specific part:

.. code::

    marketplaceapps:
    - appname: "Ttylinux - KVM"
      name: "TTY"
      dsid: <%= @datastores[0]['ID'] %>
      meta:
        wait: true
        wait_timeout: 30

OneProvision is going to export the application called Ttylinux - KVM from the marketplace into OpenNebula.
It will store the image in the image datastores created in this provision and will wait until the image is in **ready** state.

Final Result
------------

.. prompt:: bash $ auto

    $ oneprovision show 24959b5c-8eca-4cd8-a3bb-dac36a7b5c1d -x
    <PROVISION>
    <ID>24959b5c-8eca-4cd8-a3bb-dac36a7b5c1d</ID>
    <NAME>packet_cluster</NAME>
    <STATUS>pending</STATUS>
    <CLUSTERS>
        <ID>100</ID>
    </CLUSTERS>
    <DATASTORES>
        <ID>101</ID>
        <ID>100</ID>
    </DATASTORES>
    <HOSTS>
        <ID>0</ID>
    </HOSTS>
    <NETWORKS>
        <ID>0</ID>
    </NETWORKS>
    <IMAGES>
        <ID>0</ID>
    </IMAGES>
    <TEMPLATES>
        <ID>0</ID>
    </TEMPLATES>
    </PROVISION>

As you can see all the objects have been created and they belong to the same provision. This means, that when you for example delete the provision
all the objects are going to be deleted as once.

In the next sections you can check what objects can be created with oneprovision and also more details about the different options that are available.
