.. _ruby:

================================================================================
Ruby OpenNebula Cloud API
================================================================================

This page contains the OpenNebula Cloud API Specification for Ruby. It has been designed as a wrapper for the :ref:`XML-RPC methods <api>`, with some basic helpers. This means that you should be familiar with the XML-RPC API and the XML formats returned by the OpenNebula core. As stated in the :ref:`XML-RPC documentation <api>`, you can download the :ref:`XML Schemas (XSD) here <api_xsd_reference>`.

API Documentation
================================================================================

You can consult the `doc online </doc/5.13/oca/ruby/>`__.

Usage
================================================================================

You can use the Ruby OCA included in the OpenNebula distribution by adding the OpenNebula Ruby library path to the search path:

.. code-block:: ruby

    ##############################################################################
    # Environment Configuration
    ##############################################################################
    ONE_LOCATION=ENV["ONE_LOCATION"]

    if !ONE_LOCATION
        RUBY_LIB_LOCATION="/usr/lib/one/ruby"
    else
        RUBY_LIB_LOCATION=ONE_LOCATION+"/lib/ruby"
    end

    $: << RUBY_LIB_LOCATION

    ##############################################################################
    # Required libraries
    ##############################################################################
    require 'opennebula'

Code Sample: Shutdown all the VMs of the Pool
================================================================================

This is a small code snippet. As you can see, the code flow would be as follows:

-  Create a new Client, setting up the authorization string. You only need to create it once.
-  Get the VirtualMachine pool that contains the VirtualMachines owned by this User.
-  You can perform “actions” over these objects right away, like ``myVNet.delete();``. In this example all the VirtualMachines will be shut down.

.. code-block:: ruby

    #!/usr/bin/env ruby
     
    ##############################################################################
    # Environment Configuration
    ##############################################################################
    ONE_LOCATION=ENV["ONE_LOCATION"]
     
    if !ONE_LOCATION
        RUBY_LIB_LOCATION="/usr/lib/one/ruby"
    else
        RUBY_LIB_LOCATION=ONE_LOCATION+"/lib/ruby"
    end
     
    $: << RUBY_LIB_LOCATION
     
    ##############################################################################
    # Required libraries
    ##############################################################################
    require 'opennebula'
     
    include OpenNebula
     
    # OpenNebula credentials
    CREDENTIALS = "oneuser:onepass"
    # XML_RPC endpoint where OpenNebula is listening
    ENDPOINT    = "http://localhost:2633/RPC2"
     
    client = Client.new(CREDENTIALS, ENDPOINT)
     
    vm_pool = VirtualMachinePool.new(client, -1)
     
    rc = vm_pool.info
    if OpenNebula.is_error?(rc)
         puts rc.message
         exit -1
    end
     
    vm_pool.each do |vm|
         rc = vm.shutdown
         if OpenNebula.is_error?(rc)
              puts "Virtual Machine #{vm.id}: #{rc.message}"
         else
              puts "Virtual Machine #{vm.id}: Shutting down"
         end
    end
     
    exit 0

Code Sample: Create a new Virtual Network
================================================================================

.. code-block:: ruby

    #!/usr/bin/env ruby
     
    ##############################################################################
    # Environment Configuration
    ##############################################################################
    ONE_LOCATION=ENV["ONE_LOCATION"]
     
    if !ONE_LOCATION
        RUBY_LIB_LOCATION="/usr/lib/one/ruby"
    else
        RUBY_LIB_LOCATION=ONE_LOCATION+"/lib/ruby"
    end
     
    $: << RUBY_LIB_LOCATION
     
    ##############################################################################
    # Required libraries
    ##############################################################################
    require 'opennebula'
     
    include OpenNebula
     
    # OpenNebula credentials
    CREDENTIALS = "oneuser:onepass"
    # XML_RPC endpoint where OpenNebula is listening
    ENDPOINT    = "http://localhost:2633/RPC2"
     
    client = Client.new(CREDENTIALS, ENDPOINT)
     
    template = <<-EOT
    NAME    = "Red LAN"
     
    # Now we'll use the host private network (physical)
    BRIDGE  = vbr0
     
    # Custom Attributes to be used in Context
    GATEWAY = 192.168.0.1
    DNS     = 192.168.0.1
     
    LOAD_BALANCER = 192.168.0.3

    AR = [
        TYPE = IP4,
        IP   = 192.168.0.1,
        SIZE = 255
    ]
    EOT
     
    xml = OpenNebula::VirtualNetwork.build_xml
    vn  = OpenNebula::VirtualNetwork.new(xml, client)
     
    rc = vn.allocate(template)
    if OpenNebula.is_error?(rc)
        STDERR.puts rc.message
        exit(-1)
    else
        puts "ID: #{vn.id.to_s}"
    end
     
    puts "Before info:"
    puts vn.to_xml
     
    puts
     
    vn.info
     
    puts "After info:"
    puts vn.to_xml

