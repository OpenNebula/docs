.. _devel-provider:

================================================================================
Edge Cluster Providers
================================================================================

An Edge Cluster provider is responsible to interface with the Cloud or Edge provider to provision the Edge cluster resources including hosts, public IPs or any other abstraction required to support the cluster. Note that the specific artifacts needed depended on the features and capabilities of each provider.

.. important:: THIS SECTION IS UNDERWORK

Terraform Representation
================================================================================

The first step is to develop a representation of the Edge Cluster using Terraform. OpenNebula will use the Terraform driver for the target provider to provision the Edge Cluster infrastructure.

Step 1. Register the Provider
--------------------------------------------------------------------------------

* Add to the list of PROVIDERS in `src/oneprovision/lib/terraform/terraform.rb <https://github.com/OpenNebula/one/blob/master/src/oneprovision/lib/terraform/terraform.rb>`__.
* Add base class to interface the new provider. It should be located in `src/oneprovision/lib/terraform/providers/ <https://github.com/OpenNebula/one/blob/master/src/oneprovision/lib/terraform/providers>`__.
* Require the new provider in `src/oneprovision/lib/terraform/providers.rb <https://github.com/OpenNebula/one/blob/master/src/oneprovision/lib/terraform/providers.rb>`__.
* We need to modify the file `src/oneprovision/lib/terraform/terraform.rb <https://github.com/OpenNebula/one/blob/master/src/oneprovision/lib/terraform/terraform.rb>`__:

  * Add the new class to the singleton method ``self.singleton``:

  .. prompt:: bash $ auto

        when 'my_provider'
        tf_class = MyProvider

  * Add new provider keys to the method ``self.check_connection``:

  .. prompt:: bash $ auto

        when 'my_provider'
        keys = MyProvider::KEY

Step 2. Create Terraform templates for each resource
--------------------------------------------------------------------------------

Templates use `ERB <https://docs.ruby-lang.org/en/2.5.0/ERB.html>`__ template syntax.

* Templates are located ``src/oneprovision/lib/terraform/providers/templates/``. It contains the following templates:

  * **provider.erb**: this template defines the Terraform provider, each provider needs specific information. This information is passed using the ``conn`` attribute, so inside this hash, all the information will be available. The connection information is taken from the provider stored in the OpenNebula database.
  * **resource_x.erb**: this template defines the specific x (cluster, datastore, host, network) resource for the Terraform provider. The information needed by these templates is passed using the following attributes:

    * **obj**: it contains the OpenNebula object information in hash format.
    * **provision**: it contains provision information passed in the provision template under the provision section.
    * **c**: it contains information about the OpenNebula cluster.
    * **obj['user_data']**: it is a special value that contains the user data that should be added to the hosts, it basically contains the public SSH key to access them.

In the following example you can find a detailed description of AWS templates:

* **provider.erb**

.. prompt:: bash $ auto

    provider "aws" {
        access_key = "<%= conn['ACCESS_KEY'] %>"
        secret_key = "<%= conn['SECRET_KEY'] %>"
        region     = "<%= conn['REGION'] %>"
    }

The information here depends on the Terraform provider, you will have all the needed information in ``conn`` hash.

* **cluster.erb**

.. prompt:: bash $ auto

    resource "aws_vpc" "device_<%= obj['ID'] %>" {
        cidr_block = "<%= provision['CIDR'] ? provision['CIDR'] : '10.0.0.0/16'%>"

        tags = {
            Name = "<%= obj['NAME'] %>_vpc"
        }
    }

    resource "aws_subnet" "device_<%= obj['ID'] %>" {
        vpc_id     = aws_vpc.device_<%= obj['ID'] %>.id
        cidr_block = "<%= provision['CIDR'] ? provision['CIDR'] : '10.0.0.0/16'%>"

        map_public_ip_on_launch = true

        tags = {
            Name = "<%= obj['NAME'] %>_subnet"
        }
    }

    resource "aws_internet_gateway" "device_<%= obj['ID'] %>" {
        vpc_id = aws_vpc.device_<%= obj['ID'] %>.id

        tags = {
            Name = "<%= obj['NAME'] %>_gateway"
        }
    }

    resource "aws_route" "device_<%= obj['ID'] %>" {
        route_table_id         = aws_vpc.device_<%= obj['ID'] %>.main_route_table_id
        destination_cidr_block = "0.0.0.0/0"
        gateway_id             = aws_internet_gateway.device_<%= obj['ID'] %>.id
    }

    resource "aws_security_group" "device_<%= obj['ID'] %>_all" {
        name        = "allow_all"
        description = "Allow all traffic"
        vpc_id     = aws_vpc.device_<%= c['ID'] %>.id

        ingress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }

        egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }

        tags = {
            Name = "device_<%= obj['ID'] %>_all"
        }
    }

The resources created here are associated to OpenNebula cluster, so when it is deleted, they are deleted too. You can use the ``obj`` hash to access resource attributes. You can also create a relation between Terraform resources using the information stored at ``obj``. If you need to create a relation, between the object and the OpenNebula cluster, you can use the variable ``c`` which is a hash containing all the information of the OpenNebula cluster.

