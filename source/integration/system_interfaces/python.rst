PyONE: Open Nebula Python Bindings
==================================

PyOne is an implementation of Open Nebula XML-RPC bindings in Python. It has been designed as a wrapper for the XML-RPC methods, with some basic helpers. This means that you should be familiar with the XML-RPC API and the XML formats returned by the OpenNebula core. As stated in the XML-RPC documentation, you can download the XML Schemas (XSD) here.

API Documentation
================================================================================

You can consult the `doc online </doc/5.7/oca/python/>`__.

Usage
-------------

You can configure your XML-RPC Server endpoint and credentials in the constructor:

.. code:: python

  import pyone
  one = pyone.OneServer("http://one/RPC2", session="oneadmin:onepass" )

If you are connecting to a test platform with a self signed certificate you can disable
certificate verification as:

.. code:: python

  import pyone
  import ssl
  one = pyone.OneServer("http://one/RPC2", session="oneadmin:onepass", context=ssl._create_unverified_context() )

It is also possible to modify the default connection timeout, but note that the setting
will modify the TCP socket default timeout of your Python VM, ensure that the chosen timeout
is suitable to any other connections running in your project.


**Making Calls**

Calls match the API documentation provided by Open Nebula:

.. code:: python

  import pyone

  one = pyone.OneServer("http://one/RPC2", session="oneadmin:onepass" )
  hostpool = one.hostpool.info()
  host = hostpool.HOST[0]
  id = host.ID

Note that the session parameter is automatically included as well as the "one." prefix to the method.

**Returned Objects**

The returned types have been generated with generateDS and closely match the XSD specification.
You can use the XSD specification as primary documentation while your IDE will
offer code completion as you code or debug.

.. code:: python

   marketpool = one.marketpool.info()
   m0 = marketpool.MARKETPLACE[0]
   print "Markeplace name is " + m0.NAME

**Structured Parameters**

When making calls, the library will translate flat dictionaries into attribute=value
vectors. Such as:

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

GenerateDS creates members from most returned parameters, however, some elements in the XSD are marked as anyType
and GenerateDS cannot generate members automatically, TEMPLATE and USER_TEMPLATE are the common ones. Pyone will
allow accessing its contents as a plain python dictionary.

.. code:: python

  host = one.host.info(0)
  arch = host.TEMPLATE['ARCH']

This makes it possible to read a TEMPLATE as dictionary, modify it and use it as parameter
for an update method, as following:

.. code:: python

  host = one.host.info(0)
  host.TEMPLATE['NOTES']="Just updated"
  one.host.update(0,host.TEMPLATE,1)

**Constants**

Some methods will return encoded values such as those representing the STATE of a resource. Constant are
provided to better handle those.

.. code:: python

  from pyone import MARKETPLACEAPP_STATES
  if app.STATE == MARKETPLACEAPP_STATES.READY:
    # action that assumes app ready