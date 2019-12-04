.. _go:

================================================================================
Go OpenNebula Cloud API
================================================================================

This page contains the OpenNebula Cloud API Specification for Go. It has been designed as a wrapper for the :ref:`XML-RPC methods <api>`, with some basic helpers. This means that you should be familiar with the XML-RPC API and the XML formats returned by the OpenNebula core. As stated in the :ref:`XML-RPC documentation <api>`, you can download the :ref:`XML Schemas (XSD) here <api_xsd_reference>`.

Go OpenNebula Cloud API cover the resources lists below:

+------------------+----------------------------------------------------------------------------------------------------------------+
|   Resource       | URL                                                                                                            |
+==================+================================================================================================================+
| ACL              | `acl.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/acl.go>`__                          |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Cluster          | `cluster.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/cluster.go>`__                  |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Datastore        | `datastore.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/datastore.go>`__              |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Document         | `document.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/document.go>`__                |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Group            | `group.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/group.go>`__                      |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Host             | `host.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/host.go>`__                        |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Hook             | `hook.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/hook.go>`__                        |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Image            | `image.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/image.go>`__                      |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Market Place     | `marketplace.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/marketplace.go>`__          |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Market Place App | `marketplaceapp.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/marketplaceapp.go>`__    |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Template         | `template.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/template.go>`__                |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Security Group   | `securitygroup.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/security_group.go>`__     |
+------------------+----------------------------------------------------------------------------------------------------------------+
| User             | `user.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/user.go>`__                        |
+------------------+----------------------------------------------------------------------------------------------------------------+
| VDC              | `vdc.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/vdc.go>`__                          |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Vnet             | `virtualnetwork.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/virtualnetwork.go>`__    |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Vrouter          | `virtualrouter.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/virtualrouter.go>`__      |
+------------------+----------------------------------------------------------------------------------------------------------------+
| VMs              | `vm.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/vm.go>`__                            |
+------------------+----------------------------------------------------------------------------------------------------------------+
| VM Groups        | `vmgroup.go <http://docs.opennebula.org/5.11/integration/system_interfaces/api.html#onevmgroup>`__             |
+----------------------+------------------------------------------------------------------------------------------------------------+
| VN template      | `vntemplate.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/vntemplate.go>`__            |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Zone             | `zone.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/zone.go>`__                        |
+------------------+----------------------------------------------------------------------------------------------------------------+

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
        "log"
        "os"
        "strconv"

        "github.com/OpenNebula/one/src/oca/go/src/goca"
        "github.com/OpenNebula/one/src/oca/go/src/goca/schemas/shared"
        "github.com/OpenNebula/one/src/oca/go/src/goca/schemas/vm"
        "github.com/OpenNebula/one/src/oca/go/src/goca/schemas/vm/keys"
    )

    func main() {
        conf := goca.NewConfig("user", "password_or_token", "endpoint")

        client := goca.NewDefaultClient(conf)
        controller := goca.NewController(client)

        id, _ := strconv.Atoi(os.Args[1])

        vm, err := controller.VM(uint(id)).Info()
        if err != nil {
            log.Fatal(err)
        }

        fmt.Println(vm.Name)

        // Poweroff the VM
        err = vm.PoweroffHard()
        if err != nil {
            log.Fatal(err)
        }

        // Create a new Template
        tpl := vm.NewTemplate()
        tpl.CPU(1)
        tpl.Memory(64)
        tpl.VCPU(2)

        disk := tpl.AddDisk()
        disk.Add(shared.ImageID, "119")
        disk.Add(shared.DevPrefix, "vd")

        nic := tpl.AddNIC()
        nic.Add(shared.NetworkID, "3")
        nic.Add(shared.Model, "virtio")

        fmt.Println(template)
    }

To see more, take at these `examples <https://github.com/OpenNebula/one/tree/master/src/oca/go/share/examples>`__.

Error handling
================================================================================

In the file errors.go, two errors types are defined:
- ClientError: errors on client side implying that we can't have a complete and well formed OpenNebula response (request building, network errors ...).
- ResponseError: We have a well formed response, but there is an OpenNebula error (resource does not exists, can't perform the action, rights problems ...).

Each of theses types has several error codes allowing you fine grained error handling.
If we have an HTTP response, ClientError returns it.

Extend the client
================================================================================

The provided client is a basic XML-RPC client for OpenNebula, without any complex features.
It's possible to use an other client or enhance the basic client with Goca if it implements the RPCCaller interface.

