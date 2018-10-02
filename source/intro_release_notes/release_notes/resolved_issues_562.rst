.. _resolved_issues_562:

Resolved Issues in 5.6.2
--------------------------------------------------------------------------------

A complete list of solved issues for 5.6.2 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/21>`__.

The following new features has been backported to 5.6.2:

- New option for image datastores to further restrict the system datastores that can be used. This is useful when some system datastores in a cluster can only be used with one image datastore, e.g. use of different pools in Ceph. See `link <https://github.com/OpenNebula/one/issues/2246>`__ and :ref:`datastore definition attributes <ds_op_common_attributes>`.
- Add support to rename disk snapshots

The following issues has been solved in 5.6.2:

- `Fix issue when setting an specific CPU model <https://github.com/OpenNebula/one/issues/1688>`__.
- `Fix paginated CLI output for onehost show and oneimage show <https://github.com/OpenNebula/one/issues/2445>`__.
- `Monitoring VMs fails when there is not datastore associated <https://github.com/OpenNebula/one/issues/2433>`__.


Sunstone Note
--------------------------------------------------------------------------------

There is the new VM autorefresh feature, activated by default at 10 seconds. If you want to change the autorefresh value, you must add the following line in ``vms-tab`` in the different views:

.. code-block:: yaml

    actions:
        VM.refresh: true
        ...
        VM.menu_labels: true
    autorefresh_info: 5000 # ms
