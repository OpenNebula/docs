.. _upgrade_56:

=================================
Additional Steps for 5.6.x
=================================

Upgrade OpenNebula to the latest version
============================================

Upgrade your environment using the guide that better adapts to your setup from the ones listed :ref:`here <start_here>`. Once your environment is upgraded, please follow the sections below.

Update ServerAdmin password to SHA256
=====================================

Since 5.10 passwords and tokens are generated using SHA256. OpenNebula will update the DB automatically for your regular users (including oneadmin). However, you need to do the update for serveradmin manually. You can do so, with:

.. prompt:: text # auto

    $ oneuser passwd --sha256 serveradmin `cat /var/lib/one/.one/sunstone_auth|cut -f2 -d':'`

Update your Hooks
================================================================================

Hooks are no longer defined in ``oned.conf``. You need to recreate any hook you are using in the OpenNebula database. Specific upgrade actions for each hook type are described below.

RAFT/HA Hooks
--------------------------------------------------------------------------------
HA Hooks keep working as they did in previous versions. For design reasons, these are the only hooks which need to be defined in ``oned.conf`` and cannot be managed via the API or CLI. You should preserve your previous configuration in ``oned.conf``.

Fault Tolerance Hooks
--------------------------------------------------------------------------------
In order to migrate fault tolerance hooks, just follow the steps defined in :ref:`Fault Tolerance guide <ftguide>`.

vCenter Hooks
--------------------------------------------------------------------------------
The vCenter Hooks, used for creating virtual networks, will be created automatically when needed.

Custom Hooks
--------------------------------------------------------------------------------
Custom Hooks migration strongly depends on your use case for the hook. Below there is a list of examples which represent the most common use cases.

- Create/Remove hooks. Corresponds to the legacy ``ON=CREATE`` and ``ON=REMOVE`` hooks

These hooks are now triggered by an API hook on the corresponding create/delete API call. For example, the following hook sends an email to the user when her user account is created:

.. code::

   USER_HOOK = [
       name      = "mail",
       on        = "CREATE",
       command   = "email2user.rb",
       arguments = "$ID $TEMPLATE"]

Now, since OpenNebula 5.12, you need to create the following hook template:

.. code::

    NAME      = "mail",
    TYPE      = API
    CALL      = "one.user.allocate",
    COMMAND   = "email2user.rb",
    ARGUMENTS = "$TEMPLATE"

and define the hook with ``onehook create`` command.

.. important:: To emulate the ``ON=CREATE`` hook for VMs an API hook can be defined for ``one.template.instantiate`` and ``one.vm.allocate``.

In general, any create/remove hook can be migrated using the following template:

.. code::

    NAME = hook-create-resource
    TYPE = api
    COMMAND = "<same-script-path>"
    ARGUMENTS = "<same-arguments>"
    CALL = "one.<resource>.allocate"

More information on defining :ref:`API Hooks can be found here <api_hooks>`.

- State hooks

If there is a hook defined for a Host or VM state change, the hook template has to be inferred from the Hook definition in the 5.8 ``oned.conf`` file; see the example below:

.. code::

    # Legacy hook definition in oned.conf

        VM_HOOK = [
        name      = "advanced_hook",
        on        = "CUSTOM",
        state     = "ACTIVE",
        lcm_state = "BOOT_UNKNOWN",
        command   = "log.rb",
        arguments = "$ID $PREV_STATE $PREV_LCM_STATE" ]

    # Hook template file

        NAME = advanced_hook
        TYPE = state
        COMMAND = "log.rb"
        ARGUMENTS = "$TEMPLATE"
        RESOURCE = VM
        ON = CUSTOM
        STATE = ACTIVE
        LCM_STATE = BOOT_UNKNOWN

Note that you may need to adapt the arguments of your hook, as ``$ID`` is not currently supported. More information on defining :ref:`state Hooks can be found here <state_hooks>`.

.. note:: Note that, in both examples, ``ARGUMENTS_STDIN=yes`` can be used for passing the parameters via STDIN instead of command line argument.

Known Issues
============

If the MySQL database password contains special characters, such as ``@`` or ``#``, the onedb command will fail to connect to it.

The workaround is to temporarily change the oneadmin's password to an ASCII string. The `set password <http://dev.mysql.com/doc/refman/5.6/en/set-password.html>`__ statement can be used for this:

.. code::

    $ mysql -u oneadmin -p

    mysql> SET PASSWORD = PASSWORD('newpass');

Bug recovering
================

If Ceph datastores were used with OpenNebula <= 5.6.2 and any VM have been reverted to a snapshot, it's needed to follow the next steps for recovering snapshot tree consistency:

.. warning:: Check history in order to find how many reverts have been done. If the number of reverts are greater than 1 we do not recommend to deleted any snapshot, becase it will cause lose of information. If the number of revert is 1 you can fix it by following the steps below.

- Use the command ``onedb update-body vm --id <vm_id>`` for updating the body of the VM.
- Set /VM/SNAPSHOTS/CURRENT_BASE to the ID of the current active snapshot.
