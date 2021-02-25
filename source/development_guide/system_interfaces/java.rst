.. _java:

================================================================================
Java OpenNebula Cloud API
================================================================================

This page contains the OpenNebula Cloud API Specification for Java. It has been designed as a wrapper for the :ref:`XML-RPC methods <api>`, with some basic helpers. This means that you should be familiar with the XML-RPC API and the XML formats returned by the OpenNebula core. As stated in the :ref:`XML-RPC documentation <api>`, you can download the :ref:`XML Schemas (XSD) here <api_xsd_reference>`.

Download
================================================================================

You can download the ``.jar`` file compiled using Java 1.8, the required libraries, and the javadoc packaged in a tar.gz file `following this link <http://downloads.opennebula.io/packages>`__ in the OpenNebula version you have installed.

You can also consult the `javadoc online </doc/5.13/oca/java/>`__.

Usage
================================================================================

To use the OpenNebula Cloud API for Java in your Java project, you have to add to the classpath the org.opennebula.client.jar file and the xml-rpc libraries located in the lib directory.

Code Sample
================================================================================

This is a small code snippet. As you can see, the code flow would be as follows:

-  Create a ``org.opennebula.client.Client`` object, setting up the authorization string and the endpoint. You only need to create it once.
-  Create a pool (e.g. ``HostPool``) or element (e.g. ``VirtualNetwork``) object.
-  You can perform “actions” over these objects right away, like ``myVNet.delete();``
-  If you want to query any information (like what objects the pool contains, or one of the element attributes), you have to issue an ``info()`` call before, so the object retrieves the data from OpenNebula.

For more complete examples, please check the ``src/oca/java/share/examples`` directory included. You may be also interested in the java files included in ``src/oca/java/test``.

.. code-block:: java

    // First of all, a Client object has to be created.
    // Here the client will try to connect to OpenNebula using the default
    // options: the auth. file will be assumed to be at $ONE_AUTH, and the
    // endpoint will be set to the environment variable $ONE_XMLRPC.
    Client oneClient;

    try
    {
        oneClient = new Client();

        // We will try to create a new virtual machine. The first thing we
        // need is an OpenNebula virtual machine template.

        // This VM template is a valid one, but it will probably fail to run
        // if we try to deploy it; the path for the image is unlikely to
        // exist.
        String vmTemplate =
              "NAME     = vm_from_java    CPU = 0.1    MEMORY = 64\n"
            + "#DISK     = [\n"
            + "#\tsource   = \"/home/user/vmachines/ttylinux/ttylinux.img\",\n"
            + "#\ttarget   = \"hda\",\n"
            + "#\treadonly = \"no\" ]\n"
            + "# NIC     = [ NETWORK = \"Non existing network\" ]\n"
            + "FEATURES = [ acpi=\"no\" ]";

        // You can try to uncomment the NIC line, in that case OpenNebula
        // won't be able to insert this machine in the database.

        System.out.println("Virtual Machine Template:\n" + vmTemplate);
        System.out.println();

        System.out.print("Trying to allocate the virtual machine... ");
        OneResponse rc = VirtualMachine.allocate(oneClient, vmTemplate);

        if( rc.isError() )
        {
            System.out.println( "failed!");
            throw new Exception( rc.getErrorMessage() );
        }

        // The response message is the new VM's ID
        int newVMID = Integer.parseInt(rc.getMessage());
        System.out.println("ok, ID " + newVMID + ".");

        // We can create a representation for the new VM, using the returned
        // VM-ID
        VirtualMachine vm = new VirtualMachine(newVMID, oneClient);

        // Let's hold the VM, so the scheduler won't try to deploy it
        System.out.print("Trying to hold the new VM... ");
        rc = vm.hold();

        if(rc.isError())
        {
            System.out.println("failed!");
            throw new Exception( rc.getErrorMessage() );
        }
        else
            System.out.println("ok.");

        // And now we can request its information.
        rc = vm.info();

        if(rc.isError())
            throw new Exception( rc.getErrorMessage() );

        System.out.println();
        System.out.println(
                "This is the information OpenNebula stores for the new VM:");
        System.out.println(rc.getMessage() + "\n");

        // This VirtualMachine object has some helpers, so we can access its
        // attributes easily (remember to load the data first using the info
        // method).
        System.out.println("The new VM " +
                vm.getName() + " has status: " + vm.status());

        // And we can also use xpath expressions
        System.out.println("The path of the disk is");
        System.out.println( "\t" + vm.xpath("template/disk/source") );

        // Let's delete the VirtualMachine object.
        vm = null;

        // The reference is lost, but we can ask OpenNebula about the VM
        // again. This time however, we are going to use the VM pool
        VirtualMachinePool vmPool = new VirtualMachinePool(oneClient);
        // Remember that we have to ask the pool to retrieve the information
        // from OpenNebula
        rc = vmPool.info();

        if(rc.isError())
            throw new Exception( rc.getErrorMessage() );

        System.out.println(
                "\nThese are all the Virtual Machines in the pool:");
        for ( VirtualMachine vmachine : vmPool )
        {
            System.out.println("\tID : " + vmachine.getId() +
                               ", Name : " + vmachine.getName() );

            // Check if we have found the VM we are looking for
            if ( vmachine.getId().equals( ""+newVMID ) )
            {
                vm = vmachine;
            }
        }

        // We have also some useful helpers for the actions you can perform
        // on a virtual machine, like suspend:
        rc = vm.suspend();
        System.out.println("\nTrying to suspend the VM " + vm.getId() +
                            " (should fail)...");

        // This is all the information you can get from the OneResponse:
        System.out.println("\tOpenNebula response");
        System.out.println("\t  Error:  " + rc.isError());
        System.out.println("\t  Msg:    " + rc.getMessage());
        System.out.println("\t  ErrMsg: " + rc.getErrorMessage());

        rc = vm.terminate();
        System.out.println("\nTrying to terminate the VM " +
                            vm.getId() + "...");

        System.out.println("\tOpenNebula response");
        System.out.println("\t  Error:  " + rc.isError());
        System.out.println("\t  Msg:    " + rc.getMessage());
        System.out.println("\t  ErrMsg: " + rc.getErrorMessage());


    }
    catch (Exception e)
    {
        System.out.println(e.getMessage());
    }

Compilation
================================================================================

To compile the Java OCA, untar the `OpenNebula source <http://downloads.opennebula.io>`__, ``cd`` to the java directory and use the build script:

.. prompt:: text $ auto

    $ cd src/oca/java
    $ ./build.sh -d
    Compiling java files into class files...
    Packaging class files in a jar...
    Generating javadocs...

This command will compile and package the code in ``jar/org.opennebula.client.jar``, and the javadoc will be created in ``share/doc/``.

You might want to copy the .jar files to a more convenient directory. You could use /usr/lib/one/java/

.. prompt:: text $ auto

    $ sudo mkdir /usr/lib/one/java/
    $ sudo cp jar/* lib/* /usr/lib/one/java/
