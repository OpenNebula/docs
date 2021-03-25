.. _ddc_virtual:

============================
Virtual Objects Provisioning
============================

With OneProvision you can grow up the physical resources available in your cloud. Once you have your infrastructure ready, you need to create virtual objects in it, in order to use it. In this section we are going to show a way to deploy everything at once with OneProvision.

.. _ddc_virtual_objects:

Managing Virtual Objects
================================================================================

In this section you can check how to create all the virtual objects you need to have a cluster ready to instantiate a virtual machine. These objects are created with the provision itself, with the command ``oneprovision create`` and can be deleted at once with the command ``oneprovision delete``.

The available objects are the following:

* Images
* Marketplace apps
* Virtual Machine Templates
* Virtual Network Templates
* OneFlow Service templates

.. note:: The marketplace apps are exported from the marketplace, so they create a new imagen and a new template.

.. note:: They are created in the order they appear in the list.

Virtual Machine Templates
--------------------------------------------------------------------------------

To create virtual machine templates, you need to add the following to your provision template:

.. code::

    templates:
      - name: "test_template"
        memory: 1
        cpu: 1

These are the three mandatory values for a template in OpenNebula. Then you can add all the information you want, everything you put there will be copy to the virtual machine template. Please refer to this :ref:`guide<template>` to know what attributes are available.

Virtual Network Templates
--------------------------------------------------------------------------------

To create virtual machine templates you need to add the following to your provision template:

.. code::

    vntemplates:
      - name: "test_vntemplate"
        vn_mad: "bridge"
        ar:
          - ip: "10.0.0.1"
            size: 10
            type: "IP4"

These are the mandatory values for a virtual network template in OpenNebula. Then you can add all the information you want, everything you put there will be copy to the virtual network template. Please refer to this :ref:`guide<vn_templates>` to know what attributes are available.

Images
--------------------------------------------------------------------------------

To create images you need to add the following to your provision template:

.. code::

    images:
      - name: "test_image"
        ds_id: 1
        size: 2048

These are the three mandatory values for an image in OpenNebula. Then you can add all the information you want, everything you put there will be copy to the image template. Please refer to this :ref:`guide<img_template>` to know what attributes are available.

Marketplace Apps
--------------------------------------------------------------------------------

In this case, the marketplace app is not created, but exported from marketplace. To do this you need to add the following to your provision template:

.. code::

    marketplaceapps:
      - appid: 238
        name: "test_image_2"
        dsid: 1

These are the three mandatory values to export an image from the marketplace. Please refer to this :ref:`guide<marketapp>` to know what more options are available.

.. note:: You can also use **appname** instead of appid.

OneFlow Service Templates
--------------------------------------------------------------------------------

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

.. _ddc_virtual_perms:

Ownership and Permissions
================================================================================

All the virtual OpenNebula objects are created by oneprovision itself, by default the ownership corresponds to the user executing the tool, normally it is oneadmin. In case
you want to change the ownership or permissions you can add the following attributes to the template:

* **uid**: user ID for the object.
* **gid**: group ID for the object.
* **uname**: user name for the object.
* **gname**: group name for the object.
* **mode**: permissions in octet format for the object.

For example, if we want to change the user for an specific image, we should add the following:

.. code::

    images:
        - name: "test_image"
          ds_id: 1
          size: 2048
          meta:
            uid: 1

In this example, the image owner after creation finished would be serveradmin, which is the user with ID 1.

This applies to all objects and you can combine the three of them, for example:

.. code::

    images:
        - name: "test_image"
          ds_id: 1
          size: 2048
          meta:
            uid: 1
            gid: 1
            mode: 644

In this example, the image owner would be serveradmin, the group would be users and the permissions would be 644.

You can also use the **uname** and **gname**, for example:

.. code::

    images:
        - name: "test_image"
          ds_id: 1
          size: 2048
          meta:
            uname: user1
            gname: users
            mode: 644

In this example, the image owner would be user1 and the group would be users.

.. _ddc_virtual_wait:

Wait Modes
================================================================================

Some objects take a bit to be ready, concretely images depending on the size. To manage this, you can use the attribute wait, it can have two possible values:

* **false**: just create the objects and continue.
* **true**: create objects and wait until they are successfully imported.

For example:

.. code::

    images:
      - name: "test_image"
        ds_id: 1
        size: 2048
        meta:
          wait: false
          mode: 644

In this example, the image would be created and there will not be any wait until it is ready, the program would continue.

The timeout to wait until the resource is ready is also configurable, it can be done adding **wait_timeout** attribute in the object. For example:

.. code::

    images:
      - name: "test_image"
        ds_id: 1
        size: 2048
        meta:
          wait: true
          wait_timeout: 30

In this example, the timeout to wait would be 30 seconds.

.. warning:: Wait attribute is only available for images and marketplace apps.

Using Wait Globally
--------------------------------------------------------------------------------

As we have seen, you can set the wait per object in the provision template, but you can also set it globally using the CLI. There are two parameters available:

* **wait-ready**: with this the tool will wait until the resources are ready.
* **wait-timeout timeout**: with this you can set the timeout (default = 60s).

.. note:: The provision template wait and timeout are not overwritten by these parameters in the command, if you set some in the template they are respected.

