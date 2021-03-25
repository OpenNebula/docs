.. _provider_operations:

================================================================================
Managing Providers
================================================================================

You can manage your Edge providers with the command ``oneprovider``. This will allow you to register the provider into OpenNebula and use it. There are two ways of using it:

- As part of :ref:`an Edge Cluster definition <ddc_provision_template_document>`. When you create the Edge Clusterthe provider information will be used.
- You can set the provider when creating a new Edge Cluster with command ``oneprovision create`` and the parameter ``--provider``. This will override any provider in the Edge Cluster definition template.

Command Usage
================================================================================

The CLI command to manage Edge Providers is ``oneprovider``, it follows the same structure as the other CLI commands in OpenNebula. You can check all the available commands with the option ``-h`` or ``--help``.

.. warning:: Provider information is encrypted, so it can only be managed by oneadmin or oneadmin's group user.

Check Information
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To check provider information use the command ``oneprovider show``:

.. warning:: Information is showed unecrypted.

Update
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can update the provider information using the command ``oneprovider update``.

Delete
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To delete the provider use the command ``oneprovider delete``, e,g:

.. prompt:: bash $ auto

    $ oneprovider delete 2

.. warning:: If you try to delete a provider that is being used by a provision or provision template, you will get an error.

Adding and Customizing Edge Providers
================================================================================
