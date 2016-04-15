.. _ec2qec:

==============
EC2 Ecosystem
==============

In order to interact with the EC2 Service that OpenNebula implements you can use the client included in the OpenNebula distribution, but also you can choose one of the well known tools that are supposed to interact with cloud servers through the EC2 Query API, like the Firefox extension `HybridFox <http://code.google.com/p/hybridfox/>`__, or the command line tools, `Euca2ools <http://open.eucalyptus.com/wiki/Euca2oolsGuide_v1.1/>`__.

HybridFox
=========

| `HybridFox <http://code.google.com/p/hybridfox/>`__ is a Mozilla Firefox extension for managing your Amazon EC2 account. Launch new instances, mount Elastic Block Storage volumes, map Elastic IP addresses, and more.
|
|  **Configuration**

-  You have to set up the credentials to interact with OpenNebula, by pressing the ``Credentials`` button:

   #. Account Name, add a name for this account
   #. AWS Access Key, add your OpenNebula username
   #. AWS Secret Access Key, add your OpenNebula SHA1 hashed password

| |image0|

-  Also you have to specify in a new ``Region`` the endpoint in which the EC2 Service is running, by pressing on the Regions button. Take care of using exactly the same url and port that is specified in the econe.conf file, otherwise you will get ``AuthFailure``:

| |image1|

.. warning:: If you have problems adding a new region, try to add it manually in the ec2ui.endpoints variable inside the Firefox about:config

|
|  **Typical usage scenarios**

-  **List images**

|image3|

-  **Run instances**

|image4|

-  **Control instances**

| |image5|
|  You can also use `HybridFox <http://code.google.com/p/hybridfox/>`__ a similar Mozilla Firefox extension to interact with cloud services through the EC2 Query API

Euca2ools
=========

`Euca2ools <http://open.eucalyptus.com/wiki/Euca2oolsGuide_v1.1/>`__ are command-line tools for interacting with Web services that export a REST/Query-based API compatible with Amazon EC2 and S3 services.

| You have to set the following environment variables in order to interact with the OpenNebula EC2 Query Server. The ``EC2_URL`` will be the same endpoint as defined in the ``/etc/one/econe.conf`` file of Opennebula. The ``EC2_ACCESS_KEY`` will be the OpenNebula username and the ``EC2_SECRET_KEY`` the OpenNebula sha1 hashed user password

.. code::

    ~$ env | grep EC2
    EC2_SECRET_KEY=e17a13.0834936f71bb3242772d25150d40791e72
    EC2_URL=http://localhost:4567
    EC2_ACCESS_KEY=oneadmin

|
|  **Typical usage scenarios**

-  **List images**

.. code::

    ~$ euca-describe-images
    IMAGE   ami-00000001    srv/cloud/images/1  daniel  available   private     i386    machine
    IMAGE   ami-00000002    srv/cloud/images/2  daniel  available   private     i386    machine
    IMAGE   ami-00000003    srv/cloud/images/3  daniel  available   private     i386    machine
    IMAGE   ami-00000004    srv/cloud/images/4  daniel  available   private     i386    machine

|

-  **List instances**

.. code::

    ~$ euca-describe-instances
    RESERVATION default daniel  default
    INSTANCE    i-0 ami-00000002    192.168.0.1 192.168.0.1 running     default     0   m1.small    2010-06-21T18:51:13+02:00   default     eki-EA801065    eri-1FEE1144
    INSTANCE    i-3 ami-00000002    192.168.0.4 192.168.0.4 running     default     0   m1.small    2010-06-21T18:53:30+02:00   default     eki-EA801065    eri-1FEE1144

|

-  **Run instances**

.. code::

    ~$ euca-run-instances --instance-type m1.small ami-00000001
    RESERVATION r-47a5402e  daniel  default
    INSTANCE    i-4 ami-00000001    192.168.0.2 192.168.0.2 pending default 2010-06-22T11:54:07+02:00   None    None

.. |image0| image:: /images/account.jpg
.. |image1| image:: /images/regions.jpg
.. |image3| image:: /images/images.jpg
.. |image4| image:: /images/run_instances.jpg
.. |image5| image:: /images/instances.jpg
