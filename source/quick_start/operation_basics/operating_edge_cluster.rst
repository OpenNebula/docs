.. _operating_edge_cluster:

================================================================================
Operating an Edge Cluster
================================================================================

* Requirement Edge Cluster provisioned
* Describe the OpenNebula resources that form an edge cluster: cluster, hosts...

Cluster
================================================================================
* What is an OpenNebula cluster? Purpose?
* Show the OpenNebula cluster created with the provision and the associated resources: hosts, datastores etc...
* Link to full operation guide for advance usage

Hosts
================================================================================
* What is an OpenNebula host? Purpose?
* Hosts used in the ec (drivers = qemu)
* Show one host and basic information, status on, monitor metrics...
* Basic operation offline/enable
* Link to full operation guide for advance usage

Datastores
================================================================================
* What is an OpenNebula datastore? Purpose?
* Datastore used in ec (drivers = ssh + replica). Default = shared, Image+System = per ec
* Show datastores and basic information, status on, monitor metrics...
* Link to full operation guide for advance usage

Virtual Networks: Public
================================================================================
* What is an OpenNebula Network? Purpose?
* Show the public network created an characteristic. Leases etc...
* Show how to add more elastic IP's to the provision
* Link to full operation guide for advance usage

Virtual Networks: Private
================================================================================
* What is an OpenNebula Network Template? Purpose?
* Show the network template created an characteristic. driver VLXAN - BGP EVPN
* Show how to create a private network instantiating the template
* Link to full operation guide for advance usage
