.. _do_provider:

================================================================================
DigitalOcean Providers
================================================================================

A DigitalOcean provider contains the credentials to interact with DigitalOcean service and also the region to deploy your Provisions. OpenNebula comes with four pre-defined providers in the following regions:

* Amsterdam
* London
* New York (US)
* San Franciso (US)
* Singapur

In order to define a DigitalOcean provider, you need the following information:

* **Credentials**: to authenticate with DigitalOcean service. You need to provide ``token``, check `this guide for more details <https://www.digitalocean.com/community/tutorials/how-to-use-oauth-authentication-with-digitalocean-as-a-user-or-developer>`__.
* **Region**: this is the location in the world where the resources are going to be deployed. All the available regions are `listed here <https://docs.digitalocean.com/products/platform/availability-matrix/>`__.

..
  Replace variables from activate_virtual.txt

.. |PROVIDER| replace:: digitalocean.yaml

.. include:: activate_virtual.txt

How to Add a New DigitalOcean Provider
================================================================================

To add a new provider you need a YAML template file with the following information:

.. prompt:: bash $ auto

    $ cat provider.yaml
    name: 'digitalocean-nyc3'

    description: 'Virtual Edge Cluster in DigitalOcean datacenter in New York City (NYC3)'
    provider: 'digitalocean'

    connection:
      token: 'DigitalOcean token'
      region: 'nyc3'

    inputs:
      - name: 'digitalocean_image'
        type: list
        description: "Droplet host operating system"
        default: 'ubuntu-20-04-x64'
        options:
          - 'ubuntu-20-04-x64'
      - name: 'digitalocean_size'
        type: list
        description: "Size of droplet. Basic droplets start with s-, memory optimize with m- and CPU optimize are c-"
        default: 's-1vcpu-1gb'
        options:
          - 's-1vcpu-1gb'
          - 's-1vcpu-2gb'
          - 's-1vcpu-3gb'
          - 's-2vcpu-2gb'
          - 's-2vcpu-4gb'
          - 's-4vcpu-8gb'
          - 's-8vcpu-16gb'
          - 'm-2vcpu-16gb'
          - 'm-8vcpu-64gb'
          - 'c-2'
          - 'c-4'
          - 'c-8'

Then you just need to use the command ``oneprovider create``:

.. prompt:: bash $ auto

   $ oneprovider create provider.yaml
   ID: 0

The providers' templates are located in ``/usr/share/one/oneprovision/edge-clusters/virtual/providers/digitalocean``. You just need to enter valid connection ``token``.

.. include:: customize.txt
