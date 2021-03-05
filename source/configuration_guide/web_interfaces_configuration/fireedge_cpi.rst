.. _fireedge_cpi:

================================================================================
FireEdge OneProvision
================================================================================

What Is?
========

**FireEdge OneProvision** is a Graphical User Interface (GUI) that simplifies the
typical management operations in :ref:`hybrid <true_hybrid_cloud_reference_architecture>`
cloud infrastructures.

.. TODO REF

FireEdge OneProvision is build using `oneprovision` tool which allows the deployment of OpenNebula clusters
with all resources needed to run VMs, hosts, datastores or virtual networks. More information in the :ref:oneprovision documentation <ddc_usage>.

Configuration
==============

When the :ref:`FireEdge server is installed <fireedge_configuration>`, you can check the :ref:`configuration FireEdge
file <fireedge_install_configuration>` which has the following specifics options to OneProvision GUI:

+----------------------------------------+----------------------------+-----------------------------------------------------+
|          Option                        | Default Value              | Description                                         |
+========================================+============================+=====================================================+
| :oneprovision_prepend_command          | ""                         | Prepend for oneprovision command                    |
+----------------------------------------+----------------------------+-----------------------------------------------------+
| :oneprovision_optional_create_command  | ""                         | Optional param for oneprovision command create      |
+----------------------------------------+----------------------------+-----------------------------------------------------+

Usage
=====

The OneProvision tool allows the deployment an operational OpenNebula cluster in a remote
provider (public cloud).

.. TODO REF

Each new provision is described by the :ref:provision template <default_ddc_templates>, a set of YAML documents specifying the OpenNebula resources to add.

These templates can be found in ``/usr/share/one/oneprovision/provisions``.

FireEdge OneProvision uses these templates to define a **dynamic form** which references
the inputs described. E.g.

.. code:: yaml

  inputs:
   - name: 'aws_ami_image'
     type: 'list'
     options:
       - 'ami-0e342d72b12109f91'
       - 'ami-0b793c1e0d1dc4d28'
   - name: 'aws_instance_type'
     type: 'list'
     options:
       - 'i3-metal'

-------------------------------------------------------------------------------
Create a provider
-------------------------------------------------------------------------------

To deploy a complete edge provision with oneprovision from GUI, you need first a
remote provider. Including the connection parameters and location where deploy
those resources.

First, to **create a provider**, go to provider list view:

|image_provider_list_empty|

Then, **click over plus button** and fill the form:

|image_provider_create_step1|

|image_provider_create_step2|

|image_provider_create_step3|

You now have a **new provider**.

-------------------------------------------------------------------------------
Create a provision
-------------------------------------------------------------------------------

Let's go now to **create a provision**, and follow the same steps:

|image_provision_list_empty|

**Select the provider** where you will deploy the provision:

|image_provision_create_step1|

|image_provision_create_step2|

|image_provision_create_step3|

|image_provision_create_step4|

Once form is completed, you can see it at list:

|image_provision_list|

Let's explore **the log and detailed information**

|image_provision_info|

|image_provision_log|


.. |image_provider_list_empty| image:: /images/fireedge_cpi_provider_list1.png
.. |image_provider_list| image:: /images/fireedge_cpi_provider_list2.png
.. |image_provider_create_step1| image:: /images/fireedge_cpi_provider_create1.png
.. |image_provider_create_step2| image:: /images/fireedge_cpi_provider_create2.png
.. |image_provider_create_step3| image:: /images/fireedge_cpi_provider_create3.png

.. |image_provision_list_empty| image:: /images/fireedge_cpi_provision_list1.png
.. |image_provision_list| image:: /images/fireedge_cpi_provision_list2.png
.. |image_provision_create_step1| image:: /images/fireedge_cpi_provision_create1.png
.. |image_provision_create_step2| image:: /images/fireedge_cpi_provision_create2.png
.. |image_provision_create_step3| image:: /images/fireedge_cpi_provision_create3.png
.. |image_provision_create_step4| image:: /images/fireedge_cpi_provision_create4.png
.. |image_provision_info| image:: /images/fireedge_cpi_provision_show1.png
.. |image_provision_log| image:: /images/fireedge_cpi_provision_log.png