For example:

.. code::

    $ oneprovision create virtual.yaml --wait-ready --wait-timeout 60

With this command the program will wait for all objects with a timeout of 60 seconds.

.. _ddc_virtual_all:

Referencing Objects
================================================================================

As all these are objects that are created dynamically, there can be some relations between them. For example, we might want to use a new image that is created
in a template that is going to be created too.

The syntax is ``${object.name.attribute}``, the available objects are:

* cluster
* datastore
* host
* image
* network
* template
* vntemplate
* marketplaceapp

There are special keys:

* **provision**: this will be replaced by the provision name.
* **provision_id**: this will be replaced by the provision ID.
* **index**: this is an auto increment index, can be used to auto generated hostnames in hosts.

.. warning:: You can only reference to static names, reference to autogenerated names is not allowed.

For example:

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
        ds_id: ${datastore.test_images.id}
        size: 2048

In this example, we create two datastores (system and images) and an image. We want to store the image in the image datastore we just created, so we can reference it in the following way:

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
          - image_id: ${image.test_image.id}

.. warning:: The order of objects creation is the following:

    * Images
    * Marketplace apps
    * Templates
    * VNetTemplates
    * Service templates

.. _ddc_user_inputs:

User Inputs
================================================================================

These user inputs work in the same way as OpenNebula ones do. They allow you to define multiple variables that should be asked to the user. The available types are:

* Array
* Boolean
* Fixed
* Float
* List
* Number
* Password
* Range
* Text
* Text64

To use them you need to add the key ``inputs`` into your provision template, e.g:

.. prompt:: bash $ auto

    inputs:
      - name: 'array_i'
        type: 'array'
        default: 'h1,h2,h3'
      - name: 'text_i'
        type: 'text'
        default: 'This is a text'
      - name: 'bool_i'
        type: 'boolean'
        default: 'NO'
      - name: 'password_i'
        type: 'password'
        default: '1234'
      - name: 'count_i'
        description: 'Number of hosts of this provision'
        type: 'range'
        min_value: 1
        max_value: 100
        default: 2
     - name: 'list_i'
       type: 'list'
       options:
         - 'OPT 1'
         - 'OPT 2'
         - 'OPT 3'
         - 'OPT 4'
       default: 'OPT 1'

Then to use them in your template, you need to use the syntax defined above: ``${input.name}``, where ``name`` is the name of the user input, e.g:

.. prompt:: bash $ auto

    networks:
      - name: 'vpc'
        vn_mad: 'dummy'
        bridge: 'br0'
        provision:
          t: ${input.text_i}
          b: ${input.bool_i}
          p: ${input.password_i}
          l: ${input.list_i}

When you create a provision using a template with user inputs on it, the tool will ask for the value of each of them, e.g:

.. prompt:: bash $ auto

    $ oneprovision create test.yaml -D --skip-provision

    Text `text_i` (default=This is a text): test

    Bool `bool_i` (default=NO): YES

    Pass `password_i` (default=1234):

        0  OPT 1
        1  OPT 2
        2  OPT 3
        3  OPT 4

    Please type the selection number (default=1): 0

    2020-11-16 17:08:48 INFO  : Creating provision objects
    2020-11-16 17:08:48 DEBUG : Creating OpenNebula cluster: AWS
    2020-11-16 17:08:48 DEBUG : Cluster created with ID: 102
    2020-11-16 17:08:48 DEBUG : Creating datastore my_system
    2020-11-16 17:08:48 DEBUG : datastore created with ID: 100
    2020-11-16 17:08:48 DEBUG : Creating network vpc
    2020-11-16 17:08:48 DEBUG : network created with ID: 2
    2020-11-16 17:08:48 DEBUG : Creating OpenNebula host: provision-be36728d598f5d976994c2a98485114875a4219b2da3c8e9
    2020-11-16 17:08:49 DEBUG : host created with ID: 3
    2020-11-16 17:08:49 DEBUG : Creating OpenNebula host: provision-c6d9631cef25c88e39c94ad1d33767348bb2e9541aabab51
    2020-11-16 17:08:49 DEBUG : host created with ID: 4
    ID: 3

.. prompt:: bash $ auto

    $ onevnet show 2
    ....
    VIRTUAL NETWORK TEMPLATE
    BRIDGE="br0"
    BRIDGE_TYPE="linux"
    OUTER_VLAN_ID=""
    PHYDEV=""
    PROVISION=[ B="YES", L="OPT 1", P="1111", SUB_CIDR="10.0.1.0/24", T="test" ]
    PROVISION_ID="3"
    SECURITY_GROUPS="0"
    VLAN_ID=""
    VN_MAD="dummy"

As you can see the user inputs are resolved and the value is copied to the object template.

.. note:: If you want to use them in a non interactive way, you can use the parameter ``--user-inputs ui1,ui2,ui3``.

You can use the ``array`` to define multiple host names, e.g:

.. prompt:: bash $ auto

    hosts:
      - im_mad: 'kvm'
        vm_mad: 'kvm'
        provision:
          hostname: ${input.array_i}
        count: ${input.count_i}

This will create ``count`` hosts and will add them the host name included in the array.
