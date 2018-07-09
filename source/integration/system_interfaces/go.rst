.. _go:

================================================================================
Go OpenNebula Cloud API
================================================================================

This page contains the OpenNebula Cloud API Specification for Go. It has been designed as a wrapper for the :ref:`XML-RPC methods <api>`, with some basic helpers. This means that you should be familiar with the XML-RPC API and the XML formats returned by the OpenNebula core. As stated in the :ref:`XML-RPC documentation <api>`, you can download the :ref:`XML Schemas (XSD) here <api_xsd_reference>`.

Go OpenNebula Cloud API cover the resources lists below:

+--------------+----------------------------------------------------------------------------------------------------------------+
|   Resource   | URL                                                                                                            |
+==============+================================================================================================================+
| ACL          | `acl.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/acl.go>`__                          |
+--------------+----------------------------------------------------------------------------------------------------------------+
| Cluster      | `cluster.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/cluster.go>`__                  |
+--------------+----------------------------------------------------------------------------------------------------------------+
| Datastore    | `datastore.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/datastore.go>`__              |
+--------------+----------------------------------------------------------------------------------------------------------------+
| Document     | `document.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/document.go>`__                |
+--------------+----------------------------------------------------------------------------------------------------------------+
| Group        | `group.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/group.go>`__                      |
+--------------+----------------------------------------------------------------------------------------------------------------+
| Host         | `host.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/host.go>`__                        |
+--------------+----------------------------------------------------------------------------------------------------------------+
| Image        | `image.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/image.go>`__                      |
+--------------+----------------------------------------------------------------------------------------------------------------+
| Template     | `template.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/template.go>`__                |
+--------------+----------------------------------------------------------------------------------------------------------------+
| User         | `user.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/user.go>`__                        |
+--------------+----------------------------------------------------------------------------------------------------------------+
| VDC          | `vdc.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/vdc.go>`__                          |
+--------------+----------------------------------------------------------------------------------------------------------------+
| Vnet         | `virtualnetwork.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/virtualnetwork.go>`__    |
+--------------+----------------------------------------------------------------------------------------------------------------+
| VMs          | `vm.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/vm.go>`__                            |
+--------------+----------------------------------------------------------------------------------------------------------------+
| Zone         | `zone.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/zone.go>`__                        |
+--------------+----------------------------------------------------------------------------------------------------------------+

Download
================================================================================

The source code can be downloaded from the OpenNebula `repository <https://github.com/OpenNebula/one/tree/master/src/oca/go>`__.

Usage
================================================================================

To use the OpenNebula Cloud API for Go in your Go project, you have to import goca at your project as the example below and make a ``go get``.

Code Sample
================================================================================

The example below show how get the information of a running VM, print its name, and power it off. It then builds a new OpenNebula template and prints its string representation.

.. code-block:: go

    package main

    import (
        "fmt"
        "github.com/OpenNebula/one/src/oca/go/src/goca"
        "log"
        "os"
        "strconv"
    )

    func main() {
        id, _ := strconv.Atoi(os.Args[1])

        vm := goca.NewVM(uint(id))

        err := vm.Info()
        if err != nil {
            log.Fatal(err)
        }

        name, _ := vm.XPath("/VM/NAME")
        if err != nil {
            log.Fatal(err)
        }

        fmt.Println(name)

        // Poweroff the VM
        err = vm.PoweroffHard()
        if err != nil {
            log.Fatal(err)
        }

        // Create a new Template
        template := goca.NewTemplateBuilder()

        template.AddValue("cpu", 1)
        template.AddValue("memory", "64")
        vector := template.NewVector("disk")
        vector.AddValue("image_id", "119")
        vector.AddValue("dev_prefix", "vd")
        vector = template.NewVector("nic")
        vector.AddValue("network_id", "3")
        vector.AddValue("model", "virtio")
        template.AddValue("vcpu", "2")

        fmt.Println(template)
    }

Limitations

Go OpenNebula Cloud API doesn't cover the resources list below:

+----------------------+--------------------------------------------------------------------------------------------------------+
|   Resource           | URL                                                                                                    |
+======================+========================================================================================================+
| Marketplace          | http://docs.opennebula.org/5.6/integration/system_interfaces/api.html#onemarket                        |
+----------------------+--------------------------------------------------------------------------------------------------------+
| Marketapp            | http://docs.opennebula.org/5.6/integration/system_interfaces/api.html#onemarketapp                     |
+----------------------+--------------------------------------------------------------------------------------------------------+
| Security Groups      | http://docs.opennebula.org/5.6/integration/system_interfaces/api.html#onesecgroup                      |
+----------------------+--------------------------------------------------------------------------------------------------------+
| VM Groups            | http://docs.opennebula.org/5.6/integration/system_interfaces/api.html#onevmgroup                       |
+----------------------+--------------------------------------------------------------------------------------------------------+
| Virtual Router       | http://docs.opennebula.org/5.6/integration/system_interfaces/api.html#onevrouter                       |
+----------------------+--------------------------------------------------------------------------------------------------------+
