.. _ruby_sunstone_vm_console:

================================================================================
Accessing VM Console and Desktop
================================================================================

Sunstone provides several different methods to access your VM console and desktop: VNC, SPICE, RDP, VMRC, SSH, and ``virt-viewer``. If configured in the VM, these methods can be used to access the VM console through Sunstone.  For some of those connections, we will need to start a new FireEdge server to establish the remote connection. This section shows how these different technologies can be configured and what each requirement is.

:ref:`FireEdge <fireedge_configuration>` automatically installs dependencies for Guacamole connectinos and VMRC proxy, which are necessary to use VNC, RDP, SSH, and VMRC.

+-----------------+-------------------+---------------------+
|   Connection    |   With FireEdge   |  Without FireEdge   |
+=================+===================+=====================+
| VNC             | Guacamole         | noVNC               |
+-----------------+-------------------+---------------------+
| RDP             | Guacamole         | noVNC               |
+-----------------+-------------------+---------------------+
| SSH             | Guacamole         | N/A                 |
+-----------------+-------------------+---------------------+
| SPICE           | noVNC             | noVNC               |
+-----------------+-------------------+---------------------+
| ``virt-viewer`` | noVNC             | noVNC               |
+-----------------+-------------------+---------------------+
| VMRC            | VMRC proxy        | N/A                 |
+-----------------+-------------------+---------------------+

.. important::

    :ref:`FireEdge <fireedge_conf>` server must be running to get Guacamole connections working. For VMRC, Sunstone and FireEdge must be running on the **same server**.

.. _ruby_sunstone_requirements_remote_access:

Requirements for connections via noVNC
--------------------------------------

The Sunstone GUI offers the possibility of starting a VNC/SPICE session to a Virtual
Machine. This is done by using a **VNC/SPICE websocket-based client (noVNC)** on the client side and
a VNC proxy translating and redirecting the connections on the server side.

To enable VNC/SPICE console service, you must have a ``GRAPHICS`` section in the VM template, as
stated in the documentation. Make sure the attribute ``IP`` is set correctly (``0.0.0.0`` to allow
connections from everywhere), otherwise no connections will be allowed from the outside.

For example, to configure this in the Virtual Machine template:

.. code-block:: none

    GRAPHICS=[
        LISTEN="0.0.0.0",
        TYPE="vnc"
    ]

Make sure there are no firewalls blocking the connections and websockets enabled in your browser.
**The proxy will redirect the websocket** data from the VNC proxy port to the VNC port stated in
the template of the VM. The value of the proxy port is defined in ``sunstone-server.conf`` as
``:vnc_proxy_port``.

You can retrieve useful information from ``/var/log/one/novnc.log``. **Your browser must support
websockets**, and have them enabled.

When using secure websockets, make sure that your certificate and key (if not included in the
certificate) are correctly set in the :ref:`Sunstone configuration files <sunstone_setup>`.
Note that your certificate must be valid and trusted for the wss connection to work.

If you are working with a certificate that is not accepted by the browser, you can manually add
it to the browser trust list by visiting ``https://sunstone.server.address:vnc_proxy_port``.
The browser will warn that the certificate is not secure and prompt you to manually trust it.

.. _vnc_ruby_sunstone:

Configuring your VM for VNC
---------------------------

VNC is a graphical console with wide support among many hypervisors and clients.

VNC without FireEdge
""""""""""""""""""""

When clicking the VNC icon a request is made, and if a VNC session is possible, the Sunstone server will add the VM
Host to the list of allowed vnc session targets and create a **random token** associated with it. The
server responds with the session token, then a ``noVNC`` dialog pops up.

The VNC console embedded in this dialog will try to connect to the proxy, either using websockets
(default) or emulating them using Flash. Only connections providing the right token will be successful.
The token expires and cannot be reused.

Make sure that you can connect directly from the Sunstone Front-end to the VM using a normal VNC
client tool, such as ``vncviewer``.

