=======================
Basic Contextualization
=======================

This guide shows how to automatically configure networking in the
initialization process of the VM. Following are the instructions to
contextualize your images to configure the network. For more in depth
information and information on how to use this information for other
duties head to the `Advanced Contextualization </./cong>`__ guide.

Preparing the Virtual Machine Image
===================================

To enable the Virtual Machine images to use the contextualization
information written by OpenNebula we need to add to it a series of
scripts that will trigger the contextualization.

You can use the images available in the Marketplace, that are already
prepared, or prepare your own images. To make your life easier you can
use a couple of Linux packages that do the work for you.

The contextualization package will also mount any partition labeled
``swap`` as swap. OpenNebula sets this label for volatile swap disks.

-  Start a image (or finish its installation)
-  Install context packages with one of these methods:

-  Install from our repositories package 'one-context' in
Ubuntu/Debian or 'opennebula-context' in CentOS/RedHat.
Instructions to add the repository at the `installation
guide </./documentation:rel4.2:ignc#package_installation_front-end>`__.
-  Download and install the package for your distribution:

-  `DEB <http://dev.opennebula.org/attachments/download/750/one-context_4.4.0.deb>`__:
Compatible with Ubuntu 11.10 to 13.04 and Debian Squeeze
-  `RPM <http://dev.opennebula.org/attachments/download/747/one-context_4.4.0.rpm>`__:
Compatible with CentOS and RHEL 6.x

-  Shutdown the VM

Preparing the Template
======================

We will also need to add the gateway information to the Virtual Networks
that need it. This is an example of a Virtual Network with gateway
information:

.. code:: code

NAME=public
NETWORK_ADDRESS=80.0.0.0
NETWORK_MASK=255.255.255.0
GATEWAY=80.0.0.1
DNS="8.8.8.8 8.8.4.4"

And then in the VM template contextualization we set NETWORK to
â€œyesâ€?:

.. code:: code

CONTEXT=[
NETWORK=YES ]

When the template is instantiated, those parameters for \`eth0\` are
automatically set in the VM as:

.. code:: code

CONTEXT=[
DISK_ID="0",
ETH0_DNS="8.8.8.8 8.8.4.4",
ETH0_GATEWAY="80.0.0.1",
ETH0_IP="80.0.0.2",
ETH0_MASK="255.255.255.0",
ETH0_NETWORK="80.0.0.0",
NETWORK="YES",
TARGET="hda" ]

If you add more that one interface to a Virtual Machine you will end
with same parameters changing ETH0 to ETH1, ETH2, etc.

You can also add \`SSH\_PUBLIC\_KEY\` parameter to the context to add a
SSH public key to the \`authorized\_keys\` file of root.

.. code:: code

CONTEXT=[
SSH_PUBLIC_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+vPFFwem49zcepQxsyO51YMSpuywwt6GazgpJe9vQzw3BA97tFrU5zABDLV6GHnI0/ARqsXRX1mWGwOlZkVBl4yhGSK9xSnzBPXqmKdb4TluVgV5u7R5ZjmVGjCYyYVaK7BtIEx3ZQGMbLQ6Av3IFND+EEzf04NeSJYcg9LA3lKIueLHNED1x/6e7uoNW2/VvNhKK5Ajt56yupRS9mnWTjZUM9cTvlhp/Ss1T10iQ51XEVTQfS2VM2y0ZLdfY5nivIIvj5ooGLaYfv8L4VY57zTKBafyWyRZk1PugMdGHxycEh8ek8VZ3wUgltnK+US3rYUTkX9jj+Km/VGhDRehp user@host"
]

If you want to known more in deep the contextualization options head to
the `Advanced Contextualization guide </./cong>`__.
