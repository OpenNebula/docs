.. _ddc_virtual_objects:

========================
Managing Virtual Objects
========================

In this section you can check how to create all the virtual objects you need to have a cluster ready to instantiate a virtual machine. These objects are
created with the provision itselt, with the command ``oneprovision create`` and can be deleted at once with the command ``oneprovision delete``.

The available objects are the following:

- Images
- Marketplace apps
- Virtual Machine Templates
- Virtual Network Templates
- OneFlow Service templates

.. note:: The marketplace apps are exported from the marketplace, so they create a new imagen and a new template.

.. note:: They are created in the order they appear in the list.

Virtual Machine Templates
-------------------------

To create virtual machine templates, you need to add the following to your provision template:

.. code::

    templates:
      - name: "test_template"
        memory: 1
        cpu: 1

These are the three mandatory values for a template in OpenNebula. Then you can add all the information you want, everything you put there will be copy
to the virtual machine template. Please refer to this :ref:`guide<template>` to know what attributes are available.

Virtual Network Templates
-------------------------

To create virtual machine templates you need to add the following to your provision template:

.. code::

    vntemplates:
      - name: "test_vntemplate"
        vn_mad: "bridge"
        ar:
          - ip: "10.0.0.1"
            size: 10
            type: "IP4"

These are the mandatory values for a virtual network template in OpenNebula. Then you can add all the information you want, everything you put there will be copy
to the virtual network template. Please refer to this :ref:`guide<vn_templates>` to know what attributes are available.

Images
------

To create images you need to add the following to your provision template:

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

.. note:: You can also use **appname** instead of appid.

OneFlow Service Templates
-------------------------

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
