.. _devel-auth:

======================
Authentication Driver
======================

This guide will show you how to develop a new driver for OpenNebula to interact with an external authentication service.

OpenNebula comes with an internal user/password way of authentication, this is called ``core``. To be able to use other auth methods there is a system that performs authentication with external systems. Authentication drivers are responsible of getting the user credentials from OpenNebula database and login and answer whether the authentication is correct or not.

In the OpenNebula database there are two values saved for every user, this is ``username`` and ``password``. When the driver used for authentication is core (authenticated without an external auth driver) the password value holds the SHA1 hash of the user's password. In case we are using other authentication method this ``password`` field can contain any other information we can use to recognize a user, for example, for x509 authentication this field contains the user's public key.

Authentication Driver
=====================

Authentication drivers are located at ``/var/lib/one/remotes/auth``. There is a directory for each of authentication drivers with an executable inside called ``authenticate``. The name of the directory has to be the same as the user's auth driver we want to authenticate. For example, if a user has as auth driver ``x509`` OpenNebula will execute the file ``/var/lib/one/remotes/auth/x509/authenticate`` when he performs an OpenNebula action.

The script receives three parameters:

-  ``username``: name of the user who wants to authenticate.
-  ``password``: value of the password field for the user that is trying to authenticate. This can be ``-`` when the user does not exist in the OpenNebula database.
-  ``secret``: value provided in the password field of the authentication string.

For example, we can create a new authentication method that just checks the length of the password. For this we can store in the password field the number of characters accepted, for example 5, and user name test. Here are some example calls to the driver with several passwords:

.. code::

    authenticate test 5 testpassword
    authenticate test 5 another_try
    authenticate test 5 12345

The script should exit with a non 0 status when the authentication is not correct and write in ``stderr`` the error. When the authentication is correct it should return:

-  Name of the driver. This is used when the user does not exist, this will be written to user's the auth driver field.
-  User name
-  Text to write in the user's password field in case the user does not exist.

The code for the ``/var/lib/one/remotes/auth/length/authenticate`` executable can be:

.. code::

    #!/bin/bash
     
    username=$1
    password=$2
    secret=$3
     
    length=$(echo -n "$secret" | wc -c | tr -d ' ')
     
    if [ $length = $password ]; then
        echo "length $username $secret"
    else
        echo "Invalid password"
        exit 255
    fi

Enabling the Driver
===================

To be able to use the new driver we need to add its name to the list of enabled drivers in ``oned.conf``:

.. code::

    AUTH_MAD = [
        executable = "one_auth_mad",
        authn = "ssh,x509,ldap,server_cipher,server_x509,length"
    ]

