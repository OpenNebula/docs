.. _marketplace:

============================================
Interacting with the OpenNebula Marketplace
============================================

The OpenNebula Marketplace is a catalog of third party virtual appliances ready to run in OpenNebula environments. The OpenNebula Marketplace only contains appliances metadata. The images and files required by an appliance will not be stored in the Marketplace, but links to them.

|image0|

Using Sunstone to Interact with the OpenNebula Marketplace
==========================================================

Since the release 3.6, Sunstone includes a new tab that allows OpenNebula users to interact with the OpenNebula Marketplace:

|image1|

If you want to import a new appliance into your local infrastructure, you just have to select an image and click the button ``import``. A new dialog box will prompt you to create a new image.

|image2|

After that you will be able use that image in a template in order to create a new instance.

Using the CLI to Interact with the OpenNebula Marketplace
=========================================================

You can also use the CLI to interact with the OpenNebula Marketplace:

-  List appliances:

.. code::

    $ onemarket list --server http://marketplace.c12g.com 
                           ID                                               NAME       PUBLISHER
     4fc76a938fb81d3517000001         Ubuntu Server 12.04 LTS (Precise Pangolin)  OpenNebula.org
     4fc76a938fb81d3517000002                                         CentOS 6.2  OpenNebula.org
     4fc76a938fb81d3517000003                                           ttylinux  OpenNebula.org
     4fc76a938fb81d3517000004                    OpenNebula Sandbox VMware 3.4.1       C12G Labs
     4fcf5d0a8fb81d1bb8000001                       OpenNebula Sandbox KVM 3.4.1       C12G Labs

-  Show an appliance:

.. code::

    $ onemarket show 4fc76a938fb81d3517000004 --server http://marketplace.c12g.com
    {
      "_id": {"$oid": "4fc76a938fb81d3517000004"},
      "catalog": "public",
      "description": "This image is meant to be run on a ESX hypervisor, and comes with a preconfigured OpenNebula 3.4.1, ready to manage a ESX farm. Several resources are created within OpenNebula (images, virtual networks, VM templates) to build a pilot cloud under 30 minutes.\n\nMore information can be found on the <a href=\"http://opennebula.org/cloud:sandbox:vmware\">OpenNebula Sandbox: VMware-based OpenNebula Cloud guide</a>.\n\nThe login information for this VM is\n\nlogin: root\npassword: opennebula",
      "downloads": 90,
      "files": [
        {
          "type": "OS",
          "hypervisor": "ESX",
          "format": "VMDK",
          "size": 693729120,
          "compression": "gzip",
          "os-id": "CentOS",
          "os-release": "6.2",
          "os-arch": "x86_64",
          "checksum": {
            "md5": "2dba351902bffb4716168f3693e932e2"
          }
        }
      ],
      "logo": "/img/logos/view_dashboard.png",
      "name": "OpenNebula Sandbox VMware 3.4.1",
      "opennebula_template": "",
      "opennebula_version": "",
      "publisher": "C12G Labs",
      "tags": [
        "linux",
        "vmware",
        "sandbox",
        "esx",
        "frontend"
      ],
      "links": {
        "download": {
          "href": "http://marketplace.c12g.com/appliance/4fc76a938fb81d3517000004/download"
        }
      }
    }

-  Create a new image: You can use the download link as PATH in a new Image template to create am Image.

.. code::

    $ onemarket show 4fc76a938fb81d3517000004 --server http://marketplace.c12g.com
    {
      ...
      "links": {
        "download": {
          "href": "http://marketplace.c12g.com/appliance/4fc76a938fb81d3517000004/download"
        }
      }
    }

    $ cat marketplace_image.one
    NAME          = "OpenNebula Sandbox VMware 3.4.1"
    PATH          = http://marketplace.c12g.com/appliance/4fc76a938fb81d3517000004/download
    TYPE          = OS

    $ oneimage create marketplace_image.one
    ID: 1231

.. |image0| image:: /images/market1306.png
.. |image1| image:: /images/sunstone_marketplace_list-1.png
.. |image2| image:: /images/sunstone_marketplace_import.png
