.. _google_provider:

================================================================================
Google Provider
================================================================================

A Google provider contains the credentials to interact with Google and also the region of the provider to deploy your Provisions. OpenNebula comes with four pre-defined providers in the following regions:

* Belgium
* London
* Moncks (US)
* Oregon (US)

In order to define a Google provider, you need the following information:

* **Credentials**: these are used to interact with the Google Compute Engine service. You need to provide a ``credentials`` JSON file, see more details `in this guide <https://cloud.google.com/docs/authentication/getting-started>`__.
* **Region**: this is the location in the world where the resources are going to be deployed. All the available regions are `listed here <https://cloud.google.com/compute/docs/regions-zones>`__.
* **Google instance and image**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

.. include:: activate_virtual.txt

How to Add a New Google Provider
================================================================================

To add a new provider you need a YAML template file with the following information:

.. prompt:: bash $ auto

    $ cat provider.yaml
    name: 'google-belgium'

    description: 'Elastic cluster on Google in Belgium'
    provider: 'google'

    plain:
      image: 'GOOGLE'
      location_key:
        - 'region'
        - 'zone'
      provision_type: 'virtual'

    connection:
      credentials: 'JSON credentials file path'
      project: 'Google Cloud Plataform project ID'
      region: 'europe-west1'
      zone: 'europe-west1-b'

    inputs:
      - name: 'google_image'
        type: 'list'
        options:
          - 'centos-8-v20210316'
      - name: 'google_machine_type'
        type: 'list'
        options:
          - 'e2-standard-2'
          - 'e2-standard-4'
          - 'e2-standard-8'

Then you just need to use the command ``oneprovider create``:

.. prompt:: bash $ auto

   $ oneprovider create provider.yaml
   ID: 0

The providers' templates are located in ``/usr/share/one/oneprovision/edge-clusters/virtual/providers/google``. You just need to enter valid credentials.

.. include:: customize.txt