.. important:: All the terraform resources must be named by device_OBJ['ID'].

Step 3. Install the Provider
--------------------------------------------------------------------------------

You need to modify `install.sh <https://github.com/OpenNebula/one/blob/master/src/install.sh>`__:

* Add to ``INSTALL_ONEPROVISION_FILES``:

.. prompt:: bash $ auto

    ONEPROVISION_LIB_MY_PROVIDER_ERB_FILES:$LIB_LOCATION/oneprovision/lib/terraform/providers/templates/my_provider

* Add to ``ONEPROVISION_LIB_PROVIDERS_FILES``:

.. prompt:: bash $ auto

    src/oneprovision/lib/terraform/providers/my_provider.rb

* You have to add the following lines:

.. prompt:: bash $ auto

    ONEPROVISION_LIB_MY_PROVIDER_ERB_FILES="src/oneprovision/lib/terraform/providers/templates/my_provider/cluster.erb \
                                            src/oneprovision/lib/terraform/providers/templates/my_provider/datastore.erb \
                                            src/oneprovision/lib/terraform/providers/templates/my_provider/host.erb \
                                            src/oneprovision/lib/terraform/providers/templates/my_provider/network.erb \
                                            src/oneprovision/lib/terraform/providers/templates/my_provider/provider.erb"

* Add to ``LIB_DIRS``:

.. prompt:: bash $ auto

    $LIB_LOCATION/oneprovision/lib/terraform/providers/templates/my_provider

Ansible Configuration
================================================================================

Then you need to add an ansible playbook for the provisions created on the new provider. As an starting point you can use one of the existing ones.

* They are located in `share/oneprovision/ansible <https://github.com/OpenNebula/one/blob/master/share/oneprovision/ansible>`__. You can find documentation about them :ref:`here <ddc_config_playbooks>`.
* In order to add a new role, you need to place it in `share/oneprovision/ansible/roles <https://github.com/OpenNebula/one/blob/master/share/oneprovision/ansible/roles>`__ and then add it to the playbook you want to use it.

In the following example you can find a detailed description of AWS template:

The YAML describes the configuration roles that are use in AWS cluster:

.. prompt:: bash $ auto

    $ cat share/oneprovision/ansible/aws.yml
    ---

    - hosts: all
      gather_facts: false
      roles:
        - python

    - hosts: nodes
      roles:
        - ddc
        - opennebula-repository
        - { role: opennebula-node-kvm, when: oneprovision_hypervisor == 'kvm'  or oneprovision_hypervisor == 'qemu' }
        - { role: opennebula-node-firecracker, when: oneprovision_hypervisor == 'firecracker' }
        - { role: opennebula-node-lxc, when: oneprovision_hypervisor == 'lxc' }
        - opennebula-ssh
        - role: iptables
          iptables_base_rules_services:
            - { protocol: 'tcp', port: 22 }
            # TCP/179 bgpd (TODO: only needed on Route Refector(s))
            - { protocol: 'tcp', port: 179 }
            # TCP/8742 default VXLAN port on Linux (UDP/4789 default IANA)
            - { protocol: 'udp', port: 8472 }
        - update-replica
        - role: frr
          frr_iface: 'eth0'
          # Use /16 for the internal management network address
          frr_prefix_length: 16

Above you can find the list of roles that are going to be executed. Also, some of the roles depends on some variables, these variables come from the provision itself.

Provision Templates
================================================================================

Finally you need to add templates for the provisions on the new provider. They are located in ``share/oneprovision/edge-clusters/<type>/provisions``. You can find documentation about them :ref:`here <ddc_template>`.

In the following example you can find a detailed description of AWS template:

The YAMLs describe the elements that are going to be deployed in the provision:

.. prompt:: bash $ auto

    $ cat share/oneprovision/edge-clusters/virtual/provisions/aws.yml
    ---
    #-------------------------------------------------------------------------------
    # This is the canonical description file for a cluster build with 'AWS'
    # resources using the KVM hypervisor.
    # ------------------------------------------------------------------------------

    name: 'aws-cluster'

    extends:
        - common.d/defaults.yml
        - common.d/resources.yml
        - common.d/hosts.yml
        - aws.d/datastores.yml
        - aws.d/fireedge.yml
        - aws.d/inputs.yml
        - aws.d/networks.yml

    #-------------------------------------------------------------------------------
    # playbook: Ansible playbook used for hosts configuration. Check ansible/aws.yml
    # for the specific roles applied.
    #-------------------------------------------------------------------------------
    playbook:
      - aws

    #-------------------------------------------------------------------------------
    # defaults: Common configuration attributes for provision objects
    #--------------------------------------------------------------------------------
    defaults:
    provision:
        provider_name: 'aws'
        ami: "${input.aws_ami_image}"
        instancetype: "${input.aws_instance_type}"
        cloud_init: true
    connection:
        remote_user: 'centos'

    #-------------------------------------------------------------------------------
    # cluster: Parameters for the OpenNebula cluster. Applies to all the Hosts
    #--------------------------------------------------------------------------------
    #  name: of the cluster
    #  description: Additional information
    #  reserved_cpu: In percentage. It will be subtracted from the TOTAL CPU
    #  reserved_memory: In percentage. It will be subtracted from the TOTAL MEM
    #--------------------------------------------------------------------------------
    cluster:
      name: "${provision}"
      description: 'AWS virtual edge cluster'
      reserved_cpu: '0'
      reserved_mem: '0'
      datastores:
        - 1
        - 2
      provision:
        cidr: '10.0.0.0/16'

    #-------------------------------------------------------------------------------
    # AWS provision parameters.
    #-------------------------------------------------------------------------------
    # This section is used by provision drivers. DO NOT MODIFY IT
    #
    #   CIDR: Private IP block for the cluster. This value HAS TO MATCH that on
    #   cluster.
    #-------------------------------------------------------------------------------
    aws_configuration:
        cidr: '10.0.0.0/16'

    ...

