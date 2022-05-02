.. _onprem_provider:

================================================================================
On-Premises Provider
================================================================================

The ``onprem`` provider is a convenient abstraction to represent your local resources. This provider can be used to automatically configure and install OpenNebula clusters using your on-premises servers. It needs no special configuration as it will retrieve the FQDNs or IP addresses of the hosts while creating the provisions.

How to Create the On-Premises Provider
================================================================================

You just need to create the on-premises provider once, simply run the following command:

.. prompt:: bash $ auto

    $ oneprovider create /usr/share/one/oneprovision/edge-clusters/metal/providers/onprem/onprem.yml

The ``onprem`` provider can also be shown by running the command below:

.. prompt:: bash $ auto

    $ oneprovider show onprem
    PROVIDER 0 INFORMATION
    ID   : 0
    NAME : onprem

.. note:: OpenNebula front-end node requires ssh root access to the hosts that are going to be configured using ``onprem`` provider.
