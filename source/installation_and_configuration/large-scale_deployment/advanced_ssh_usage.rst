.. _node_ssh:

==================
Advanced SSH Usage
==================

This guide covers advanced SSH configuration for OpenNebula nodes, specifically:

* integrated OpenNebula SSH :ref:`Authentication Agent <node_ssh_agent>`
* :ref:`SSH client configuration <node_ssh_config>`
* gathering of :ref:`host SSH public keys <node_ssh_known_hosts>`

.. note:: This section extends the `Configure Passwordless SSH` step within the Node installation guides with advanced SSH configuration and usage.

.. _node_ssh_agent:

Authentication Agent
=====================

OpenNebula's integrated **SSH Authentication Agent** service is automatically started on the Front-end by implicit dependencies of OpenNebula. During startup, it imports the default SSH private keys of ``oneadmin`` user from the directory ``/var/lib/one/.ssh/`` on the Front-end, and securely delegates them to the hypervisor Nodes for the OpenNebula driver operations which need to make connections between the Hosts or back to the Front-end. Authentication Agent must be started before or with OpenNebula.

.. important::

    OpenNebula's SSH Authentication Agent service is started and used by default, but **it's not mandatory**. It can be disabled if cross host connections are enabled by any other method (e.g., by distributing private keys on all Hosts or if you already use your own authentication agent).

Service Management
------------------

SSH Authentication Agent is managed by the service ``opennebula-ssh-agent.service`` running on your Front-end. You can use common service management commands of your operating system to control the service state.

To stop, start, or restart the service use the following commands:

.. prompt:: bash # auto

    # systemctl stop    opennebula-ssh-agent.service
    # systemctl start   opennebula-ssh-agent.service
    # systemctl restart opennebula-ssh-agent.service

.. important::

   OpenNebula only uses the dedicated SSH Authentication Agent if it's running (manually or automatically via service manager by implicit dependencies) when OpenNebula starts up. If the agent service is started after OpenNebula you'll need to **restart OpenNebula service** itself to force OpenNebula to use the SSH Authentication Agent.

The SSH Authentication Agent service doesn't need to be enabled to start when your Front-end server boots up. It's started automatically by the OpenNebula service as an implicit dependency. To **avoid automatic starting and using** the SSH Authentication Agent service at all, you must mask the service in the following way:

.. prompt:: bash # auto

    # systemctl mask opennebula-ssh-agent.service

Add Custom Keys
---------------

Default SSH keys for ``oneadmin`` located in ``/var/lib/one/.ssh`` are automatically loaded when SSH Authentication Agent service starts. Check the manual page of ``ssh-add`` (``man 1 ssh-add``) to a see complete list of preloaded files on your platform.

To include any additional keys from non-standard locations or to add keys interactively (e.g, if the key is encrypted on the filesystem), first ensure the agent service is running, set the environment variable ``SSH_AUTH_SOCK`` with a path to agent socket to ``/var/run/one/ssh-agent.sock`` and use the ``ssh-add`` command with a path to your custom key as an argument. For example:

.. prompt:: bash $ auto

    $ SSH_AUTH_SOCK=/var/run/one/ssh-agent.sock ssh-add .ssh/id_rsa-encrypted

Verify the action by listing all imported keys:

.. prompt:: bash $ auto

    $ SSH_AUTH_SOCK=/var/run/one/ssh-agent.sock ssh-add -l

The custom imported keys are kept only in memory. They must be **imported again** every time SSH Authentication Agent starts or restarts, or when the Front-end server restarts!

.. _node_ssh_config:

SSH Client Configuration
========================

Initial **default SSH client configuration** files are provided in ``/usr/share/one/ssh/``. Depending on your platform the suitable configuration is copied for ``oneadmin`` into ``/var/lib/one/.ssh/config`` for all types of hosts (Front-End or hypervisor Nodes) during installation. Check the content of ``/var/lib/one/.ssh/config`` to know if you are using the initial default version shipped by OpenNebula.

