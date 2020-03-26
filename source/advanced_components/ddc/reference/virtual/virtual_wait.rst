.. _ddc_virtual_wait:

==========
Wait Modes
==========

Some objects take a bit to be ready, concretely images depending on the size. To manage this, you can use the attribute wait, it can have two possible values:

- **false**: just create the objects and continue.
- **true**: create objects and wait until they are successfully imported.

Theses wait modes are also combined with :ref:`run modes <ddc_usage>`. So if the object fails when waiting to it, the tool is going to check waht run mode needs to apply.

For example:

.. code::

    images:
      - name: "test_image"
        ds_id: 1
        size: 2048
        meta:
          wait: false
          mode: 644

In this example, the image would be created and there will not be any wait until it is ready, the program would continue.

The timeout to wait until the resource is ready is also configurable, it can be done adding **wait_timeout** attribute in the object. For example:

.. code::

    images:
      - name: "test_image"
        ds_id: 1
        size: 2048
        meta:
          wait: true
          wait_timeout: 30

In this example, the timeout to wait would be 30 seconds.

.. warning:: Wait attribute is only available for images and marketplace apps.

Using Wait Globally
-------------------

As we have seen, you can set the wait per object in the provision template, but you can also set it globally using the CLI. There are two parameters available:

- **wait-ready**: with this the tool will wait until the resources are ready.
- **wait-timeout timeout**: with this you can set the timeout (default = 60s).

.. note:: The provision template wait and timeout are not overwritten by these parameters in the command, if you set some in the template they are respected.

For example:

.. code::

    $ oneprovision create virtual.yaml --wait-ready --wait-timeout 60

With this command the program will wait for all objects with a timeout of 60 seconds.
