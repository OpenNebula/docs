.. _python:

================================================================================
PyONE: OpenNebula Python Bindings
================================================================================

PyONE is an implementation of OpenNebula XML-RPC bindings in Python. It has been designed as a wrapper for the :ref:`XML-RPC methods <api>`, with some basic helpers. This means that you should be familiar with the XML-RPC API and the XML formats returned by the OpenNebula core. As stated in the :ref:`XML-RPC documentation <api>`, you can download the :ref:`XML Schemas (XSD) here <api_xsd_reference>`.

API Documentation
================================================================================

You can consult the `doc online </doc/5.13/oca/python/>`__, but as long as the code is generated it is not much useful, the main source of the documentation is still the :ref:`XML-RPC doc <api>`

Download and installation
================================================================================

You can either use the system package ``python-pyone`` / ``python3-pyone`` or install it using ``pip install pyone``.


Usage
================================================================================

You need to configure your XML-RPC Server endpoint and credentials when instantiate the OneServer class:

.. code:: python

  import pyone
  one = pyone.OneServer("http://one:2633/RPC2", session="oneadmin:onepass" )

If you are connecting to a test platform with a self signed certificate you can disable
certificate verification as:

.. code:: python

  import pyone
  import ssl
  one = pyone.OneServer("http://one:2633/RPC2", session="oneadmin:onepass", context=ssl._create_unverified_context() )

It is also possible to modify the default connection timeout, but note that the setting will modify the TCP socket default timeout of your Python VM, ensure that the chosen timeout is suitable to any other connections running in your project.


Making Calls
^^^^^^^^^^^^

Calls match the API documentation provided by OpenNebula, so for example to XML api call :ref:`one.hostpool.info <api_hostpool_info>` corresponds following code:

.. code:: python

  import pyone

  one = pyone.OneServer("http://one:2633/RPC2", session="oneadmin:onepass" )
  hostpool = one.hostpool.info()
  host = hostpool.HOST[0]
  id = host.ID

Note that the session parameter is automatically included as well as the "one." prefix to the method.

Returned Objects
^^^^^^^^^^^^^^^^

The returned types have been generated with generateDS and closely match the XSD specification.  You can use the XSD specification and  XML-RPC as primary documentation.

.. code:: python

   marketpool = one.marketpool.info()
   m0 = marketpool.MARKETPLACE[0]
   print "Marketplace name is " + m0.NAME

Structured Parameters
^^^^^^^^^^^^^^^^^^^^^

When making calls, the library will translate flat dictionaries into attribute=value vectors. Such as:

.. code:: python

  one.host.update(0,  {"LABELS": "HD"}, 1)

When the provided dictionary has a "root" dictionary, it is considered to be root
element and it will be translated to XML:

.. code:: python

  one.vm.update(1,
    {
      'TEMPLATE': {
        'NAME': 'abc',
        'MEMORY': '1024',
        'ATT1': 'value1'
      }
    }, 1)

However, this might be limiting when you want to add 2 entries with the same name. In such cases you need to pass the template directly in OpenNebula template format:

.. code:: python

  one.template.allocate(
    '''NAME="test100"
       MEMORY="1024"
       DISK=[ IMAGE_ID= "1" ]
       DISK=[ IMAGE_ID= "2" ]
       CPU="1"
       VCPU="2"
    ''')


generateDS creates members from most returned parameters, however, some elements in the XSD are marked as anyType and generateDS cannot generate members automatically, TEMPLATE and USER_TEMPLATE are the common ones. Pyone will allow accessing its contents as a plain python dictionary.

.. code:: python

  host = one.host.info(0)
  arch = host.TEMPLATE['ARCH']

This makes it possible to read a TEMPLATE as dictionary, modify it and use it as parameter for an update method, as following:

.. code:: python

  host = one.host.info(0)
  host.TEMPLATE['NOTES']="Just updated"
  one.host.update(0,host.TEMPLATE,1)

Constants
^^^^^^^^^

Some methods will return encoded values such as those representing the STATE of a resource. Constants are provided to better handle those.

.. code:: python

  from pyone import MARKETPLACEAPP_STATES
  if app.STATE == MARKETPLACEAPP_STATES.READY:
    # action that assumes app ready

More examples
^^^^^^^^^^^^^

.. code:: python

  import pyone
  one = pyone.OneServer("http://one:2633/RPC2", session="oneadmin:onepass" )

Allocate localhost as new host

.. code:: python

   one.host.allocate('localhost', 'kvm', 'kvm', 0)

See host template

.. code:: python

   host = one.hostpool.info().HOST[0]
   dict(host.TEMPLATE)

See VM template

.. code:: python

   vm_template = one.templatepool.info(-1, -1, -1).VMTEMPLATE[0]
   vm_template.get_ID()
   vm_template.get_NAME()

Instantiate it

.. code:: python

   one.template.instantiate(0, "my_VM")

See it

.. code:: python

   my_vm = one.vmpool.info(-1,-1,-1,-1).VM[0]
   my_vm.get_ID()
   my_vm.get_NAME()
   my_vm.get_TEMPLATE()

Terminate it

.. code:: python

   one.vm.action('terminate', 0)

Credits
================================================================================
Python bindings were ported to upstream from stand-alone PyONE addon made by *Rafael del Valle* `PyONE <https://github.com/OpenNebula/addon-pyone>`__
