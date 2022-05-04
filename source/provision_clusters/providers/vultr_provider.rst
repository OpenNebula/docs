.. _vultr_provider:

==========================
Vultr Provider
==========================

A Vultr provider contains the credentials to interact with Vultr and also the location to deploy your Provisions. OpenNebula comes with four pre-defined providers in the following regions:

* Amsterdam
* London
* Chicago
* San Francisco

In order to define a Vultr provider, you need the following information:

* **Key**: this is used to interact with the remote provider. You need to provide ``key``. You can follow `this guide <https://www.vultr.com/api/#section/Authentication>`__ to get this data.
* **Region**: this is the location in the world where the resources are going to be deployed. All the available `regions are listed here <https://www.vultr.com/features/datacenter-locations/>`__.
* **Plans and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

.. warning:: Please note even though Vultr support multiple OSs, the automation tools are tailored to works with ``Ubuntu 20.04``. If you use another OS, please be aware that it might required some adjustments, and things might not work as expected. Avoid using a different OS in production environment unless you've properly tested it before.

..
  Replace variables from activate_virtual.txt

.. |PROVIDER| replace:: vultr_virtual.yaml

.. include:: activate_virtual.txt

..
  Replace variables from activate_virtual.txt

.. |PROVIDER_METAL| replace:: vultr.*

.. include:: activate_metal.txt

How to Create a Vultr Provider
================================================================================

To add a new provider you need to write the previous data in YAML template:

Virtual:

.. prompt:: bash $ auto

    $ cat provider.yaml
    name: 'vultr-amsterdam'

    description: 'Edge cluster in Vultr Amsterdam'
    provider: 'vultr_metal'

    connection:
      key: 'Vultr key'
      region: 'ams'

    inputs:
      - name: 'vultr_os'
        type: 'list'
        default: '387'
        options:
          - '387'
      - name: 'vultr_plan'
        type: 'list'
        default: 'vbm-4c-32gb'
        options:
          - 'vbm-4c-32gb'


Metal:

.. prompt:: bash $ auto

    $ cat provider.yaml
    name: 'vultr-amsterdam'

    description: 'Edge cluster in Vultr Amsterdam'
    provider: 'vultr_metal'

    connection:
      key: 'Vultr key'
      region: 'ams'

    inputs:
      - name: 'vultr_os'
        type: 'list'
        default: '387'
        options:
          - '387'
      - name: 'vultr_plan'
        type: 'list'
        default: 'vbm-4c-32gb'
        options:
          - 'vbm-4c-32gb'

Then you just need to use the command ``oneprovider create``:

.. prompt:: bash $ auto

   $ oneprovider create provider.yaml
   ID: 0

The providers templates for metal and virtual Provisions are located in ``/usr/share/one/oneprovision/edge-clusters/metal/providers/vultr`` and ``/usr/share/one/oneprovision/edge-clusters/virtual/providers/vultr``, respectively. You just need to enter valid credentials.

.. include:: customize.txt

