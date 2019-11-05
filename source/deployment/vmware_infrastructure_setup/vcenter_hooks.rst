.. _vcenter_hooks:

vCenter Hooks
=============

Introduction
------------
OpenNebula has two hooks to manage networks in vCenter and NSX included by default.

+----------------------+--------------------------------------------------------+
| Hook Name            | Hook Description                                       |
+======================+========================================================+
| vcenter_net_create   | Allows you to create / import vCenter and NSX networks |
+----------------------+--------------------------------------------------------+
| vcenter_net_delete   | Allows you to delete vCenter and NSX networks          |
+----------------------+--------------------------------------------------------+

These hooks should be created automatically when you add a vCenter cluster, but if not or if you deleted them you can create them again manually.

Go to `Create vCenter Hooks`_ and follow the steps to create a new hook.

.. note:: For detailed information about how hooks work go to: :ref:`hooks`


List vCenter Hooks
------------------
Type the next command to list the hooks created:

.. prompt:: bash $ auto

    $ onehook list

The output of the command should be something like this:

.. image:: /images/nsx_hook_list.png


Create vCenter Hooks
--------------------
To create a new hook, type the following command:

.. prompt:: bash $ auto

    $ onehook create <template_file>

Where template file is the name of the file that contains the hook info.

You can find the included templates for vcenter here:

    - `vcenter_net_create template`_
    - `vcenter_net_delete template`_


Delete vCenter Hooks
--------------------
To delete a hook you need to know first its ID, so list the hooks to find which one you want delete and take note of its ID.

Once you have the hook ID, type the following command:

.. prompt:: bash $ auto

    $ onehook delete <hook_id>

After execute this command check that the hook was correctly deleted, listing again the hooks.


vcenter_net_create template
---------------------------
You can use this template to create a file called **create_vcenter_net.tmpl** and create a hook that allows you to create/import virtual networks for vcenter and NSX following the instructions here: `Create vCenter Hooks`_

.. prompt:: bash $ auto

    NAME = vcenter_net_create
    TYPE = api
    COMMAND = vcenter/create_vcenter_net.rb
    CALL = "one.vn.allocate"
    ARGUMENTS = "$API"
    ARGUMENTS_STDIN = yes

Here is the latest version included into OpenNebula code:

`create_vcenter_net.tmpl <https://raw.githubusercontent.com/OpenNebula/one/master/share/hooks/vcenter/templates/create_vcenter_net.tmpl>`__

.. _vcenter_net_delete_template:

vcenter_net_delete template
---------------------------
You can use this template to create a file called **delete_vcenter_net.tmpl** and create a hook that allows you to delete virtual networks for vcenter and NSX following the instructions here: `Create vCenter Hooks`_

.. prompt:: bash $ auto

    NAME = vcenter_net_delete
    TYPE = api
    COMMAND = vcenter/delete_vcenter_net.rb
    CALL = "one.vn.delete"
    ARGUMENTS = "$API"
    ARGUMENTS_STDIN = yes

Here is the latest version included into OpenNebula code:

`delete_vcenter_net.tmpl <https://raw.githubusercontent.com/OpenNebula/one/master/share/hooks/vcenter/templates/delete_vcenter_net.tmpl>`__




