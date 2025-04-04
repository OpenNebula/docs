.. _monitor_alert_metrics:

================================================================================
Exporter Metrics
================================================================================

OpenNebula Exporter
================================================================================

.. list-table::
    :widths: auto
    :header-rows: 1

    * - Name
      - Description
      - Type
    * - ``opennebula_host_total``
      - Total number of hosts defined in OpenNebula
      - gauge
    * - ``opennebula_host_state``
      - Host state ``0``:init ``2``:monitored ``3``:error ``4``:disabled ``8``:offline
      - gauge
    * - ``opennebula_host_mem_total_bytes``
      - Total memory capacity
      - gauge
    * - ``opennebula_host_mem_maximum_bytes``
      - Total memory capacity considering overcommitment
      - gauge
    * - ``opennebula_host_mem_usage_bytes``
      - Total memory capacity allocated to VMs
      - gauge
    * - ``opennebula_host_cpu_total_ratio``
      - Total CPU capacity
      - gauge
    * - ``opennebula_host_cpu_maximum_ratio``
      - Total CPU capacity considering overcommitment
      - gauge
    * - ``opennebula_host_cpu_usage_ratio``
      - Total CPU capacity allocated to VMs
      - gauge
    * - ``opennebula_host_vms``
      - Number of VMs allocated to the host
      - gauge
    * - ``opennebula_datastore_total``
      - Total number of datastores defined in OpenNebula
      - gauge
    * - ``opennebula_datastore_total_bytes``
      - Total capacity of the datastore
      - gauge
    * - ``opennebula_datastore_used_bytes``
      - Capacity being used in the datastore
      - gauge
    * - ``opennebula_datastore_free_bytes``
      - Available capacity in the datastore
      - gauge
    * - ``opennebula_datastore_images``
      - Number of images stored in the datastore
      - gauge
    * - ``opennebula_vm_total``
      - Total number of VMs defined in OpenNebula
      - gauge
    * - ``opennebula_vm_host_id``
      - Host ID where the VM is allocated
      - gauge
    * - ``opennebula_vm_state``
      - VM state ``0``:init ``1``:pending ``2``:hold ``3``:active ``4``:stopped ``5``:suspended ``6``:done ``8``:poweroff ``9``:undeployed ``10``:cloning
      - gauge
    * - ``opennebula_vm_lcm_state``
      - VM LCM state, only relevant for state 3 (active)
      - gauge
    * - ``opennebula_vm_mem_total_bytes``
      - Total memory capacity
      - gauge
    * - ``opennebula_vm_cpu_ratio``
      - Total CPU capacity requested by the VM
      - gauge
    * - ``opennebula_vm_cpu_vcpus``
      - Total number of virtual CPUs
      - gauge
    * - ``opennebula_vm_disks``
      - Total number of disks
      - gauge
    * - ``opennebula_vm_disk_size_bytes``
      - Size of the VM disk
      - gauge
    * - ``opennebula_vm_nics``
      - Total number of network interfaces
      - gauge
    * - ``opennebula_oned_state``
      - OpenNebula oned service state ``0``:down ``1``:up
      - gauge
    * - ``opennebula_scheduler_state``
      - OpenNebula scheduler service state ``0``:down ``1``:up
      - gauge
    * - ``opennebula_flow_state``
      - OpenNebula Flow service state ``0``:down ``1``:up
      - gauge
    * - ``opennebula_hem_state``
      - OpenNebula hook manager service state ``0``:down ``1``:up
      - gauge
    * - ``opennebula_gate_state``
      - OpenNebula Gate service state ``0``:down ``1``:up
      - gauge

Libvirt Exporter
================================================================================

