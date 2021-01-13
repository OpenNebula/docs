.. _ssh_auth:

================================================================================
SSH Authentication
================================================================================

This guide will show you how to enable and use the SSH authentication for the OpenNebula CLI. Using this authentication method, users log in to OpenNebula with a token encrypted with their private SSH keys.

Requirements
============

You don't need to install any additional software.

Considerations & Limitations
============================

With the current release, this authentication method is only valid to interact with OpenNebula using the CLI.

Configuration
=============

OpenNebula Configuration
------------------------

The Auth MAD with ``ssh`` authentication is enabled by default. In case it does not work, make sure that the authentication method is in the list of enabled methods.

.. code-block:: bash

    AUTH_MAD = [
        executable = "one_auth_mad",
        authn = "ssh,x509,ldap,server_cipher,server_x509"
    ]

There is an external plain user/password authentication driver, and existing accounts will keep working as usual.

Usage
=====

Create New Users
----------------

This authentication method uses standard SSH RSA key pairs for authentication. Users can create these files **if they don't exist** using this command:

.. prompt:: bash $ auto

    $ ssh-keygen -t rsa

OpenNebula commands look for the files generated in the standard location (``$HOME/.ssh/id_rsa``), so it is a good idea not to change the default path. It is also a good idea to protect the private key with a password.

The users requesting a new account have to generate a public key and send it to the administrator. The way to extract it is the following:

.. prompt:: bash $ auto

    $ oneuser key
    Enter PEM pass phrase:
    MIIBCAKCAQEApUO+JISjSf02rFVtDr1yar/34EoUoVETx0n+RqWNav+5wi+gHiPp3e03AfEkXzjDYi8F
    voS4a4456f1OUQlQddfyPECn59OeX8Zu4DH3gp1VUuDeeE8WJWyAzdK5hg6F+RdyP1pT26mnyunZB8Xd
    bll8seoIAQiOS6tlVfA8FrtwLGmdEETfttS9ukyGxw5vdTplse/fcam+r9AXBR06zjc77x+DbRFbXcgI
    1XIdpVrjCFL0fdN53L0aU7kTE9VNEXRxK8sPv1Nfx+FQWpX/HtH8ICs5WREsZGmXPAO/IkrSpMVg5taS
    jie9JAQOMesjFIwgTWBUh6cNXuYsQ/5wIwIBIw==

The string written to the console must be sent to the administrator so they can create the new user in a similar way to the default user/password authentication users.

The following command will create a new user with username ``newuser``, assuming that the previous public key is saved in the text file ``/tmp/pub\_key``:

.. prompt:: bash $ auto

    $ oneuser create newuser --ssh --read-file /tmp/pub_key

Instead of using the ``--read-file`` option, the public key could be specified as the second parameter.

If the administrator has access to the user's **private ssh key**, they can create new users with the following command:

.. prompt:: bash $ auto

    $ oneuser create newuser --ssh --key /home/newuser/.ssh/id_rsa

Update Existing Users to SSH
----------------------------

You can change the authentication method of an existing user to SSH with the following commands:

.. prompt:: bash $ auto

    $ oneuser chauth <id|name> ssh
    $ oneuser passwd <id|name> --ssh --read-file /tmp/pub_key

As with the ``create`` command, you can specify the public key as the second parameter, or use the user's private key with the ``--key`` option.

User Login
----------

Users must execute the ``oneuser login`` command to generate a login token. The token will be stored in the ``$ONE_AUTH`` environment variable. The command requires the OpenNebula username, and the authentication method (``--ssh`` in this case).

.. prompt:: bash $ auto

    $ oneuser login newuser --ssh

The default SSH key is assumed to be in ``~/.ssh/id_rsa``, otherwise the path can be specified with the ``--key`` option.

The generated token has a default **expiration time** of 10 hours. You can change that with the ``--time`` option.

