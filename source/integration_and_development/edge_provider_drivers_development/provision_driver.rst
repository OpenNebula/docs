.. _devel-provider:

================================================================================
Edge Cluster Providers
================================================================================

An Edge Cluster provider is responsible to interface with the Cloud or Edge provider to provision the Edge cluster resources including hosts, public IPs or any other abstraction required to support the cluster. Note that the specific artifacts needed depended on the features and capabilities of each provider.

.. important:: THIS SECTION IS UNDERWORK

Terraform Representaion
================================================================================

The first step is to develop a representation of the Edge Cluster using Terraform. OpenNebula will use the Terraform driver for the target provider to provision the Edge Cluster infrastructure.

Step 1. Register the Provider
--------------------------------------------------------------------------------

* Add to the list of PROVIDERS in ``terraform.rb``
* Add base class to interface the new provider

Step 2. Create Terraform templates for each resource
--------------------------------------------------------------------------------

Templates use ERB template syntax. TODO link

* Templates are located ``src/oneprovision/lib/terraform/providers/templates/``. Describe goal of cluster.erb, provider.erb...
* Describe how to access provision variables

Example: AWS add a commented description of AWS templates


Ansible Configuration
================================================================================

Then you need to add an ansible playbook for the provisions created on the new provider. As an starting point you can use one of the existing ones.

* Describe where are located, include link to ansible reference
* mention how to add new roles, link to ansible reference

Example AWS (aws.ymal) add example commented

Provision Templates
================================================================================

Finally you need to add templates for the provisions on the new provider.

* Describe where are the files, include link to provision reference

Example aws.yaml + aws.d, comment examples.
