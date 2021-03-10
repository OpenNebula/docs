.. _aws_cluster:

===================
AWS Edge Cluster
===================

Supported Edge Cluster Types
================================================================================

* Enumerate the ec supported: metal, virtual
* Enumerate the supported hypervisors: kvm, fc, lxc

AWS Providers
================================================================================
* What is an AWS provider ---> aws zone. List of predefined providers
* AWS parameters needed to define a provider
* Instance types and AMI's
* Locations
* How to add a new AWS provider
* How to customize and existing provider

AWS Edge Cluster Details
================================================================================
* List of AWS created as part of a provision
* Security Groups
* Public Networking implementation -> elastic IPs (overview of forwarding)
* Private Networking FRR (BGP-EVPN) and VXLAN overview
* VPC and IP limitations

Operating Providers & Edge Clusters
================================================================================
Link to Edge Cluster Operations guide



REFERENCE FROM PROVIDER (GENRIC GUIDE IN DDC) (FOLLOW SAME APPROACH FOR EACH CLUSTER TYPE)


In edge provision deployment, you need to specify the connection parameters to interact with the remote provider and also the location where
you want to deploy those resources. This information is independent from the provision, it is always the same. To be able to reuse it, you can use
the providers. A provider is basically the connection parameters plus the location, it is a JSON document stored in the database.

To operate with providers you can use the command ``oneprovider``. This will allow you to register the provider into OpenNebula and use it. There are
two ways of using it:

- You can combine the use of the provider and the :ref:`provision template <ddc_provision_template_document>`. You can define a provision template with a provider inside of it and when you instantiate it, all the provider information will be used.
- You can use the provider when creating a new provision with command ``oneprovision create`` using the parameter ``--provider``.

Command Usage
=============

The CLI command to manage providers is ``oneprovider``, it follows the same structure as the other CLI commands in OpenNebula. You can check all the available commands with the option ``-h`` or ``--help``.

.. warning:: Provider information is encrypted, so it can only be managed by oneadmin or oneadmin's group user.

Create
^^^^^^

To create a provider use the command ``oneprovider create``, e.g:

.. prompt:: bash $ auto

    $ cat packet.yaml
    ---
    name: packet
    provider: packet
    connection:
      token:    '****************************'
      project:  '****************************'
      facility: 'ams1'
    $ oneprovider create packet.yaml
    ID: 0

.. prompt:: bash $ auto

    $ cat aws.yaml
    ---
    name: aws
    provider: aws
    connection:
      access_key: '*********************'
      secret_key: '*********************'
      region:     'eu-central-1'
    $ oneprovider create aws.yaml
    ID: 1

.. note:: You need to specify a valid credentials.

.. warning:: Supported providers are ``aws`` and ``packet``.

Check Information
^^^^^^^^^^^^^^^^^

To check provider information use the command ``oneprovider show``, e.g:

.. prompt:: bash $ auto

    $ oneprovider show 0
    $ pd show 0
    PROVIDER 0 INFORMATION
    ID   : 0
    NAME : packet

    CONNECTION INFORMATION
    token    : ************************************
    project  : ************************************
    facility : ams1

.. warning:: Information is showed unecrypted.

Update
^^^^^^

You can update the provider information using the command ``oneprovider update``.

Delete
^^^^^^

To delete the provider use the command ``oneprovider delete``, e,g:

.. prompt:: bash $ auto

    $ oneprovider delete 2

.. warning:: If you try to delete a provider that is being used by a provision or provision template, you will get an error.