This default SSH configuration ensures that host SSH keys of new remote Hosts are accepted on the very first connection and strictly checked during subsequent connections (you don't need to populate SSH host keys into ``/var/lib/one/.ssh/known_hosts`` in advance for new Hosts). Also, it configures short-term connection sharing and persistency to speed up driver operations. Persistency is selectively enabled within OpenNebula drivers and **must not be enabled globally**.

.. important::

    The default SSH client configuration for ``oneadmin`` is provided only during installation of a fresh package and is not updated anytime later, even during a packages upgrade. You can always find the most recent default configurations in ``/usr/share/one/ssh``.

The following SSH configuration snippets introduce various ways how to configure the SSH clients by putting suitable parts into ``/var/lib/one/.ssh/config`` on your machines. You need to merge the content of the snippets into a single matching section appropriately because, in the case of multiple ``Host *`` sections in the single configuration file, only the first one is effective!

.. _node_ssh_config_persist:

Persistent Connections
----------------------

OpenSSH allows us to reuse a single SSH connection by multiple sessions (commands) running against the same host in parallel, and to keep the connection open for further commands. Reusing an already opened session saves time in managaging new TCP connections and speeds up the driver operations. This provides a boost, especially with high latency (or distant) remotes.

.. prompt:: bash $ auto

   Host *
      ControlMaster auto
      ControlPath /var/lib/one/ctrl-M-%C.sock
      ControlPersist 0

.. warning::

   You can enable this configuration only on the Front-end, **not on hypervisor Nodes!** This configuration can't be used on a host that serves both as Front-end and hypervisor!

.. important::

   Due to a problem with `control socket cleanup <https://bugzilla.mindrot.org/show_bug.cgi?id=3067>`_ in specific OpenSSH versions, when ``ControlPersist`` is configured to remain open for a limited time, the OpenNebula driver operations might randomly fail if the operation coincides with the connection being closed. If connections with unlimited time persistency (``ControlPersist 0``) are not possible due to a large infrastructure, it's recommended to handle the closing of persistent connections on your own or use long enough persistence times to lower the chance of experiencing the problem.

.. _node_ssh_config_accept:

Automatically Accept New SSH Host Keys
--------------------------------------

When provisioning new hosts, one of the steps to configure the passwordless logins is to gather the list of host SSH public keys of all communicating parties and its distribution on them. By default, the OpenSSH requires user interaction to manually accept keys of new hosts but can be configured to accept them automatically. While this decreases the security of your deployment by automatic acceptance of host keys during the very first connection, it still refuses to open further connections on the hosts that change keys (e.g., in case of MITM attack) and provides a compromise between security and usability.

.. warning::

   This configuration can be used only with OpenSSH 7.6 and newer!

.. prompt:: bash $ auto

    Host *
        StrictHostKeyChecking accept-new

.. _node_ssh_config_ignore:

Disable SSH Host Keys Checking
------------------------------

.. warning::

   This configuration is mentioned only for information but is **NOT RECOMMENDED** for general use.

The following configuration completely disables storing and checking the identity of the remote hosts you are connecting to over SSH. You can use the configuration if you don't need or want to manage the list of host SSH keys in ``known_hosts`` at all. **It introduces a major security issue and shouldn't be used.**

.. prompt:: bash $ auto

    Host *
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null

.. _node_ssh_known_hosts:

Populate Host Keys
==================

Unless the infrastructure hosts are configured not to :ref:`check host SSH keys <node_ssh_config_ignore>` of communicating parties (which is not recommended), it's crucial to populate the host keys of each host into the ``known_hosts`` file in a secure manner. The configuration management system can help with creating such a file to a certain extent, as it has insight into the configuration of your hosts and might leverage a different way to access the host than over SSH.

Manual Secure Add
-----------------

We'll demonstrate how to easily and securely add the identity of the remote host into the ``known_hosts`` file on the Front-end. The output of the commands is provided only for demonstration.

On your **new** hypervisor Node:

- login safely to the privileged user (directly or via management/serial console)
- print hashes of host public SSH keys by running

.. prompt:: bash # auto

    # for K in /etc/ssh/ssh_host_*_key; do ssh-keygen -l -E sha256 -f "$K"; done
    256 SHA256:O+j/qjUq63x56RxHCYjU970SgN3f9fFcCVOdqqRWpa8 /etc/ssh/ssh_host_ecdsa_key.pub (ECDSA)
    256 SHA256:BF5hcFsC5XaReuOMyhKqjTjs+72igCTk2kHvAOZ4Kvg /etc/ssh/ssh_host_ed25519_key.pub (ED25519)
    2048 SHA256:LBk5+dJ4cEdYPHz/ia1hyAvNBs5ZrIMbIpESgSWYgqU /etc/ssh/ssh_host_rsa_key.pub (RSA)

On your Front-end:

- try to SSH into this new node by running

.. prompt:: bash $ auto

    $ ssh -o FingerprintHash=sha256 <node4>
    The authenticity of host 'node4 (10.0.0.2)' can't be established.
    ECDSA key fingerprint is SHA256:O+j/qjUq63x56RxHCYjU970SgN3f9fFcCVOdqqRWpa8.
    Are you sure you want to continue connecting (yes/no/[fingerprint])?

- validate that the obtained fingerprint matches one of those gathered on the Host
- if hash matches, type ``yes`` and new host keys will be added into ``known_hosts``
- in case the hash doesn't match any of the expected results, you aren't connecting the machine you expect and you should further investigate the problem as you might be a victim of `man-in-the-middle attack <https://en.wikipedia.org/wiki/Man-in-the-middle_attack>`_ attack
- distribute the update ``known_hosts`` to all your Hosts
