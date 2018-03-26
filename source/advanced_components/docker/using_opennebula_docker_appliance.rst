.. _using_opennebula_docker_appliance:

=========================================================
Using OpenNebula Docker Appliance
=========================================================

OpenNebula Docker Appliance allow to deploy VMs with docker running.

Step 1 - Get the boot2docker template
=========================================================

The **boot2docker** template can be downloaded from the OpenNebula `marketplace <http://marketplace.opennebula.systems/appliance/56d073858fb81d0315000002>`__.

|market-place-b2d|

The template can be updated in order to custimize any attribute, as the memory, CPU, ... 
It is necessary to attach a network which can be accessed by the client which need to connect to the docker engine.

Step 2 - Instantiate
=========================================================

Once the **boot2docker** template have been downloaded it can be instantiate as a normal template of OpenNebula.

|b2d-running|

Step 3 - Usage
=========================================================

Once the VM is running with the boot2docker template it can be accessed over the vnc client or over a SHH conection.

|b2d-vnc.png|

For SSH conection we have to use ``docker`` as the user and ``tcuser`` as the password:

.. prompt:: bash # auto
    
    # ssh docker@<vm_ip>
      docker@192.168.122.8s password: tcuser
      docker@boot2docker:~$

.. note::

    Is recomended to change the default password for docker user.

.. |market-place-b2d| image:: /images/market-place-b2d.png
.. |b2d-running| image:: /images/b2d-running.png
.. |b2d-vnc.png| image:: /images/b2d-vnc.png
