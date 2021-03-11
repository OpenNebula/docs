.. _terraform:

================================================================================
Terraform OpenNebula Provider
================================================================================

Terraform is used to create, manage, and manipulate infrastructure resources (e.g. physical machines, VMs, network switches, containers, etc.). Almost any infrastructure noun can be represented as a resource in Terraform. The OpenNebula provider is officially supported by HashiCorp and fully open source, the repository is available `here <https://github.com/terraform-providers/terraform-provider-opennebula>`__.

The OpenNebula provider is used to interact with OpenNebula resources trough Terraform. The provider allow you to manage your OpenNebula clusters resources. It needs to be configured with proper credentials before it can be used.

The provider official documentation can be found `here <https://www.terraform.io/docs/providers/opennebula/index.html>`__.

Usage
==================

In order to use the OpenNebula Terraform provider, Terraform have to be `installed <https://learn.hashicorp.com/terraform/getting-started/install.html>`__ first. Once Terraform is installed you can start defining the infrastructure:

.. code::

    # Define a new datablockimage
    resource "opennebula_virtual_machine" "myfirstvm-tf" {
        ...
    }

Once ``terraform init`` is executed with OpenNebula resources defined in any ``*.tf`` file the provider will be automatically retrieved by Terraform.

Building from Source
==============================

Another way of using the terraform provider is building it from source code. A complete guide on how to do this can be found in the provider `repository <https://github.com/terraform-providers/terraform-provider-opennebula#from-source>`__.
