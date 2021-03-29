.. _ansible:

================================================================================
Ansible
================================================================================

OpenNebula Ansible modules allow managing common OpenNebula resources, e.g. VMs, images or hosts, using Ansible playbooks. In the latest Ansible version OpenNebula modules are part of the collection `community.general <https://galaxy.ansible.com/community/general>`__. Formerly, they were distributed together with Ansible main package.

For the module usage, please follow the official Ansible documentation:

    * `one_host.py <https://docs.ansible.com/ansible/latest/collections/community/general/one_host_module.html>`__
    * `one_image.py <https://docs.ansible.com/ansible/latest/collections/community/general/one_image_module.html>`__
    * `one_service.py <https://docs.ansible.com/ansible/latest/collections/community/general/one_service_module.html>`__
    * `one_vm.py <https://docs.ansible.com/ansible/latest/collections/community/general/one_vm_module.html>`__
    * one_template.py -- `not released yet <https://github.com/ansible-collections/community.general/blob/main/plugins/modules/cloud/opennebula/one_template.py>`__

Dependencies
================================================================================
For OpenNebula Ansible modules :ref:`Python bindings PYONE <python>` are necessary, for ``one_image.py`` also legacy `Python OCA <https://github.com/python-oca/python-oca>`__