.. _requirements_guacamole_vnc_ruby_sunstone:

VNC with FireEdge
"""""""""""""""""

To enable the VNC console service you must have a ``GRAPHICS`` section in the VM template,
as stated in the documentation.

To configure it via Sunstone, you need to update the VM template. In the Input/Output tab,
you can see the graphics section where you can add the IP, the port, a connection password
or define your keymap.

|ruby_sunstone_guac_vnc|

To configure this in Virtual Machine template in **advanced mode**:

.. code-block:: none

    GRAPHICS=[
        LISTEN="0.0.0.0",
        TYPE="vnc"
    ]

.. note:: Make sure the attribute ``IP`` is set correctly (``0.0.0.0`` to allow connections
    from everywhere), otherwise, no connections will be allowed from the outside.

.. _rdp_ruby_sunstone:

Configure VM for RDP
--------------------

Short for **Remote Desktop Protocol**, it allows one computer to connect to another computer
over a network in order to use it remotely.

RDP without FireEdge
""""""""""""""""""""

RDP connections are available on Sunstone using noVNC. You will only have to download the
RDP file and open it with an RDP client to establish a connection with your Virtual Machine.

.. _requirements_guacamole_rdp_ruby_sunstone:

RDP with FireEdge
"""""""""""""""""

To enable RDP connections to the VM, you must have one ``NIC``
with ``RDP`` attribute equal to ``YES`` in the template.

Via Sunstone, you need to enable a RDP connection on one of the VM template networks, **after or
before its instantiation**.

|sunstone_guac_nic|

To configure this in Virtual Machine template in **advanced mode**:

.. code-block:: none

    NIC=[
        ...
        RDP = "YES"
    ]

Once the VM is instantiated, users will be able to download the **file configuration or
connect via browser**.

|ruby_sunstone_guac_rdp|

RDP connection permits to **choose the screen resolution** from Sunstone interface.

|sunstone_guac_rdp_interface|

.. important:: **The RDP connection is only allowed to activate on a single NIC**. In any
    case, the connection will only contain the IP of the first NIC with this property enabled.
    The RDP connection will work the **same way for NIC ALIASES**.

If the VM template has a ``PASSWORD`` and ``USERNAME`` set in the contextualization section, this will be reflected in the RDP connection. You can read about them in the :ref:`Virtual Machine Definition File reference section <template_context>`.

.. note:: If your Windows VM has a firewall enabled, you can set the following in the start script of the VM (in the Context section of the VM Template):

    ```
    netsh advfirewall firewall set rule group="Remotedesktop" new enable=yes
    ```

.. _requirements_guacamole_ssh_ruby_sunstone:

Configure VM for SSH
--------------------

**SSH connections are available only when a reachable Firedge server is found**. Unlike VNC or RDP,
SSH is a text protocol. SSH connections require a hostname or IP address defining
the destination machine. Like with the :ref:`RDP <requirements_guacamole_rdp_ruby_sunstone>` connections,
you need to enable the SSH connection on one of the VM template networks.

For example, to configure this in the Virtual Machine template in **advanced mode**:

.. code-block:: none

    NIC=[
        ...
        SSH = "YES"
    ]

SSH is standardized to use port 22 and this will be the proper value in most cases. You only
need to specify the **SSH port in the contextualization section as** ``SSH_PORT`` if you are
not using the standard port.

.. note:: If the VM template has a ``PASSWORD`` and ``USERNAME`` set in the contextualization
	section, this will be reflected in the SSH connection. You can read about them in the
	:ref:`Virtual Machine Definition File reference section <template_context>`.

For example, to allow connection by username and password to a guest VM, first make sure you
have SSH root access to the VM, check more info :ref:`here <cloudview_ssh_keys>`.

After that you can access the VM and configure the SSH service:

