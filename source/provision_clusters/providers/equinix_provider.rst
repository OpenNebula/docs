.. _equinix_provider:

================================================================================
Equinix Provider
================================================================================

An Equinix provider contains the credentials to interact with Equinix and also the location to deploy your Edge Clusters. OpenNebula comes with four pre-defined providers in the following regions:

* Amsterdam
* Parsippany (NJ, US)
* Tokyo
* California (US)

In order to define an Equinix provider, you need the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide ``token`` and ``project``. You can follow `this guide <https://metal.equinix.com/developers/api/>`__ to get this data.
* **Facility**: this is the location in the world where the resources are going to be deployed. All the available `facilities are listed here <https://www.equinix.com/data-centers/>`__.
* **Plans and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

How to Create an Equinix Provider
================================================================================

To add a new provider you need to write the previous data in YAML template:

.. prompt:: bash $ auto

    $ cat provider.yaml
    name: 'equinix-amsterdam'

    description: 'Edge cluster in Equinix Amsterdam'
    provider: 'equinix'

    connection:
      token: 'Equinix token'
      project: 'Equinix project'
      facility: 'ams1'

    inputs:
      - name: 'equinix_os'
        type: 'list'
        options:
          - 'centos_8'
      - name: 'equinix_plan'
        type: 'list'
        options:
          - 'baremetal_0'

Then you just need to use the command ``oneprovider create``:

.. prompt:: bash $ auto

   $ oneprovider create provider.yaml
   ID: 0

The providers' templates are located in ``/usr/share/one/oneprovision/edge-clusters/<type>/providers/equinix``. You just need to enter valid credentials.

How to Customize an Existing Provider
================================================================================

The provider information is stored in the OpenNebula database and can be updated just like any other resource. In this case, you need to use the command ``oneprovider update``. It will open an editor so you can edit all the information there. You can also use the OneProvision FireEdge GUI to update all the information.

