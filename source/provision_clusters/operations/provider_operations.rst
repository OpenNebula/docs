.. _provider_operations:

================================================================================
Managing Providers
================================================================================

You can manage your Edge providers with the command ``oneprovider``. This will allow you to register the provider in OpenNebula and use it. There are two ways of using it:

- As part of :ref:`an Edge Cluster definition <ddc_template>`. When you create the Edge Cluster the provider information will be used.
- You can set the provider when creating a new Edge Cluster with the command ``oneprovision create`` and the parameter ``--provider``. This will override any provider in the Edge Cluster definition template.

.. important:: The information stored in providers is encrypted due to security reasons. Because of this, a user should belong to ``oneadmin's`` group in order to use them.

Command Usage
================================================================================

The CLI command to manage Edge providers is ``oneprovider``. It follows the same structure as the other CLI commands in OpenNebula. You can check all the available commands with the option ``-h`` or ``--help``.

.. warning:: Provider information is encrypted, so it can only be managed by oneadmin or oneadmin's group user.

Create
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To create a provider, use the command ``oneprovider create``:

.. prompt:: bash $ auto

    $ oneprovider create /tmp/template.yml
    ID: 0

Check Information
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To check provider information, use the command ``oneprovider show``:

.. prompt:: bash $ auto

    $ oneprovider show 0
    PROVIDER 0 INFORMATION
    ID   : 0
    NAME : aws-frankfurt

    CONNECTION INFORMATION
    access_key : AWS access key
    secret_key : AWS secret key
    region     : eu-central-1

.. warning:: Information is shown unencrypted.

Update
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can update the provider information using the command ``oneprovider update``.

Delete
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To delete the provider, use the command ``oneprovider delete``, e,g:

.. prompt:: bash $ auto

    $ oneprovider delete 2

.. warning:: If you try to delete a provider that is being used by a provision or provision template, you will get an error.

.. _adding_provider:

Adding and Customizing Edge Providers
================================================================================

The predefined providers are located in ``/usr/share/one/oneprovision/edge-clusters/<provision_type>/providers/<provider>``. The provision type can be ``metal`` or ``virtual``, and the provider is one of the ones available.

The providers' information is loaded by the OneProvision FireEdge GUI, so the user can choose one of them in order to create his or her own provider. If you want to add a new template here, you need to follow these steps:

1. Clone one of the templates.
2. In the cloned template put the new information.
3. Restart the OneProvision FireEdge GUI ``systemctl restart opennebula-fireedge``.

.. note:: If you want to modify some of the existing providers, you just need to execute points 2 and 3.