.. code-block:: bash

    oneadmin@frontend:~$ ssh root@<guest-vm>

    # Allow authentication with password: PasswordAuthentication yes
    root@<guest-VM>:~$ vi /etc/ssh/sshd_config

    # Restart SSH service
    root@<guest-VM>:~$ service sshd restart

    # Add user: username/password
    root@<guest-VM>:~$ adduser <username>

.. note:: Guacamole SSH uses RSA encryption. Make sure the VM SSH accepts RSA, otherwise you need to explicitly enable it in the VM SSH configuration (HostkeyAlgorithms and PubkeyAcceptedAlgorithms set as '+ssha-rsa)

.. _spice_ruby_sunstone:

Configure VM for SPICE
----------------------

SPICE connections are channeled only through the noVNC proxy. SPICE support in Sunstone share
a similar architecture to the VNC implementation. Sunstone use a **SPICE-HTML5** widget in
its console dialog that communicates with the proxy by using websockets.

.. important:: SPICE connections when using NAT and remote-viewer won't work since noVNC proxy
    does not offer SPICE support, and a direct connection between browser and virtualization node
    is needed. However the SPICE HTML5 console can use noVNC proxy to offer SPICE connectivity,
    please use this option as an alternative

.. note:: For the correct functioning of the SPICE Web Client, we recommend defining by default
    the SPICE parameters in ``/etc/one/vmm_mad/vmm_exec_kvm.conf``. In this way, once the file is modified and OpenNebula is restarted, it will be applied to all  the VMs instantiated from now on. You can also override these SPICE parameters in VM Template. For more info check :ref:`Driver Defaults
    <kvmg_default_attributes>` section.

.. _virt_viewer_ruby_sunstone:

Configure VM for virt-viewer
----------------------------

``virt-viewer`` connections are channeled only through the noVNC proxy. virt-viewer is a minimal tool
for displaying the graphical console of a virtual machine. It can **display VNC or SPICE protocol**,
and uses libvirt to look up the graphical connection details.

In this case, Sunstone allows you to download the **virt-viewer configuration file** for the VNC and
SPICE protocols. The only requirement is the ``virt-viewer`` being installed on the machine from which you are accessing the Sunstone.

To use this option, you will only have to enable any of two protocols in the VM. Once the VM is
``instantiated`` and ``running``, users will be able to download the ``virt-viewer`` file.

|sunstone_virt_viewer_button|

.. _vmrc_ruby_sunstone:

Configure VM for VMRC
---------------------

.. important:: VMRC connections are available only when a reachable FireEdge server is found.

*VMware Remote Console* provides console access and client device connection to VMs on a remote host.

These types of connections request a ``TOKEN`` from vCenter to connect with the Virtual Machine
allocated on vCenter every time you click on the VMRC button.

To use this option, you will only have to enable VNC / VMRC connections to your VMs and start the
FireEdge Server.

.. note:: To change the keyboard distribution in the VMRC connection, you need to change the
    keyboard layout in the running operating system.

|sunstone_vmrc|

.. |image1| image:: /images/vm_charter.png
.. |sunstone_virt_viewer_button| image:: /images/sunstone_virt_viewer_button.png
.. |sunstone_rdp_connection| image:: /images/sunstone_rdp_connection.png
.. |sunstone_rdp_button| image:: /images/sunstone_rdp_button.png
.. |ruby_sunstone_guac_vnc| image:: /images/ruby_sunstone_guac_vnc.png
.. |ruby_sunstone_guac_rdp| image:: /images/ruby_sunstone_guac_rdp.png
.. |sunstone_guac_rdp_interface| image:: /images/sunstone_guac_rdp_interface.png
.. |sunstone_guac_nic| image:: /images/sunstone_guac_nic.png
.. |sunstone_vmrc| image:: /images/sunstone_vmrc.png
.. |sunstone_sg_main_view| image:: /images/sunstone_sg_main_view.png
.. |sunstone_sg_attach| image:: /images/sunstone_sg_attach.png
