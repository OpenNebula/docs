.. _occidd:

==============================
OpenNebula OCCI Specification
==============================

Overview
========

The OpenNebula OCCI API is a RESTful service to create, control and monitor cloud resources using an implementation of the `OGF OCCI API specification <http://www.occi-wg.org>`__ based on the `draft 0.8 <http://forge.ogf.org/sf/docman/do/downloadDocument/projects.occi-wg/docman.root.drafts/doc15731/3>`__. This implementation also includes some extensions, requested by the community, to support OpenNebula specific functionality. There are two types of resources that resemble the basic entities managed by the OpenNebula system, namely:

-  **Pool Resources (PR)**: Represents a collection of elements owned by a given user. In particular five collections are defined:

.. code::

      <COLLECTIONS>
        <COMPUTE_COLLECTION href="http://localhost:4567/compute">
        <INSTANCE_TYPE_COLLECTION href="http://localhost:4567/instance_type">
        <NETWORK_COLLECTION href="http://localhost:4567/network">
        <STORAGE_COLLECTION href="http://localhost:4567/storage">
        <USER_COLLECTION href="http://localhost:4567/user">
      </COLLECTIONS>
     

-  **Entry Resources (ER)**: Represents a single entry within a given collection: COMPUTE, NETWORK, STORAGE, INSTANCE\_TYPE and USER.

Each one of ERs in the pool are described by an element (e.g. ``COMPUTE``, ``INSTANCE_TYPE``, ``NETWORK``, ``STORAGE`` or ``USER``) with one attribute:

-  ``href``, a URI for the ER

.. code::

        <COMPUTE_COLLECTION>
            <COMPUTE href="http://www.opennebula.org/compute/310" name="TestVM"/>
            <COMPUTE href="http://www.opennebula.org/compute/432" name="Server1"/>
            <COMPUTE href="http://www.opennebula.org/compute/123" name="Server2"/>
        </COMPUTE_COLLECTION>
     

A ``COMPUTE`` entry resource can be linked to one or more ``STORAGE`` or ``NETWORK`` resources and one ``INSTANCE_TYPE`` and ``USER``.

|image0|

Authentication & Authorization
==============================

User authentication will be `HTTP Basic access authentication <http://tools.ietf.org/html/rfc1945#section-11>`__ to comply with REST philosophy. The credentials passed should be the User name and password. If you are not using the occi tools provided by OpenNebula, the password has to be SHA1 hashed as well as it is stored in the database instead of using the plain version.

HTTP Headers
============

The following headers are compulsory:

-  **Content-Length**: The size of the Entity Body in octets
-  **Content-Type**: application/xml

Uploading images needs HTTP multi part support, and also the following header

-  **Content-Type**: multipart/form-data

Return Codes
============

The OpenNebula Cloud API uses the following subset of HTTP Status codes:

-  **200 OK** : The request has succeeded.
-  **201 Created** : Request was successful and a new resource has being created
-  **202 Accepted** : The request has been accepted for processing, but the processing has not been completed
-  **204 No Content** : The request has been accepted for processing, but no info in the response
-  **400 Bad Request** : Malformed syntax
-  **401 Unauthorized** : Bad authentication
-  **403 Forbidden** : Bad authorization
-  **404 Not Found** : Resource not found
-  **500 Internal Server Error** : The server encountered an unexpected condition which prevented it from fulfilling the request.
-  **501 Not Implemented** : The functionality requested is not supported

The methods specified below are described without taking into account **4xx** (can be inferred from authorization information in section above) and **5xx** errors (which are method independent). HTTP verbs not defined for a particular entity will return a **501 Not Implemented**.

Resource Representation
=======================

Network
-------

The ``NETWORK`` element defines a virtual network that interconnects those ``COMPUTES`` with a network interface card attached to that network. The traffic of each network is isolated from any other network, so it constitutes a broadcasting domain.

The following elements define a ``NETWORK``:

-  ``ID``, the uuid of the NETWORK
-  ``NAME`` describing the NETWORK
-  ``USER`` link to the USER owner of the NETWORK
-  ``GROUP`` of the NETWORK
-  ``DESCRIPTION`` of the NETWORK
-  ``ADDRESS``, of the NETWORK
-  ``SIZE``, of the network, defaults to C

