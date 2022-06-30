.. _resolved_issues_641:

Resolved Issues in 6.4.1
--------------------------------------------------------------------------------


A complete list of solved issues for 6.4.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/60?closed=1>`__.

The following new features has been backported to 6.4.1:

- `onedb update-body from a text/xml file from stdin <https://github.com/OpenNebula/one/issues/4959>`__.
- `CLI chmod commands with g/u/o + permissions <https://github.com/OpenNebula/one/issues/5356>`__.
- `Use "%i" in custom attributes and improve auto-increment in VM name <https://github.com/OpenNebula/one/issues/2287>`__.
- `Extend onelog with object logs <https://github.com/OpenNebula/one/issues/5844>`__.
- `Add Update VM Configuration form to FireEdge Sunstone <https://github.com/OpenNebula/one/issues/5836>`__.
- `Add JSON format to oneprovision subcommands <https://github.com/OpenNebula/one/issues/5883>`__.
- `Select vGPU profile <https://github.com/OpenNebula/one/issues/5885>`__.
- `OneFlow resilient to oned timeouts <https://github.com/OpenNebula/one/issues/5814>`__.
- `Add resource labels to FireEdge Sunstone <https://github.com/OpenNebula/one/issues/5862>`__.

The following issues has been solved in 6.4.1:

- `Make log output configurable for all services <https://github.com/OpenNebula/one/issues/1149>`__.
- `Fix provision document get's broken after: onedb udpate document <https://github.com/OpenNebula/one/issues/5742>`__.
- `Fix VM instantiation when VM name input is hidden <https://github.com/OpenNebula/one/issues/5826>`__.
- `Fix HCI deployment after upgrade of v6.0 stable branch to ansible-core 2.10 <https://github.com/OpenNebula/one/issues/5840>`__.
- `Fix onelog missing validations <https://github.com/OpenNebula/one/issues/5843>`__.
- `Fix KVM wilds are not correctly retrieved <https://github.com/OpenNebula/one/issues/5846>`__.
- `Show descriptive error on Sunstone when click on remote connections <https://github.com/OpenNebula/one/issues/5851>`__.
- `Fix quota rollback if command 'onevm snapshot-create' fails <https://github.com/OpenNebula/one/issues/5852>`__.
- `Fix double VM_POOL element in onevm list -x <https://github.com/OpenNebula/one/issues/5858>`__.
- `Fix bug in send_to_monitor function <https://github.com/OpenNebula/one/issues/5855>`__.
- `Fix user inputs for encrypted attributes <https://github.com/OpenNebula/one/issues/5559>`__.
- `Get hypervisor from VM history instead HYPERVISOR attribute for VM migration <https://github.com/OpenNebula/one/issues/5854>`__.
- `Fix OneProvision GUI when provisions fields are empty <https://github.com/OpenNebula/one/issues/5840>`__.
- `Fix Dependency error in oneflow-template <https://github.com/OpenNebula/one/issues/5769>`__.
- `Fix command oneprovision host ssh fails <https://github.com/OpenNebula/one/issues/5815>`__.
- `Fix VM Template in Sunstone when setting memory cost in GB <https://github.com/OpenNebula/one/issues/5873>`__.
- `Fix revert operation for image active snapshot <https://github.com/OpenNebula/one/issues/3250>`__.
- `Fix recovery actions for wild VMs upon import failure by falling back to use user_template/hypervisor <https://github.com/OpenNebula/one/issues/5800>`__.
- `'Fix onevm disk-saveas' to not accept snapshot name as snapshot ID <https://github.com/OpenNebula/one/issues/5790>`__.
- `Fix ETIME while terminating VM in poweroff state <https://github.com/OpenNebula/one/issues/5874>`__.
- `Fix VM snapshots after recreate on 'onevm recover --recreate' <https://github.com/OpenNebula/one/issues/5450>`__.
- `Fix quotas in case onevm action (create, resize, ...) fails, fix quotas after onevm snapshot operations. Fix quotas in onedb fsck. <https://github.com/OpenNebula/one/issues/5867>`__.
- `Fix KVM nic-attach errror <https://github.com/OpenNebula/one/issues/5268>`__.
- `Fix HCI provisions to conform new version of Ceph ansible module <https://github.com/OpenNebula/one/issues/5876>`__.
- `Fix error to create Marketplace App from VM Template with volatile disks <https://github.com/OpenNebula/one/issues/5887>`__.
- `Fix error when use the externalToken with an expired JWT <https://github.com/OpenNebula/one/issues/5889>`__.
- `Fix error of zombie VMs due to wrong VNC port assignment <https://github.com/OpenNebula/one/issues/5834>`__.
- `Fix issues with OneProvision card images <https://github.com/OpenNebula/one/issues/5780>`__.
- `Fix issues with OneProvision logs <https://github.com/OpenNebula/one/issues/5780>`__.