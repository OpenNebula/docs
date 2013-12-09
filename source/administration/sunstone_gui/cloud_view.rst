=======================
Self-service Cloud View
=======================

This is a simplified view mainly intended for cloud consumers that just
require a portal where they can provision new virtual machines easily.
They just have to select one of the available templates and the
operating system that will run in this virtual machine. For more
information about the suntone views, please check the following
`guide </./suns_views>`__

In this scenario the cloud administrator must prepare a set of templates
and images and make them available to the cloud users. Templates must
define all the required parameters and just leave the DISK section
empty, so the user can select any of the available images. New virtual
machines will be created merging the information provided by the user
(image, vm\_nameâ€¦) and the base template. Thereby, the user doesn't
have to know any details of the infrastructure such as networking,
storageâ€¦

|image0|

How to Configure
================

These are the steps that an administrator should follow in order to
prepare a self-service scenario for his users.

Create the Cloud Group
----------------------

Create a new group for the users, to which you want to expose the cloud
vie.

.. code::

$ onegroup create cloud_consumers

Update the ``/etc/one/sunstone-views.yaml`` file adding the new group
and the desired view (``cloud``).

.. code:: code

groups:
oneadmin:
- admin
- user
cloud_consumers:
- cloud

and restart sunstone-server after that.

Create new users in this group

.. code::

$ oneuser crete new_user password
$ oneuser chgrp new_user cloud_consumer

You can modify the functionality that is exposed in this view, in the
``/etc/one/sunstone-views/cloud.yaml`` file.

Prepare a Set of Templates
--------------------------

Prepare a set of template that the cloud consumers will use to create
new instances. These templates should define all the required parameters
of the virtual machine that depends on you network, storageâ€¦ but
should not define the OS image of the virtual machine. The OS image will
be selected by the user in the creation dialog along with the template.

Example:

.. code::

$ cat small-x1-1GB.template
NAME   = small-x1-1GB
MEMORY = 1024
CPU    = 1

NIC = [ NETWORK = "Public" ]

GRAPHICS = [
TYPE    = "vnc",
LISTEN  = "0.0.0.0"]

$ cat large-x4-8GB.template
NAME   = large-x4-8GB
MEMORY = 8192
CPU    = 8

NIC = [ NETWORK = "Public" ]

GRAPHICS = [
TYPE    = "vnc",
LISTEN  = "0.0.0.0"]

$ onetemplate create small-x1-1GB.template
$ onetemplate create large-x4-8GB.template

If you want to make these template available to the users of the
cloud\_cosumers group, the easiest way is to move them to that group and
enable the use permission for group:

.. code::

ontemplate chgrp small-x1-1GB.template cloud_consumers
ontemplate chmod small-x1-1GB.template 640

You can also create the template using the Sunstone wizard

Prepare a Set of OS Images
--------------------------

Prepare a set of images that will be used by the cloud consumers in the
templates that were created in the previous step.

.. code::

$ oneimage create --datastore default --name Ubuntu-1204 --path /home/cloud/images/ubuntu-desktop \
--description "Ubuntu 12.04 desktop for students."
$ oneimage create --datastore default --name CentOS-65 --path /home/cloud/images/ubuntu-desktop \
--description "CentOS-65 desktop for developers."

If you want to make these available available to the users of the
cloud\_consumers group, the easiest way is to move them to that group
and enable the use permission for group:

.. code::

oneimage chgrp Ubuntu-1204 cloud_consumers
oneimage chmod CentOS-65 640

The Cloud Consumer View
=======================

End users that want to interact with Sunstone have to open a new browser
and go to the url where the Sunstone server is deployed. They will find
the login screen where the username and password correspond to the
OpenNebula credentials.

|image1|

Launch a New VM in Three Steps
------------------------------

-  Define a name and the number of instances
-  Select one of the available templates
-  Select one of the available OS images

|image2|

Internationalization and Languages
----------------------------------

Sunstone support multiple languages. Users can change it from the
settings dialog:

|views\_settings.jpg| |views\_conf.jpg|

.. |image0| image:: /./_media/cloud-view.png?w=650
:target: /./_media/cloud-view.png?id=
.. |image1| image:: /./_media/documentation:sunstonelogin4.png?w=400
:target: /./_detail/documentation:sunstonelogin4.png?id=
.. |image2| image:: /./_media/cloud-view.png?w=650
:target: /./_media/cloud-view.png?id=
.. |views\_settings.jpg| image:: /./_media/views_settings.jpg?w=250
:target: /./_detail/views_settings.jpg?id=
.. |views\_conf.jpg| image:: /./_media/views_conf.jpg?w=650
:target: /./_detail/views_conf.jpg?id=