The elements in bold can be provided in a POST request in order to create a new NETWORK resource based on those parameters.

Example:

.. code::

        <NETWORK href="http://www.opennebula.org/network/123">
             <ID>123</ID>
             <NAME>BlueNetwork</NAME>
             <USER href="http://www.opennebula.org/user/33" name="cloud_user"/>
             <GROUP>cloud_group</GROUP>
             <DESCRIPTION>This NETWORK is blue<DESCRIPTION>
             <ADDRESS>192.168.0.1</ADDRESS>
             <SIZE>C</SIZE>
        </NETWORK>

Storage
-------

The ``STORAGE`` is a resource containing an operative system or data, to be used as a virtual machine disk:

-  ``ID`` the uuid of the STORAGE
-  ``NAME`` describing the STORAGE
-  ``USER`` link to the USER owner of the STORAGE
-  ``GROUP`` of the STORAGE
-  ``DESCRIPTION`` of the STORAGE
-  ``TYPE``, type of the image

   -  ``OS``: contains a working operative system
   -  ``CDROM``: readonly data
   -  ``DATABLOCK``: storage for data, which can be accessed and modified from different Computes

-  ``SIZE``, of the image in MBs
-  ``FSTYPE``, in case of DATABLOCK, the type of filesystem desired

The elements in bold can be provided in a POST request in order to create a new NETWORK resource based on those parameters.

Example:

.. code::

        <STORAGE href="http://www.opennebula.org/storage/123">
            <ID>123</ID>
            <NAME>Ubuntu Desktop</NAME>
            <USER href="http://www.opennebula.org/user/33" name="cloud_user"/>
            <GROUP>cloud_group</GROUP>
            <DESCRIPTION>Ubuntu 10.04 desktop for students.</DESCRIPTION>
            <TYPE>OS</TYPE>
            <SIZE>2048</SIZE>
        </STORAGE>

Compute
-------

The ``COMPUTE`` element defines a virtual machine by specifying its basic configuration attributes such as ``NIC`` or ``DISK``.

The following elements define a COMPUTE:

-  ``ID``, the uuid of the COMPUTE.
-  ``NAME``, describing the COMPUTE.
-  ``USER`` link to the USER owner of the COMPUTE
-  ``GROUP`` of the COMPUTE
-  ``CPU`` number of CPUs of the COMPUTE
-  ``MEMORY`` MBs of MEMORY of the COMPUTE
-  ``INSTANCE_TYPE``, ink to a INSTANCE\_TYPE resource
-  ``DISK``, the block devices attached to the virtual machine.

   -  ``STORAGE`` link to a STORAGE resource
   -  ``TARGET``
   -  ``SAVE_AS`` link to a STORAGE resource to save the disk image when the COMPUTE is DONE
   -  ``TYPE``

-  ``NIC``, the network interfaces.

   -  ``NETWORK`` link to a NETWORK resource
   -  ``IP``
   -  ``MAC``

-  ``CONTEXT``, key value pairs to be passed on creation to the COMPUTE.

   -  ``KEY1`` VALUE1
   -  ``KEY2`` VALUE2

-  ``STATE``, the state of the COMPUTE. This can be one of:

|image1|

Example:

.. code::

        <COMPUTE href="http://www.opennebula.org/compute/32">
            <ID>32</ID>
            <NAME>Web Server</NAME>
            <CPU>1</CPU>
            <MEMORY>1024</MEMORY>
            <USER href="http://0.0.0.0:4567/user/310" name="cloud_user"/>
            <GROUP>cloud_group</GROUP>
            <INSTANCE_TYPE href="http://0.0.0.0:4567/instance_type/small">small</INSTANCE_TYPE>
            <STATE>ACTIVE</STATE>
            <DISK>
                <STORAGE href="http://www.opennebula.org/storage/34" name="Ubuntu10.04"/>
                <TYPE>OS</TYPE>
                <TARGET>hda</TARGET>
            </DISK>
            <DISK>
                <STORAGE href="http://www.opennebula.org/storage/24" name="testingDB"/>
                <SAVE_AS href="http://www.opennebula.org/storage/54"/>
                <TYPE>CDROM</TYPE>
                <TARGET>hdc</TARGET>
            </DISK>
            <NIC>
                <NETWORK href="http://www.opennebula.org/network/12" name="Private_LAN"/>
                <MAC>00:ff:72:31:23:17</MAC>
                <IP>192.168.0.12</IP>
            </NIC>
            <NIC>
                <NETWORK href="http://www.opennebula.org/network/10" name="Public_IPs"/>
                <MAC>00:ff:72:17:20:27</MAC>
                <IP>192.168.0.25</IP>
            </NIC>
            <CONTEXT>
                <PUB_KEY>FDASF324DSFA3241DASF</PUB_KEY>
            </CONTEXT>
        </COMPUTE>

