.. _running_applicatoins:

====================
Running Applications
====================

We can now deploy virtual machines on those hosts. You just need to download and app from the marketplace, store it in the image datastore and instantiate it:

- Export the image from the marketplace

.. prompt:: bash $ auto

    $ onemarketapp export "Alpine Linux 3.11" "Alpine" -d 116
    IMAGE
        ID: 0
    VMTEMPLATE
        ID: 0

- Update the VM template to add the virtual networks

.. prompt:: bash $ auto

    $ ontemplate update 0
    NIC = [
        NETWORK = "PacketCluster-private",
        NETWORK_UNAME = "oneadmin",
        SECURITY_GROUPS = "0" ]
    NIC = [
        NETWORK = "PacketCluster-private-host-only",
        NETWORK_UNAME = "oneadmin",
        SECURITY_GROUPS = "0" ]
    NIC_ALIAS = [
        EXTERNAL= "YES",
        NETWORK = "PacketCluster-public",
        NETWORK_UNAME = "oneadmin",
        PARENT = "NIC1",
        SECURITY_GROUPS = "0" ]
    NIC_DEFAULT = [
        MODEL = "virtio" ]

- Instantiate the VM template

.. prompt:: bash $ auto

    $ onetemplate instantiate 0 -m 2

- Check ssh over public

.. prompt:: bash $ auto

    $ ssh root@147.75.81.25
    Warning: Permanently added '147.75.81.25' (ECDSA) to the list of known hosts.
    localhost:~# ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
            valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
            valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 02:00:c0:a8:a0:03 brd ff:ff:ff:ff:ff:ff
        inet 192.168.160.3/24 scope global eth0
            valid_lft forever preferred_lft forever
        inet6 fe80::c0ff:fea8:a003/64 scope link
            valid_lft forever preferred_lft forever
    3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 02:00:c0:a8:96:03 brd ff:ff:ff:ff:ff:ff
        inet 192.168.150.3/24 scope global eth1
            valid_lft forever preferred_lft forever
        inet6 fe80::c0ff:fea8:9603/64 scope link
            valid_lft forever preferred_lft forever
