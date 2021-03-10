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
| Security Group   | `service_template.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/securitygroup.go>`__   |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Service          | `service.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/service.go>`__                  |
+------------------+----------------------------------------------------------------------------------------------------------------+
| Service Template | `service_template.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/service_template.go>`__|
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
| VM Groups        | `vmgroup.go <https://github.com/OpenNebula/one/blob/master/src/oca/go/src/goca/vmgroup.go>`__                  |
+------------------+----------------------------------------------------------------------------------------------------------------+
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

The example below shows how to poweroff a running VM. You need to pass the VM ID argument to the program.

.. code-block:: go

    package main

    import (
        "fmt"
        "log"
        "os"
        "strconv"

        "github.com/OpenNebula/one/src/oca/go/src/goca"
    )

    func main() {
        // Initialize connection with OpenNebula
        con := map[string]string{
            "user":     "user",
            "password": "password",
            "endpoint": "XMLRPC address",
        }

        client := goca.NewDefaultClient(
            goca.NewConfig(con["user"], con["password"], con["endpoint"]),
        )

        controller := goca.NewController(client)

        // Read VM ID from arguments
        id, _ := strconv.Atoi(os.Args[1])

        vmctrl := controller.VM(id)

        // Fetch informations of the created VM
        vm, err := vmctrl.Info(false)

        if err != nil {
            log.Fatal(err)
        }

        fmt.Printf("Shutting down %+v\n", vm.Name)

        // Poweroff the VM
        err = vmctrl.Poweroff()
        if err != nil {
            log.Fatal(err)
        }

    }


Take a look at these `examples <https://github.com/OpenNebula/one/tree/master/src/oca/go/share/examples>`__ in order to get a more in-depth usage of GOCA.

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
It's possible to use another client or enhance the basic client with Goca if it implements the RPCCaller interface.