Instance type
-------------

An INSTANCE\_TYPE specifies the COMPUTE capacity values

-  ``ID``, the uuid of the INSTANCE\_TYPE.
-  ``NAME``, describing the INSTANCE\_TYPE.
-  ``CPU`` number of CPUs of the INSTANCE\_TYPE
-  ``MEMORY`` MBs of MEMORY of the INSTANCE\_TYPE

Example:

.. code::

        <INSTANCE_TYPE href="http://www.opennebula.org/instance_type/small">
            <ID>small</ID>
            <NAME>small</NAME>
            <CPU>1</CPU>
            <MEMORY>1024</MEMORY>
        </INSTANCE_TYPE>

User
----

A USER specifies the COMPUTE capacity values

-  ``ID``, the uuid of the INSTANCE\_TYPE.
-  ``NAME``, describing the INSTANCE\_TYPE.
-  ``GROUP``, fo the USER
-  ``QUOTA``,

   -  ``CPU``:
   -  ``MEMORY``:
   -  ``NUM_VMS``:
   -  ``STORAGE``

-  ``USAGE``,

   -  ``CPU``:
   -  ``MEMORY``:
   -  ``NUM_VMS``:
   -  ``STORAGE``

Example:

.. code::

        <USER href="http://www.opennebula.org/user/42">
            <ID>42</ID>
            <NAME>cloud_user</NAME>
            <GROUP>cloud_group</GROUP>
            <QUOTA>
                <CPU>8</CPU>
                <MEMORY>4096</MEMORY>
                <NUM_VMS>10</NUM_VMS>
                <STORAGE>0</STORAGE>
            </QUOTA>
            <USAGE>
                <CPU>2</CPU>
                <MEMORY>512</MEMORY>
                <NUM_VMS>2</NUM_VMS>
                <STORAGE>0</STORAGE>
            </USAGE>
        </USER>

Request Methods
===============

+--------------+-----------+----------------------------------------------------+---------------------------------------------------------------------------------------+
| **Method**   | **URL**   | **Meaning / Entity Body**                          | **Response**                                                                          |
+==============+===========+====================================================+=======================================================================================+
| **GET**      | ``/``     | **List** the available collections in the cloud.   | **200 OK**: An XML representation of the the available collections in the http body   |
+--------------+-----------+----------------------------------------------------+---------------------------------------------------------------------------------------+

Network
-------

+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **Method**   | **URL**             | **Meaning / Entity Body**                                                                                                                                                   | **Response**                                                                                 |
+==============+=====================+=============================================================================================================================================================================+==============================================================================================+
| **GET**      | ``/network``        | **List** the contents of the NETWORK collection. Optionally a verbose param (``/network?verbose=true``) can be provided to retrieve an extended version of the collection   | **200 OK**: An XML representation of the collection in the http body                         |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **POST**     | ``/network``        | **Create** a new NETWORK. An XML representation of a NETWORK without the ID element should be passed in the http body                                                       | **201 Created**: An XML representation of the new NETWORK with the ID                        |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **GET**      | ``/network/<id>``   | **Show** the NETWORK resource identified by <id>                                                                                                                            | **200 OK** : An XML representation of the NETWORK in the http body                           |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **PUT**      | ``/network/<id>``   | **Update** the NETWORK resource identified by <id>                                                                                                                          | **202 Accepted** : The update request is being process, polling required to confirm update   |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **DELETE**   | ``/network/<id>``   | **Delete** the NETWORK resource identified by <id>                                                                                                                          | **204 No Content**:                                                                          |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+

Storage
-------

