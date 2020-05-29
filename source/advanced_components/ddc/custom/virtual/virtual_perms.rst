.. _ddc_virtual_perms:

=========================
Ownership and Permissions
=========================

All the virtual OpenNebula objects are created by oneprovision itself, by default the ownership correspond to the user executing the tool, normally it is oneadmin. In case
you want to change the ownership or permissions you can add the following attributes to the template:

- **uid**: user ID for the object.
- **gid**: groupd ID for the object.
- **uname**: user name for the object.
- **gname**: group name for the object.
- **mode**: permissions in octet format for the object.

For example, if we want to change the user for an specific image, we should add the following:

.. code::

    images:
        - name: "test_image"
          ds_id: 1
          size: 2048
          meta:
            uid: 1

In this example, the image owner after creation finished would be serveradmin, which is the user with ID 1.

This applies to all objects and you can combine the three of them, for example:

.. code::

    images:
        - name: "test_image"
          ds_id: 1
          size: 2048
          meta:
            uid: 1
            gid: 1
            mode: 644

In this example, the image owner would be serveradmin, the group would be users and the permissions would be 644.

You can also use the **uname** and **gname**, for example:

.. code::

    images:
        - name: "test_image"
          ds_id: 1
          size: 2048
          meta:
            uname: user1
            gname: users
            mode: 644

In this example, the image owner would be user1 and the group would be users.
