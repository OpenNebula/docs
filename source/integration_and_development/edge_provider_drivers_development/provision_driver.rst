.. _devel-provider:

================================================================================
Edge Cluster Providers
================================================================================

An Edge Cluster provider is responsible to interface with the Cloud or Edge provider to provision the Edge cluster resources including hosts, public IPs or any other abstraction required to support the cluster. Note that the specific artifacts needed depended on the features and capabilities of each provider.

Terraform Representation
================================================================================

First you need to provide a representation of the Edge Cluster using Terraform. OpenNebula will use the Terraform driver for the target provider to provision the Edge Cluster infrastructure.

Step 1. Register the Provider
--------------------------------------------------------------------------------

Create a new Ruby file, named after you desired provider name (lowercase) and `.rb` extension, in the providers folder ``/usr/lib/one/oneprovision/lib/terraform/providers``. You can use as template the following example located in `src/oneprovision/lib/terraform/providers/example <https://github.com/OpenNebula/one/blob/master/src/oneprovision/lib/terraform/providers/example>`__:

.. prompt:: bash $ auto

    require 'terraform/terraform'

    # Module OneProvision
    module OneProvision

        # <<PROVIDER NAME>> Terraform Provider
        class <<PROVIDER CLASS>> < Terraform

            NAME = Terraform.append_provider(__FILE__, name)

            # OpenNebula - Terraform equivalence
            TYPES = {
                :cluster   => '<<TERRAFORM RESOURCE>>',
                :datastore => '<<TERRAFORM RESOURCE>>',
                :host      => '<<TERRAFORM RESOURCE>>',
                :network   => '<<TERRAFORM RESOURCE>>'
            }

            # These are the keys needed by the terraform provider configuration
            KEYS = %w[<<PROPVIDER CONNECTION INFO>>]

            # Class constructor
            #
            # @param provider [Provider]
            # @param state    [String] Terraform state in base64
            # @param conf     [String] Terraform config state in base64
            def initialize(provider, state, conf)
                # If credentials are stored into a file, set this variable to true
                # If not, leave it as it is
                @file_credentials = false

                super
            end

            # Get user data to add into the VM
            #
            # @param ssh_key [String] SSH keys to add
            def user_data(ssh_key)
                <<IMPLEMENT THIS METHOD IF NEEDED, IF NOT YOU CAN DELETE IT>>
            end

        end

    end

Step 2. Create Terraform templates for each resource
--------------------------------------------------------------------------------

Templates use `ERB <https://docs.ruby-lang.org/en/2.5.0/ERB.html>`__ syntax.

.. important:: The name of the folder must be the same used for the class file created above (without .rb), e.g: if the file is called my_provider.rb, the folder should be my_provider.

* Templates are placed in ``/usr/lib/one/oneprovision/lib/terraform/providers/templates/<provider_name>/``:

  * **provider.erb**: defines the Terraform provider, each provider needs specific information. This is passed to the ERB in ``conn`` hash attribute. It is read from the YAML configuration file when the provider is created (``connection:`` hash), e.g:

    .. prompt:: bash $ auto

        provider "aws" {
            access_key = "<%= conn['ACCESS_KEY'] %>"
            secret_key = "<%= conn['SECRET_KEY'] %>"
            region     = "<%= conn['REGION'] %>"
        }

    .. note:: This information depends on the Terraform provider.

  * **resource_<type>.erb**: defines the specific type (cluster, datastore, host, network) resource for the Terraform provider. The following attributes are available:

    * **obj**: contains the OpenNebula object information in hash format.
    * **provision**: contains provision information located in the object XML under ``TEMPLATE/PROVISION``.
    * **c**: contains information about the OpenNebula cluster. It is useful to create a realation between the object and the cluster.
    * **obj['user_data']**: special value that contains the user data that should be added to the hosts, it basically contains the public SSH key to access them.

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

.. important:: All the terraform resources must be named by device_OBJ['ID'].

Ansible Playbooks
================================================================================

You need to add an ansible playbook to configure physical servers running on the provider.

.. note:: You can use existing playbooks as an example.

* They are placed in `/usr/share/one/oneprovision/ansible <https://github.com/OpenNebula/one/blob/master/share/oneprovision/ansible>`__. You can find documentation about them :ref:`here <ddc_config_playbooks>`.
* To add a new role, you need to place it in `/usr/share/one/oneprovision/ansible/roles <https://github.com/OpenNebula/one/blob/master/share/oneprovision/ansible/roles>`__.

Provision Templates
================================================================================

You need to add templates to create your provider instances as well as the edge cluster in the provider.

* They are placed in ``/usr/share/one/oneprovision/edge-clusters/<type>/provisions/<provider_name>``. You can find documentation about them :ref:`here <ddc_template>`.
* ``<provider_name>.yml`` contains the global cluster definition, e.g:

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

* Inside ``<provider_name>.d`` directory you can place specifics things about the provider, e.g:

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
        safe_dirs: "/var/tmp
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

* ``commond.d`` contains common information for all the providers, e.g:

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
