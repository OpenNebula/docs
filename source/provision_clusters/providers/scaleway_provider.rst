.. _scaleway_provider:

================================================================================
Scaleway Provider
================================================================================

A Scaleway provider contains the credentials to interact with Scaleway and also the location to deploy your Provisions. OpenNebula comes with three pre-defined providers in the following regions:

* PAR-1 (France - Paris)
* NL-AMS-1 (Netherlands - Amsterdam)
* PL-WAW-3 (Poland - Warsaw)

In order to define a Scaleway provider, you need the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide ``access_key``, ``secret_key`` and ``project_id``. You can follow `this guide <https://www.scaleway.com/en/docs/identity-and-access-management/iam/how-to/create-api-keys//>`__ to get this data.
* **Zone**: this is the location in the world where the resources are going to be deployed. All the available `zones are listed here <https://www.scaleway.com/en/docs/console/account/reference-content/products-availability/>`__.
* **Offers and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

.. warning:: Please note even though Scaleway support multiple OSs, the automation tools are tailored to works with ``Ubuntu 22.04``. If you use another OS, please be aware that it might required some adjustments, and things might not work as expected. Avoid using a different OS in production environment unless you've properly tested it before.

How to Create an Scaleway Provider
================================================================================

To add a new provider you need to write the previous data in YAML template:

.. prompt:: bash $ auto

    $ cat provider.yaml
    name: 'scaleway'

    description: 'Provision cluster in Scaleway Paris'
    provider: 'scaleway'

    plain:
      provision_type: 'metal'

    connection:
      access_key: 'Scaleway Access Key'
      secret_key: 'Scaleway Secret Key'
      project_id: 'Scaleway Project ID'
      zone: 'fr-par-1'

    inputs:
      - name: 'scw_baremetal_os'
        type: 'text'
        default: 'Ubuntu'
        description: 'Scaleway ost operating system'

      - name: 'scw_offer'
        type: 'list'
        default: 'EM-A115X-SSD'
        description: 'Scaleway server capacity'
        options:
          - 'EM-A115X-SSD'


Then you just need to use the command ``oneprovider create``:

.. prompt:: bash $ auto

   $ oneprovider create provider.yaml
   ID: 0

The providers' templates are located in ``/usr/share/one/oneprovision/edge-clusters/metal/providers/scaleway``. You just need to enter valid credentials.

.. include:: customize.txt