Then in the following folder you cand find specifics things about this provider:

.. prompt:: bash $ auto

    cat share/oneprovision/edge-clusters/virtual/provisions/aws.d/*
    ---
    #-------------------------------------------------------------------------------
    # datastores: Defines the storage area for the cluster using the SSH replication
    # drivers. It creates the following datastores, using Replica driver:
    #   1. Image datastore, ${cluster_name}-image
    #   2. System datastore, ${cluster_name}-system
    #
    # Configuration/Input attributes:
    #   - replica_host: The host that will hold the cluster replicas and snapshots.
    #-------------------------------------------------------------------------------
    datastores:

      - name: "${provision}-image"
        type: 'image_ds'
        ds_mad: 'fs'
        tm_mad: 'ssh'
        safe_dirs: "/var/tmp /tmp"

      - name: "${provision}-system"
        type: 'system_ds'
        tm_mad: 'ssh'
        safe_dirs: "/var/tmp /tmp"
        replica_host: "use-first-host"
    ---
    image: 'OPENNEBULA-AWS'
    provider: 'aws'
    provision_type: 'virtual'
    ---
    inputs:
      - name: 'number_hosts'
        type: text
        description: 'Number of AWS instances to create'
        default: '1'

      - name: 'number_public_ips'
        type: text
        description: 'Number of public IPs to get'
        default: '1'

      - name: 'dns'
        type: text
        description: 'Comma separated list of DNS servers for public network'
        default: '1.1.1.1'

      - name: 'aws_ami_image'
        type: text
        description: "AWS ami image used for host deployments"
        default: ''

      - name: 'aws_instance_type'
        type: text
        description: "AWS instance type, use virtual instances"
        default: ''

      - name: 'one_hypervisor'
        type: list
        description: "Virtualization technology for the cluster hosts"
        default: 'lxc'
        options:
            - 'qemu'
            - 'lxc'
    ...
    ---
    networks:
      - name: "${provision}-public"
        vn_mad: 'elastic'
        bridge: 'br0'
        netrole: 'public'
        dns: "${input.dns}"
        provision:
        count: "${input.number_public_ips}"
        ar:
          - provison_id: "${provision_id}"
            size: '1'
            ipam_mad: 'aws'

    vntemplates:
      - name: "${provision}-private"
        vn_mad: 'vxlan'
        phydev: 'eth0'
        automatic_vlan_id: 'yes'
        netrole: 'private'
        vxlan_mode: 'evpn'
        vxlan_tep: 'dev'
        ip_link_conf: 'nolearning='
        cluster_ids: "${cluster.0.id}"

Finally, you can find a common directory for all the providers:

.. prompt:: bash $ auto

    cat share/oneprovision/edge-clusters/virtual/provisions/common.d/*
    ---
    #-------------------------------------------------------------------------------
    # defaults: Common configuration attributes for provision objects
    #--------------------------------------------------------------------------------

    defaults:
      configuration:
        # Select the hypervisor package to install
        oneprovision_hypervisor: "${input.one_hypervisor}"

        # required for copying recovery VM snaphosts to the replica host
        opennebula_ssh_deploy_private_key: true

        # Options to enable nested virtualization used for QEMU/KVM
        opennebula_node_kvm_use_ev: true

        opennebula_node_kvm_param_nested: True

        opennebula_node_kvm_manage_kvm: False
    ---
    #-------------------------------------------------------------------------------
    # hosts: AWS, Digital Ocean or Google servers
    # provision:
    #   - count: Number of servers to create
    #   - hostname: edge-vhost1, edge-vhost2 .... of the server
    #
    # You can define specific OpenNebula configuration attributes for all the hosts:
    #    - reserved_cpu: In percentage. It will be subtracted from the TOTAL CPU
    #    - reserved_memory: In percentage. It will be subtracted from the TOTAL MEM
    #-------------------------------------------------------------------------------
    hosts:

      - im_mad: "${input.one_hypervisor}"
        vm_mad: "${input.one_hypervisor}"
        provision:
        count: "${input.number_hosts}"
        hostname: "edge-vhost${index}"
    ...
