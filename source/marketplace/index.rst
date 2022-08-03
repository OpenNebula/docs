.. _marketplaces:

================================================================================
Appliances and Marketplaces
================================================================================

OpenNebula Marketplaces provide a simple way to integrate your cloud with popular application/image providers. Think of them as external datastores.

A Marketplace can be:

* **Public**: accessible universally by all OpenNebula installations.
* **Private**: local within an organization and specific for a single OpenNebula (a single zone) or shared by a federation (a collection of zones). If you are interested in setting up your own :ref:`private Marketplace, please follow this guide <private_marketplaces>`.

A Marketplace stores Marketplace Appliances. A MarketPlace Appliance includes one or more Images and, possibly, some associated metadata like VM Templates or OpenNebula Multi-VM service definitions.


.. toctree::
   :maxdepth: 2

   Public Marketplaces <public_marketplaces/index>
   Private Marketplaces <private_marketplaces/index>
   Appliances <appliances/index>