.. list-table::
    :widths: auto
    :header-rows: 1

    * - Name
      - Description
      - Type
    * - ``opennebula_libvirt_requests_total``
      - The total number of HTTP requests handled by the Rack application.
      - counter
    * - ``opennebula_libvirt_request_duration_seconds``
      - The HTTP response duration of the Rack application.
      - histogram
    * - ``opennebula_libvirt_exceptions_total``
      - The total number of exceptions raised by the Rack application.
      - counter
    * - ``opennebula_libvirt_state``
      - State of the domain ``0``:no_state, ``1``:running, ``2``:blocked, ``3``:paused, ``4``:shutdown, ``5``:shutoff, ``6``:crashed, ``7``:suspended (PM)
      - gauge
    * - ``opennebula_libvirt_cpu_seconds_total``
      - Total CPU time used by the domain
      - gauge
    * - ``opennebula_libvirt_cpu_system_seconds_total``
      - System CPU time used by the domain
      - gauge
    * - ``opennebula_libvirt_cpu_user_seconds_total``
      - User CPU time used by the domain
      - gauge
    * - ``opennebula_libvirt_memory_total_bytes``
      - Total memory currently used by the domain
      - gauge
    * - ``opennebula_libvirt_memory_maximum_bytes``
      - Total memory currently used by the domain
      - gauge
    * - ``opennebula_libvirt_memory_swapin_bytes_total``
      - Amount of data read from swap space
      - gauge
    * - ``opennebula_libvirt_memory_swapout_bytes_total``
      - Amount of data written out to swap space
      - gauge
    * - ``opennebula_libvirt_memory_unused_bytes``
      - Amount of memory left unused by the system
      - gauge
    * - ``opennebula_libvirt_memory_available_bytes``
      - Amount of usable memory as seen by the domain
      - gauge
    * - ``opennebula_libvirt_memory_rss_bytes``
      - Resident Set Size of running domain's process
      - gauge
    * - ``opennebula_libvirt_vcpu_online``
      - Current number of online virtual CPUs
      - gauge
    * - ``opennebula_libvirt_vcpu_maximum``
      - Maximum number of online virtual CPUs
      - gauge
    * - ``opennebula_libvirt_vcpu_state``
      - State of the virtual CPU ``0``:offline, ``1``:running, ``2``:blocked
      - gauge
    * - ``opennebula_libvirt_vcpu_time_seconds_total``
      - virtual cpu time spent by virtual CPU
      - gauge
    * - ``opennebula_libvirt_vcpu_wait_seconds_total``
      - Time the vCPU wants to run, but the host scheduler has something else running ahead of it
      - gauge
    * - ``opennebula_libvirt_net_devices``
      - Total number of network interfaces on this domain
      - gauge
    * - ``opennebula_libvirt_net_rx_total_bytes``
      - Total bytes received by the vNIC
      - gauge
    * - ``opennebula_libvirt_net_rx_packets``
      - Total number of packets received by the vNIC
      - gauge
    * - ``opennebula_libvirt_net_rx_errors``
      - Total number of receive errors
      - gauge
    * - ``opennebula_libvirt_net_rx_drops``
      - Total number of receive packets dropped by the vNIC
      - gauge
    * - ``opennebula_libvirt_net_tx_total_bytes``
      - Total bytes transmitted by the vNIC
      - gauge
    * - ``opennebula_libvirt_net_tx_packets``
      - Total number of packets transmitted by the vNIC
      - gauge
    * - ``opennebula_libvirt_net_tx_errors``
      - Total number of transmission errors
      - gauge
    * - ``opennebula_libvirt_net_tx_drops``
      - Total number of transmit packets dropped by the vNIC
      - gauge
    * - ``opennebula_libvirt_block_devices``
      - Total number of block devices on this domain
      - gauge
    * - ``opennebula_libvirt_block_rd_requests``
      - Total number of read requests
      - gauge
    * - ``opennebula_libvirt_block_rd_bytes``
      - Total number of read bytes
      - gauge
    * - ``opennebula_libvirt_block_rd_time_seconds``
      - Total time spent on reads
      - gauge
    * - ``opennebula_libvirt_block_wr_requests``
      - Total number of write requests
      - gauge
    * - ``opennebula_libvirt_block_wr_bytes``
      - Total number of written bytes
      - gauge
    * - ``opennebula_libvirt_block_wr_time_seconds``
      - Total time spent on writes
      - gauge
    * - ``opennebula_libvirt_block_virtual_bytes``
      - Virtual size of the device
      - gauge
    * - ``opennebula_libvirt_block_physical_bytes``
      - Physical size of the container of the backing image
      - gauge
    * - ``opennebula_libvirt_daemon_up``
      - State of the libvirt daemon ``0``:down ``1``:up
      - gauge
