.. _kvm_contextualization:

================================================================================
Open Cloud Contextualization
================================================================================

OpenNebula provides a set of contextualization packages for different operating systems that integrates the VM guests with the OpenNebula services. The OpenNebula contextualization process allows to automatically:

* Configure guest networking and hostname settings.
* Set up user credentials for seamless VM access.
* Define the system timezone.
* Resize disk partitions as needed.
* Execute custom actions during boot.

All the OS appliances available in the `OpenNebula Marketplace <https://marketplace.opennebula.io/appliance>`_ comes already with all the software installed. If you want to build these images yourself take a look at the `OpenNebula Apps project <https://github.com/OpenNebula/one-apps>`_.

Additionally you can install the packages manually in any running VM guest, just grab the `latest version of the context packages for your OS system <https://github.com/OpenNebula/one-apps/releases>`_ and install them (don't forget to save your changes to the VM disk!).

Using the Context Packages
==========================

Configuration parameters are passed to the contextualization packages through the ``CONTEXT`` attribute of the virtual machine. The most common attributes are network configuration, user credentials and startup scripts. These parameters can be both added using the CLI to the template or using Sunstone Template wizard. Here is an example of the context section using the CLI:

.. code-block:: bash

    CONTEXT = [
        TOKEN = "YES",
        NETWORK = "YES",
        SSH_PUBLIC_KEY = "$USER[SSH_PUBLIC_KEY]",
        START_SCRIPT = "yum install -y ntpdate"
    ]

In the following links you can learn more details on how to:

* `Network configuration <https://github.com/OpenNebula/one-apps/wiki/linux_feature#network-configuration>`_.
* `Setup user credentials <https://github.com/OpenNebula/one-apps/wiki/linux_feature#user-credentials>`_.
* `Execute scripts on boot <https://github.com/OpenNebula/one-apps/wiki/linux_feature#execute-scripts-on-boot>`_.
* `Filesystem tunning <https://github.com/OpenNebula/one-apps/wiki/linux_feature#file-system-configuration>`_.
* `Other OS settings and OneGate <https://github.com/OpenNebula/one-apps/wiki/linux_feature#other-system-configuration>`_.

Contextualization Reference
===========================

The full list of options and attributes in the contextualization section are described in the :ref:`Virtual Machine Definition File reference section <template_context>`

