=====================================
Howto Create Apps for the Marketplace
=====================================

In this section some general guidelines on creating OpenNebula
compatible images for the marketplace are described. Following this you
will find a tutorial showing how to create an Ubuntu 12.04 image ready
to distribute it in the marketplace.

Image Creation Guidelines
=========================

Images in the marketplace are just direct installation of OS, prepared
to run with OpenNebula. There are two basic things you need to do (apart
from the standard OS installation):

-  Add OpenNebula contextualization script, so the image is able to
receive and use context information

-  Disable udev network rule writing, usually images are cloned multiple
times, using different MAC addresses each time. In this case, you'll
need to disable udev to prevent getting a new interface each time.

These both steps can be automated in some distributions (Debian, Ubuntu,
CentOS and RHEL) using preparation packages. You can find the packages
and more information about them at the `Contextualization Packages for
VM Images </./context_overview#preparing_the_virtual_machine_image>`__
section.

Add OpenNebula Contextualization Script
---------------------------------------

The contextualization scripts configure the VM on startup. You can find
the scripts for different distributions at the `OpenNebula
repository <http://dev.opennebula.org/projects/opennebula/repository/revisions/master/show/share/scripts>`__.
Depending on the distribution the method of installation is different so
refer to the distribution documentation to do so. Make sure that these
scripts are executed before the network is initialized.

You can find more information about contextualization in the
`Contextualizing Virtual Machines </./cong>`__ guide.

Disable udev Network Rule Writing
---------------------------------

Most linux distribution upon start search for new devices and write the
configuration for them. This fixes the network device for each different
network mac address. This is a bad behavir in VM images as they will be
used to run with very different mac addresses. You need to disable this
udev configuration saving and also delete any udev network rule that
could be already saved.

Tutorial: Preparing an Ubuntu 12.04 Xen for the Marketplace
===========================================================

The installation is based on the `Ubuntu
documentation <https://help.ubuntu.com/community/XenProposed>`__. Check
the part called â€œManually creating a PV Guest VMâ€?

You will need a machine where xen is correctly configured, a bridge with
internet connection and a public IP or a private IP with access to a
router that can connecto the internet.

First we create an empty disk, in this case it will be 8 Gb:

.. code::

$ dd if=/dev/zero of=ubuntu.img bs=1 count=1 seek=8G

Then we download netboot kernel and initrd compatible with Xen. We are
using a mirror near to us but you can select one from the `Ubuntu
mirrors list <https://launchpad.net/ubuntu/+archivemirrors>`__:

.. code::

$ wget http://ftp.dat.etsit.upm.es/ubuntu/dists/precise/main/installer-amd64/current/images/netboot/xen/vmlinuz
$ wget http://ftp.dat.etsit.upm.es/ubuntu/dists/precise/main/installer-amd64/current/images/netboot/xen/initrd.gz

Now we can create a file describing the VM where the ubuntu will be
installed:

.. code:: code

name = "ubuntu"
 
memory = 256
 
disk = ['file:PATH/ubuntu.img,xvda,w']
vif = ['bridge=BRIDGE']
 
kernel = "PATH/vmlinuz"
ramdisk = "PATH/initrd.gz"

Change ``PATH`` to the path where the VM files are located and
``BRIDGE`` to the name of the network bridge you are going to use. After
this we can start the VM:

.. code::

$ sudo xm create ubuntu.xen

To connect to the VM console and proceed with the installation you can
use xm console command:

.. code::

$ sudo xm console ubuntu

Use the menus to configure your VM. Make sure that you configure the
network correctly as this installation will use it to download packages.

After the installation is done it will reboot again into the
installation. You can exit the console pressing ``<CTRL>+<]>``. Now you
should shutdown the machine:

.. code::

$ sudo xm shutdown ubuntu

The system is now installed in the disk image and now we must start it
to configure it so it plays nice with OpenNebula. The configuratio we
are going to do is:

-  Disable udev network generation rules and clean any that could be
saved
-  Add contextualization scripts

To start the VM we will need a new xen description file:

.. code:: code

name = "ubuntu1204"
 
memory = 512
 
disk = ['file:PATH/ubuntu.img,xvda,w']
vif = ['bridge=BRIDGE']
 
bootloader = "pygrub"

It is pretty similar to the other one but notice that we no longer
specify kernel nor initrd and we also add the bootloader option. This
will make out VM use the kernel and initrd that reside inside out VM
image.

We can start it using the same command as before:

.. code::

$ sudo xm create ubuntu-new.xen

And the console also works the same as before:

.. code::

$ sudo xm console ubuntu

We log and become ``root``. To disable udev network rule generation we
should edit the file
``/lib/udev/rules.d/75-persistent-net-generator.rules`` and comment the
line that says:

.. code:: code

DRIVERS=="?*", IMPORT{program}="write_net_rules"

Now to make sure that no network rules are saved we can empty the rules
file:

.. code::

# echo '' > /etc/udev/rules.d/70-persistent-net.rules

Copy the contextualiza located at the `OpenNebula
repository <http://dev.opennebula.org/projects/opennebula/repository/revisions/master/entry/share/scripts/ubuntu/net-vmcontext/vmcontext>`__
to ``/etc/init.d`` and give it write permissions. This is the script
that will contextualize the VM on start.

Now we modify the file ``/etc/init/networking.conf`` and change the
line:

.. code:: code

pre-start exec mkdir -p /run/network

by

.. code:: code

pre-start script
mkdir -p /run/network
/etc/init.d/vmcontext
end script

and also in ``/etc/init/network-interface.conf`` we add the line:

.. code:: code

/etc/init.d/vmcontext

so it looks similar to:

.. code:: code

pre-start script
/etc/init.d/vmcontext
if [ "$INTERFACE" = lo ]; then
# bring this up even if /etc/network/interfaces is broken
ifconfig lo 127.0.0.1 up || true
initctl emit -n net-device-up \
IFACE=lo LOGICAL=lo ADDRFAM=inet METHOD=loopback || true
fi
mkdir -p /run/network
exec ifup --allow auto $INTERFACE
end script

