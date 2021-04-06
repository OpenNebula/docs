.. _cli:

======================
Command Line Interface
======================

OpenNebula provides a set commands to interact with the system:

CLI
================================================================================

* `oneacct </doc/6.1/cli/oneacct.1.html>`__: gets accounting data from OpenNebula.
* `oneacl </doc/6.1/cli/oneacl.1.html>`__: manages OpenNebula ACLs.
* `onecfg </doc/6.1/cli/onecfg.1.html>`__: manages OpenNebula configuration files upgrade.
* `onecluster </doc/6.1/cli/onecluster.1.html>`__: manages OpenNebula clusters.
* `onedatastore </doc/6.1/cli/onedatastore.1.html>`__: manages OpenNebula datastores.
* `onedb </doc/6.1/cli/onedb.1.html>`__: OpenNebula database migration tool.
* `onegroup </doc/6.1/cli/onegroup.1.html>`__: manages OpenNebula groups.
* `onehook </doc/6.1/cli/onehook.1.html>`__: manages OpenNebula hooks.
* `onehost </doc/6.1/cli/onehost.1.html>`__: manages OpenNebula hosts.
* `oneimage </doc/6.1/cli/oneimage.1.html>`__: manages OpenNebula images.
* `onemarket </doc/6.1/cli/onemarket.1.html>`__: manages internal and external marketplaces.
* `onemarketapp </doc/6.1/cli/onemarketapp.1.html>`__: manages appliances from marketplaces.
* `oneprovider </doc/6.1/cli/oneprovider.1.html>`__: mnanages OpenNebula providers.
* `oneprovision </doc/6.1/cli/oneprovision.1.html>`__: mnanages OpenNebula provisions.
* `onesecgroup </doc/6.1/cli/onesecgroup.1.html>`__: manages OpenNebula security groups.
* `oneshowback </doc/6.1/cli/oneshowback.1.html>`__: OpenNebula Showback tool.
* `onetemplate </doc/6.1/cli/onetemplate.1.html>`__: manages OpenNebula templates.
* `oneuser </doc/6.1/cli/oneuser.1.html>`__: manages OpenNebula users.
* `onevcenter </doc/6.1/cli/onevcenter.1.html>`__: handles vCenter resource import.
* `onevdc </doc/6.1/cli/onevdc.1.html>`__: manages OpenNebula Virtual DataCenters.
* `onevm </doc/6.1/cli/onevm.1.html>`__: manages OpenNebula virtual machines.
* `onevmgroup </doc/6.1/cli/onevmgroup.1.html>`__: manages OpenNebula VMGroups.
* `onevnet </doc/6.1/cli/onevnet.1.html>`__: manages OpenNebula networks.
* `onevntemplate </doc/6.1/cli/onevntemplate.1.html>`__: manages OpenNebula networks templates.
* `onevrouter </doc/6.1/cli/onevrouter.1.html>`__: manages OpenNebula Virtual Routers.
* `onezone </doc/6.1/cli/onezone.1.html>`__: manages OpenNebula zones.

The output of these commands can be customized by modifying the configuration files that can be found in ``/etc/one/cli/``. They also can be customized on a per-user basis, in this case the configuration files should be placed in ``$HOME/.one/cli``.

List operation for each command will open a ``less`` session for a better user experience. First elements will be printed right away while the rest will begin to be requested and added to a cache, providing faster response times, specially on big deployments. Less session will automatically be canceled if a pipe is used for better interaction with scripts, providing the traditional, non interactive output.

OneFlow Commands
================================================================================

* `oneflow </doc/6.1/cli/oneflow.1.html>`__: OneFlow Service management.
* `oneflow-template </doc/6.1/cli/oneflow-template.1.html>`__: OneFlow Service Template management.

OneGate Commands
================================================================================

* `onegate </doc/6.1/cli/oneflow.1.html>`__: OneGate Service management.

.. _cli_shell:

Shell Environment
================================================================================

OpenNebula users should have the following environment variables set, you may want to place them in the ``.bashrc`` of the user's Unix account for convenience:

* **ONE_XMLRPC**: URL where the OpenNebula daemon is listening. If it is not set, CLI tools will use the default: ``http://localhost:2633/RPC2``. See the ``PORT`` attribute in the :ref:`Daemon configuration file <oned_conf>` for more information.
* **ONE_XMLRPC_TIMEOUT**: number of seconds to wait before a xmlrpc request timeouts.
* **ONE_ZMQ**: URL to subscribe to receive ZMQ messages. If it is not set, CLI tools will use the default: ``tcp://localhost:2101``.
* **ONE_AUTH**: needs to point to **a file containing a valid authentication key**, it can be:

    * A password file with just a single line stating ``username:password``.
    * A token file with just a single line with ``username:token``, where token is a valid token created with the ``oneuser login`` command or API call.

If ``ONE_AUTH`` is not defined, ``$HOME/.one/one_auth`` will be used instead. If no auth file is present, OpenNebula cannot work properly, as this is needed by the core, the CLI, and the cloud components as well.

