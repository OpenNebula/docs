.. _vultr_provider:

==========================
Vultr Provider
==========================

A Vultr provider contains the credentials to interact with Vultr and also the location to deploy your Edge Clusters. OpenNebula comes with four pre-defined providers in the following regions:

* Amsterdam
* London
* Chicago
* San Francisco

In order to define a Vultr provider, you need the following information:

* **Key**: this is used to interact with the remote provider. You need to provide ``key``. You can follow `this guide <https://www.vultr.com/api/#section/Authentication>`__ to get this data.
* **Region**: this is the location in the world where the resources are going to be deployed. All the available `regions are listed here <https://www.vultr.com/features/datacenter-locations/>`__.
* **Plans and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

How to Create an Vultr Provider
================================================================================

To add a new provider you need to write the previous data in YAML template:

Virtual:

.. prompt:: bash $ auto

    $ cat provider.yaml
    name: 'vultr-amsterdam'

    description: 'Edge cluster in Vultr Amsterdam'
    provider: 'vultr_virtual'

    plain:
      image: 'VULTR'
      location_key: 'region'
      provision_type: 'virtual'

    connection:
      key: 'Vultr key'
      region: 'ams'

    inputs:
      - name: 'vultr_os'
        type: 'list'
        options:
          - '387'
      - name: 'vultr_plan'
        type: 'list'
        options:
          - 'vc2-1c-1gb'
          - 'vc2-1c-2gb'
          - 'vc2-1c-4gb'

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

The providers' templates are located in ``/usr/share/one/oneprovision/edge-clusters/virtual/providers/vultr``. You just need to enter valid credentials.

How to Customize an Existing Provider
================================================================================

The provider information is stored in the OpenNebula database and can be updated just like any other resource. In this case, you need to use the command ``oneprovider update``. It will open an editor so you can edit all the information there. You can also use the OneProvision FireEdge GUI to update all the information.