+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **Method**   | **URL**             | **Meaning / Entity Body**                                                                                                                                                   | **Response**                                                                                 |
+==============+=====================+=============================================================================================================================================================================+==============================================================================================+
| **GET**      | ``/storage``        | **List** the contents of the STORAGE collection. Optionally a verbose param (``/storage?verbose=true``) can be provided to retrieve an extended version of the collection   | **200 OK**: An XML representation of the collection in the http body                         |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **POST**     | ``/storage``        | **Create** an new STORAGE. An XML representation of a STORAGE without the ID element should be passed in the http body                                                      | **201 Created**: An XML representation of the new NETWORK with the ID                        |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **GET**      | ``/storage/<id>``   | **Show** the STORAGE resource identified by <id>                                                                                                                            | **200 OK** : An XML representation of the STORAGE in the http body                           |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **PUT**      | ``/storage/<id>``   | **Update** the STORAGE resource identified by <id>                                                                                                                          | **202 Accepted** : The update request is being process, polling required to confirm update   |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **DELETE**   | ``/storage/<id>``   | **Delete** the STORAGE resource identified by <id>                                                                                                                          | **204 No Content**:                                                                          |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+

Compute
-------

+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **Method**   | **URL**             | **Meaning / Entity Body**                                                                                                                                                   | **Response**                                                                                 |
+==============+=====================+=============================================================================================================================================================================+==============================================================================================+
| **GET**      | ``/compute``        | **List** the contents of the COMPUTE collection. Optionally a verbose param (``/compute?verbose=true``) can be provided to retrieve an extended version of the collection   | **200 OK**: An XML representation of the pool in the http body                               |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **POST**     | ``/compute``        | **Create** a new COMPUTE. An XML representation of a COMPUTE without the ID element should be passed in the http body                                                       | **201 Created**: An XML representation of the new COMPUTE with the ID                        |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **GET**      | ``/compute/<id>``   | **Show** the COMPUTE resource identified by <id>                                                                                                                            | **200 OK** : An XML representation of the network in the http body                           |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **PUT**      | ``/compute/<id>``   | **Update** the COMMPUTE resource identified by <id>                                                                                                                         | **202 Accepted** : The update request is being process, polling required to confirm update   |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+
| **DELETE**   | ``/compute/<id>``   | **Delete** the COMPUTE resource identified by <id>                                                                                                                          | **204 No Content**: The Network has been successfully deleted                                |
+--------------+---------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------+

Instance type
-------------

+--------------+---------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------+
| **Method**   | **URL**                   | **Meaning / Entity Body**                                                                                                                                                                | **Response**                                                                |
+==============+===========================+==========================================================================================================================================================================================+=============================================================================+
| **GET**      | ``/instance_type``        | **List** the contents of the INSTANCE\_TYPE collection. Optionally a verbose param (``/instance_type?verbose=true``) can be provided to retrieve an extended version of the collection   | **200 OK**: An XML representation of the collection in the http body        |
+--------------+---------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------+
| **GET**      | ``/instance_type/<id>``   | **Show** the INSTANCE\_TYPE resource identified by <id>                                                                                                                                  | **200 OK** : An XML representation of the INSTANCE\_TYPE in the http body   |
+--------------+---------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------+

User
----

+--------------+------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------+
| **Method**   | **URL**          | **Meaning / Entity Body**                                                                                                                                             | **Response**                                                           |
+==============+==================+=======================================================================================================================================================================+========================================================================+
| **GET**      | ``/user``        | **List** the contents of the USER collection. Optionally a verbose param (``/user?verbose=true``) can be provided to retrieve an extended version of the collection   | **200 OK**: An XML representation of the collection in the http body   |
+--------------+------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------+
| **GET**      | ``/user/<id>``   | **Show** the USER resource identified by <id>                                                                                                                         | **200 OK** : An XML representation of the USER in the http body        |
+--------------+------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------+

Implementation Notes
====================

Authentication
--------------

It is recommended that the server-client communication is performed over HTTPS to avoid sending user authentication information in plain text.

Notifications
-------------

HTTP protocol does not provide means for notification, so this API relies on asynchronous polling to find whether a RESOURCE update is successful or not.

Examples
========

.. |image0| image:: /images/3cbe4d73.png
.. |image1| image:: /images/diagram.png