* **ONE_POOL_PAGE_SIZE**: by default the OpenNebula Cloud API (CLI and Sunstone make use of it) paginates some pool responses. By default this size is 300 but it can be changed with this variable. A numeric value greater that 2 is the pool size. To disable it you can use a non numeric value.

.. prompt:: bash $ auto

    $ export ONE_POOL_PAGE_SIZE=5000        # Sets the page size to 5000
    $ export ONE_POOL_PAGE_SIZE=disabled    # Disables pool pagination

* **ONE_PAGER**: list commands will send their output through a pager process when in an interactive shell. By default, the pager process is set to ``less`` but it can be change to any other program. The pagination can be disabled using the argument ``--no-pager``. It sets the ``ONE_PAGER`` variable to ``cat``.
* **ONE_LISTCONF**: allows the user to use an alternate layout to displays lists. The layouts are defined in ``/etc/one/cli/onevm.yaml``.

.. prompt:: bash $ auto

    $ onevm list
        ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
        20 oneadmin oneadmin tty-20          fail    0      0K localhost    0d 00h32
        21 oneadmin oneadmin tty-21          fail    0      0K localhost    0d 00h23
        22 oneadmin oneadmin tty-22          runn  0.0  104.7M localhost    0d 00h22

    $ export ONE_LISTCONF=user
    $ onevm list
        ID NAME            IP              STAT UCPU    UMEM HOST             TIME
        20 tty-20          10.3.4.20       fail    0      0K localhost    0d 00h32
        21 tty-21          10.3.4.21       fail    0      0K localhost    0d 00h23
        22 tty-22          10.3.4.22       runn  0.0  104.7M localhost    0d 00h23

* **ONE_CERT_DIR** and **ONE_DISABLE_SSL_VERIFY**: if OpenNebula XML-RPC endpoint is behind an SSL proxy you can specify an extra trusted certificates directory using ``ONE_CERT_DIR``. Make sure that the certificate is named ``<hash>.0``. You can get the hash of a certificate with this command:

.. prompt:: bash $ auto

    $ openssl x509 -in <certificate.pem> -hash

Alternatively you can set the environment variable ``ONE_DISABLE_SSL_VERIFY`` to any value to disable certificate validation. You should only use this parameter for testing as it makes the connection insecure.

For instance, a user named ``regularuser`` may have the following environment:

.. prompt:: bash $ auto

    $ tail ~/.bashrc

    ONE_XMLRPC=http://localhost:2633/RPC2

    export ONE_XMLRPC

    $ cat ~/.one/one_auth
    regularuser:password

.. note:: Please note that the example above is intended for a user interacting with OpenNebula from the front-end, but you can use it from any other computer. Just set the appropriate hostname and port in the ``ONE_XMLRPC`` variable.

.. note:: If you do not want passwords to be stored in plain files, protected with basic filesystem permissions, please refer to the token-based authentication mechanism described below.

An alternative method to specify credentials and OpenNebula endpoint is using command line parameters. Most of the commands can understand the following parameters:

+-------------------------+------------------------------------------+
| ``--user name``         | User name used to connect to OpenNebula  |
+-------------------------+------------------------------------------+
| ``--password password`` | Password to authenticate with OpenNebula |
+-------------------------+------------------------------------------+
| ``--endpoint endpoint`` | URL of OpenNebula XML-RPC Front-end      |
+-------------------------+------------------------------------------+

If ``user`` is specified but not ``password`` the user will be prompted for the password. ``endpoint`` has the same meaning and get the same value as ``ONE_XMLRPC``. For example:

.. prompt:: bash $ auto

    $ onevm list --user my_user --endpoint http://one.frontend.com:2633/RPC2
    Password:
    [...]

.. warning:: You should better not use ``--password`` parameter in a shared machine. Process parameters can be seen by any user with the command ``ps`` so it is highly insecure.

* **ONE_SUNSTONE**: URL of the Sunstone portal, used for downloading Marketplace Apps streamed through Sunstone. If this is not specified, it will be inferred from ``ONE_XMLRPC`` (by changing the port to 9869), and if that ENV variable is undefined as well, it will default to ``http://localhost:9869``.
* **ONEFLOW_URL**, **ONEFLOW_USER** and **ONEFLOW_PASSWORD**: these variables are used by the :ref:`OneFlow <oneflow_overview>` command line tools. If not set, the default OneFlow URL will be ``http://localhost:2474``. The user and password will be taken from the ``ONE_AUTH`` file if the environment variables are not found.

Shell Environment for Self-Contained Installations
--------------------------------------------------------------------------------

If OpenNebula was installed from sources in **self-contained mode** (this is not the default, and not recommended), these two variables must be also set. These are not needed if you installed from packages, or performed a system-wide installation from sources.

* **ONE_LOCATION**: it must point to the installation ``<destination_folder>``.
* **PATH**: the OpenNebula bin files must be added to the path:

.. prompt:: bash $ auto

    $ export PATH=$ONE_LOCATION/bin:$PATH
