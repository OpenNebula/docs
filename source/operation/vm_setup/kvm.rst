.. _kvm_contextualization:

=====================
KVM Contextualization
=====================

Prepare the Virtual Machine Image
=================================

Step 1. Start a VM with the OS you want to Customize
----------------------------------------------------

Supported contextualization packages are available for the following OS's:

* **CentOS/RHEL** >= 6
* **Debian** >= 6
* **Ubuntu** >= 11.10
* **Windows** >= 7
* **Windows Server** >= 2008

Step 2. Download Contextualization Packages to the VM
-----------------------------------------------------

CentOS/RHEL
~~~~~~~~~~~

.. prompt:: bash # auto

    # wget https://github.com/OpenNebula/addon-context-linux/releases/download/v4.14.4/one-context-ec2_4.14.4.rpm

Debian/Ubuntu
~~~~~~~~~~~~~

.. prompt:: bash # auto

    # wget https://github.com/OpenNebula/addon-context-linux/releases/download/v4.14.4/one-context_4.14.4.deb

Windows
~~~~~~~

Downloads these two files to ``C:\``:

* https://raw.githubusercontent.com/OpenNebula/addon-context-windows/master/context.ps1
* https://raw.githubusercontent.com/OpenNebula/addon-context-windows/master/startup.vbs

Step 3. Install Contextualization Packages and Dependencies
-----------------------------------------------------------

CentOS/RHEL 6
~~~~~~~~~~~~~

.. prompt:: bash # auto

    # rpm -Uvh one-context*rpm
    # yum install -y epel-release
    # yum install ruby # only needed for onegate command
    # yum install -i dracut-modules-growroot
    # dracut -f

CentOS/RHEL 7
~~~~~~~~~~~~~

.. prompt:: bash # auto

    # rpm -Uvh one-context*rpm
    # yum install -y epel-release
    # yum install ruby # only needed for onegate command
    # yum install -y cloud-utils-growpart

Debian/Ubuntu
~~~~~~~~~~~~~

.. prompt:: bash # auto

    # dpkg -i one-context*deb
    # apt-get install ruby # only needed for onegate command
    # apt-get install -y cloud-utils

Windows
~~~~~~~

* Open the Local Group Policy Dialog by running ``gpedit.msc``.
* Go to *Computer Configuration* -> *Windows Settings* -> *Scripts* -> *startup* (right click).
* Browse to the ``startup.vbs`` file and enable it as a startup script.

Step 4. Power Off the Machine and Save it
-----------------------------------------

After these configuration is done you should power off the machine, so it is in a consistent state the next time it boots. Then you will have to save the image.

If you are using OpenNebula to prepare the image you can use the command ``onevm disk-saveas``, for example, to save the first disk of a Virtual Machine called "centos-installation" into an image called "centos-contextualized" you can issue this command:

.. prompt:: bash $ auto

    $ onevm disk-saveas centos-installation 0 centos-contextualized

Using sunstone web interface you can find the option in the Virtual Machine storage tab.


Set Up the Virtual Machine Template
===================================

The Virtual Machine Template has a section called context where you can automate different configuration aspects. The most common attributes are network configuration, user credentials and startup scripts. This parameters can be both added using the CLI to the template or using Sunstone Template wizard. Here is an example of the context section using the CLI:

.. code-block:: bash

    CONTEXT = [
        NETWORK = "YES",
        SSH_PUBLIC_KEY = "$USER[SSH_PUBLIC_KEY]",
        START_SCRIPT = "yum install -y ntpdate"
    ]

In the example we are telling OpenNebula to:

* Add network configuration to the Virtual Machine
* Enable login into the Virtual Machine using ssh with the value of the user's parameter ``SSH_PUBLIC_KEY``
* On Virtual Machine boot execute the command ``yum install -y ntpdate``

Network Configuration
---------------------

OpenNebula does not rely on a DHCP server to configure networking in the Virtual Machines. To do this configuration it injects the network information in the contextualization section. This is done with option ``NETWORK = "YES"``. When OpenNebula finds this option it adds the IP information for each of the network interfaces configured plus extra information that resides in the Virtual Network template, like DNS, gateway and network mask.

The parameters used from the Virtual Network template are explained in the :ref:`Managing Virtual Networks section <manage_vnets>`.


User Credentials
----------------

One of the other very important things you have to configure is user credentials to connect to the newly created Virtual Machine. For linux base images we recommend to use SSH public key authentication and using it with OpenNebula is very convenient.

The first thing the users should do its to add their SSH public key (or keys) to its OpenNebula user configuration. This can be done in the Settings section of the web interface or using the command line interface:

.. prompt:: bash $ auto

    $ oneuser update myusername
    # an editor is opened, add this line
    SSH_PUBLIC_KEY="ssh-rsa MYPUBLICKEY..."

Then in the Virtual Machine Template we add the option:

.. code-block:: bash

    CONTEXT = [
        SSH_PUBLIC_KEY = "$USER[SSH_PUBLIC_KEY]"
    ]

Using this system the new Virtual Machines will be configured with the SSH public key of the user that instantiated it.

For Windows machines SSH is not available but you can use the options ``USERNAME`` and ``PASSWORD`` to create and set the password of an initial administrator.

.. code-block:: bash

    CONTEXT = [
        USERNAME = "Administrator",
        PASSWORD = "VeryComplexPassw0rd"
    ]


Execute Scripts on Boot
-----------------------

To be able to execute commands on boot, for example, to install some software, you can use the option ``START_SCRIPT``. When this option is used a new file that contains the value of the option will be created and executed.

For Windows machines this is a PowerShell script. For linux machines this can be any scripting language as long as it is installed in the base image and the proper shebang line is set (shell scripts don't need shebang).

In this example some commands will be executed using ``bash`` shell that will install the package ``ntpdate`` and set the time.

.. code-block:: bash

    CONTEXT = [
        START_SCRIPT = "#!/bin/bash
    yum update
    yum install -y ntpdate
    ntpdate 2.es.pool.ntp.org"
    ]

To add more complex scripts you can also use the option ``START_SCRIPT_BASE64``. This option gets a base64 encoded string that will be decoded before writing the temporary script file.


Advanced Contextualization
--------------------------

There are more options that can be set in the contextualization section. You can read about them in the :ref:`Virtual Machine Definition File reference section <template_context>`

