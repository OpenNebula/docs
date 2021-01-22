.. _fireedge_sunstone:

================================================================================
Fireedge for Sunstone
================================================================================

What Is?
========

OpenNebula Fireedge provides some benefits to Sunstone:

- **Remote access your VM** using Guacamole and/or VMRC, `VMware Remote Console`.

- **Constant communication** with OpenNebula's ZeroMQ server, to enable autorefresh in Sunstone for resources states.

Fireedge uses `Apache Guacamole <guacamole.apache.org>`_, a free and open source web
application which lets you access your dashboard from anywhere using a modern web browser.
It is a **clientless remote desktop gateway** which only requires Guacamole installed on a
server and a web browser supporting HTML5.

Guacamole supports multiple connection methods such as **VNC, RDP and ssh**.

Guacamole system is made up of two separate parts: **server and client**.

Guacamole server consists of the native server-side libraries required to connect to the
server and the **guacd** tool. Its **the Guacamole proxy daemon** which accepts the user’s
connections and connects to the remote desktop on their behalf.

.. note::
  The OpenNebula **binary packages** will configure Guacamole  server and client
  automatically, therefore you don’t need to take any extra steps.

Fireedge server acts like a **VMRC proxy** between Sunstone and ESX nodes through web socket.
You can read :ref:`more information <vmrc_sunstone>` about it configuration.

.. _fireedge_sunstone_configuration:

Configuration
==============

-------------------------------------------------------------------------------
Configuring Sunstone for Guacamole
-------------------------------------------------------------------------------

To configure the Fireedge server on Sunstone when they are **on different servers**, you will need
to set public and private Fireedge server **endpoints** on :ref:`sunstone-server.conf <sunstone_sunstone_server_conf>`:

If they are on the **same server**, you can **skip this step**.

Also, if Fireedge is on another server, you must manually copy the file ``fireedge_key`` on
``/var/lib/one/.one`` since this file contains the cipher key for guacamole connections.

.. note::
  If you are building from source and using a self-contained installation you must copy the file ``fireedge_key`` on ``<self-contained folder>/var/.one/``

-------------------------------------------------------------------------------
Configuring Fireedge for Guacamole
-------------------------------------------------------------------------------

Moreover, Fireedge server has the following options on :ref:`fireege-server.conf <fireedge_install_configuration>`:

+---------------------------+--------------------------------+---------------------------------------------------------------+
|          Option           | Default Value                  | Description                                                   |
+===========================+================================+===============================================================+
| :guacd/port               | `4822`                         | Port on which the guacd server will listen                    |
+---------------------------+--------------------------------+---------------------------------------------------------------+
| :guacd/host               | `127.0.0.1`                    | Hostname on which the guacd server will listen                |
+---------------------------+--------------------------------+---------------------------------------------------------------+

Usage
=====

Sunstone users can use theses features by following:

- Guacamole
  :ref:`VNC <requirements_guacamole_vnc_sunstone>`,
  :ref:`RDP <requirements_guacamole_rdp_sunstone>`,
  :ref:`ssh <requirements_guacamole_ssh_sunstone>` and
  :ref:`VMRC <vmrc_sunstone>`

- Constant communication with :ref:`autorefresh <autorefresh>`
