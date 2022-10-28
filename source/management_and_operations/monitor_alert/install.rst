.. _monitor_alert_installation:

================================================================================
Installation and Configuration
================================================================================

This page describes how to install the OpenNebula Prometheus integration packages available in the Enterprise Edition software repositories <repositories>.

Step 1. OpenNebula Repositories [Front-end, Hosts]
================================================================================

At this point OpenNebula software repositories should be already configured in your front-end and hosts. Double check this is the case before proceeding, more information can be found in the :ref:`OpenNebula Repositories <repositories>` guide.

Step 2. Install Front-end Packages [Front-end]
================================================================================

In your OpenNebula front-end, install the Prometheus package. This package includes:

  - The `Prometheus monitoring system binary <https://github.com/prometheus/prometheus>`_.
  - The `Prometheus Alertmanager binary <https://github.com/prometheus/alertmanager>`_.

You should also install the Prometheus-KVM package that includes metric exporters. This package includes:

  - The OpenNebula exporter.
  - The OpenNebula Libvirt exporter (unused in Front-ends).
  - The `Prometheus Node exporter binary <https://github.com/prometheus/node_exporter/blob/master/LICENSE>`_.

Prometheus, Alertmanager Node Exporter are free software and they are re-distributed for your convinience under the terms of the Apache License 2.0, as described in the `Prometheus <https://github.com/prometheus/prometheus/blob/main/LICENSE>`_, `Alertmanager <https://github.com/prometheus/alertmanager/blob/main/LICENSE>`_ and `Node exporter <https://github.com/prometheus/node_exporter/blob/master/LICENSE>`_ licenses respectively.

Note that you will be able to use any existing installation of both systems after the installation.

**RPM based distributions (Alma, RHEL)**

.. prompt:: bash # auto

    # yum -y install opennebula-prometheus opennebula-prometheus-kvm

**Deb based distributions (Ubuntu, Debian)**

.. prompt:: bash # auto

   # apt -y install opennebula-prometheus opennebula-prometheus-kvm

Step 3. Install Hosts Packages [Hosts]
================================================================================

In your hosts you need to install the Prometheus-KVM, this package includes:

  - The OpenNebula exporter (unused in Hosts).
  - The OpenNebula Libvirt exporter.
  - The `Prometheus Node exporter binary <https://github.com/prometheus/node_exporter/blob/master/LICENSE>`_.

Prometheus Node exporter is free software and re-distributed in this package for your convinience under the terms of the Apache License 2.0, as described in the `Node exporter license <https://github.com/prometheus/node_exporter/blob/master/LICENSE>`_.

Note that you will be able to use any existing installation of the node exporter after the installation.

**RPM based distributions (Alma, RHEL)**

.. prompt:: bash # auto

    # yum -y install opennebula-prometheus-kvm

**Deb based distributions (Ubuntu, Debian)**

.. prompt:: bash # auto

   # apt -y install opennebula-prometheus-kvm

Step 4. Configure Prometheus [Front-end]
================================================================================

The OpenNebula Prometheus package comes with a simple script that automatically configure the scrape endpoints for your cloud. First, make sure all your hosts are properly listed with onehost command, for example:

.. prompt:: bash $ auto

   $ onehost list
   ID NAME                          CLUSTER    TVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
    1 kvm-ssh-uimw3-2.test          default      0       0 / 100 (0%)     0K / 1.2G (0%) on
    0 kvm-ssh-uimw3-1.test          default      0       0 / 100 (0%)     0K / 1.2G (0%) on

Now, we will generate the prometheus configuration in ``/etc/one/prometheus/prometheus.yml``, as ``root`` (or ``oneadmin``) execute:

.. prompt:: bash # auto

   # /usr/share/one/prometheus/patch_datasources.rb

This command connects to your cloud as oneadmin to gather the relevant information. Now you can verify the configuration, for the example above:

.. prompt:: bash # auto

   # cat /etc/one/prometheus/prometheus.yml

   ---
   global:
     scrape_interval: 15s
     evaluation_interval: 15s

   alerting:
     alertmanagers:
     - static_configs:
       - targets:
         - 127.0.0.1:9093

   rule_files:
   - rules.yml

   scrape_configs:
   - job_name: prometheus
     static_configs:
     - targets:
       - 127.0.0.1:9090
   - job_name: opennebula_exporter
     static_configs:
     - targets:
       - 127.0.0.1:9925
   - job_name: node_exporter
     static_configs:
     - targets:
       - 127.0.0.1:9100
     - targets:
       - kvm-ssh-uimw3-2.test:9100
       labels:
         one_host_id: '1'
     - targets:
       - kvm-ssh-uimw3-1.test:9100
       labels:
         one_host_id: '0'
   - job_name: libvirt_exporter
     static_configs:
     - targets:
       - kvm-ssh-uimw3-2.test:9926
       labels:
         one_host_id: '1'
     - targets:
       - kvm-ssh-uimw3-1.test:9926
       labels:
         one_host_id: '0'

You can adjust scrape intervals or other configuration attributes in this file.

.. note:: You can easily add or remove hosts by copying or deleting the corresponding targets, or simply re-run the script. In that case you'll have a backup in `/etc/one/prometheus/` to recover any additional configurations.

Step 5. Start the Prometheus Service [Front-end]
================================================================================

Prometheus service is controlled with a Systemd unit file (`/usr/lib/systemd/system/opennebula-prometheus.service`). We recommend that you take a look to the default options set in that file, and add any flags of interest for your setup (e.g. run `prometheus -h` to get a complete list).

Once you are happy with the options, start and enable prometheus:

.. prompt:: bash # auto

   # systemctl enable --now opennebula-prometheus.service

Finally, we need to start and enable both exporters:

.. prompt:: bash # auto

   # systemctl enable --now opennebula-exporter.service opennebula-node-exporter.service

If everything went ok, you should be able to check that prometheus and both exporers are running:

.. prompt:: bash # auto

   # ss -tapn | grep 'LISTEN.*\(9925\|9100\|9090\)'
   LISTEN    0      100          0.0.0.0:9925       0.0.0.0:*     users:(("ruby",pid=32402,fd=7))
   LISTEN    0      4096               *:9090             *:*     users:(("prometheus",pid=35494,fd=7))
   LISTEN    0      4096               *:9100             *:*     users:(("node_exporter",pid=32507,fd=3))

and the opennebula-exporter is providing the monitor metrics:

.. prompt:: bash $ auto

   $ curl http://localhost:9925/metrics
   # TYPE opennebula_host_total gauge
   # HELP opennebula_host_total Total number of hosts defined in OpenNebula
   opennebula_host_total 2.0
   # TYPE opennebula_host_state gauge
   # HELP opennebula_host_state Host state 0:init 2:monitored 3:error 4:disabled 8:offline
   opennebula_host_state{one_host_id="1"} 2.0
   opennebula_host_state{one_host_id="0"} 2.0

Step 6. Start Node and Libvirt Exporters [Host]
================================================================================

Now we need to enable and start the node and libvirt exporters. Simply, using the provided Systemd unit files:

.. prompt:: bash # auto

   # systemctl enable --now opennebula-libvirt-exporter.service opennebula-node-exporter.service

As we did previsouly, let's verify exporters are listening in the targets ports:

.. prompt:: bash # auto

   # ss -tapn | grep 'LISTEN.*\(9926\|9100\)'
   LISTEN    0      100          0.0.0.0:9926       0.0.0.0:*     users:(("ruby",pid=38851,fd=7))
   LISTEN    0      4096               *:9100             *:*     users:(("node_exporter",pid=38884,fd=3))

You should be able also to retrive some metrics:

.. prompt:: bash $ auto

   $ curl localhost:9926/metrics
   # TYPE opennebula_libvirt_requests_total counter
   # HELP opennebula_libvirt_requests_total The total number of HTTP requests handled by the Rack application.
   opennebula_libvirt_requests_total{code="200",method="get",path="/metrics"} 18.0
   ...
   # TYPE opennebula_libvirt_daemon_up gauge
   # HELP opennebula_libvirt_daemon_up State of the libvirt daemon 0:down 1:up
   opennebula_libvirt_daemon_up 1.0

.. _monitor_alert_existing:

Using an Existing Prometheus Installation
================================================================================

If you already have an existing Prometheus installation, you just need to adapt Steps 4, 5 and 6 as follows:

  - You can use `/usr/share/one/prometheus/patch_datasources.rb` as described in Step 4 to copy the scrape configurations into your current Prometheus configuration file.
  - You just need to enable and start the `opennebula-exporter` as described in Step 5, but not the Prometheus service.
  - You will be already running the official node exporter, so in Step 6 only enable the `opennebula-libvirt-exporter`

.. _monitor_alert_ha:

Using Prometheus with OpenNebula in HA
================================================================================

You can refer to :ref:`OpenNebula Front-end HA <frontend_ha_setup>` to learn more about HA mode in OpenNebula.

Let's assume your existing OpenNebula instance consists of three front-ends and two KVM hosts:

.. prompt:: bash # auto

   # onezone show 0
   ZONE 0 INFORMATION
   ID                : 0
   NAME              : OpenNebula
   STATE             : ENABLED

   ZONE SERVERS
   ID NAME            ENDPOINT
    0 Node-1          http://192.168.150.1:2633/RPC2
    1 Node-2          http://192.168.150.2:2633/RPC2
    2 Node-3          http://192.168.150.3:2633/RPC2

   HA & FEDERATION SYNC STATUS
   ID NAME            STATE      TERM       INDEX      COMMIT     VOTE  FED_INDEX
    0 Node-1          follower   26         13719      13719      2     -1
    1 Node-2          follower   26         13719      13719      -1    -1
    2 Node-3          leader     26         13719      13719      2     -1

   ZONE TEMPLATE
   ENDPOINT="http://localhost:2633/RPC2"

.. prompt:: bash # auto

   # onehost list
   ID NAME                CLUSTER  TVM   ALLOCATED_CPU      ALLOCATED_MEM  STAT
   1 kvm-ha-xqhnt-5.test  default    2  20 / 100 (20%)  192M / 1.4G (13%)  on
   0 kvm-ha-xqhnt-4.test  default    1  10 / 100 (10%)   96M / 1.4G (6%)   on

Executing the `/usr/share/one/prometheus/patch_datasources.rb` script on the "first" (192.168.150.1) front-end
should produce the following prometheus configuration:

.. code-block:: yaml

   ---
   global:
     scrape_interval: 15s
     evaluation_interval: 15s

   alerting:
     alertmanagers:
     - static_configs:
       - targets:
         - 192.168.150.2:9093
         - 192.168.150.3:9093
         - 192.168.150.1:9093

   rule_files:
   - rules.yml

   scrape_configs:
   - job_name: prometheus
     static_configs:
     - targets:
       - localhost:9090
   - job_name: opennebula_exporter
     static_configs:
     - targets:
       - 192.168.150.1:9925
   - job_name: node_exporter
     static_configs:
     - targets:
       - 192.168.150.2:9100
       - 192.168.150.3:9100
       - 192.168.150.1:9100
     - targets:
       - kvm-ha-xqhnt-5.test:9100
       labels:
         one_host_id: '1'
     - targets:
       - kvm-ha-xqhnt-4.test:9100
       labels:
         one_host_id: '0'
   - job_name: libvirt_exporter
     static_configs:
     - targets:
       - kvm-ha-xqhnt-5.test:9926
       labels:
         one_host_id: '1'
     - targets:
       - kvm-ha-xqhnt-4.test:9926
       labels:
         one_host_id: '0'

You can spot that all front-ends and all hosts are included in various scrape jobs.
You can also see configuration for alerting

.. code-block:: yaml

   alerting:
     alertmanagers:
     - static_configs:
       - targets:
         - 192.168.150.2:9093
         - 192.168.150.3:9093
         - 192.168.150.1:9093

which points to **all** alertmanager instances that are supposed to be configured
in `HA mode <https://prometheus.io/docs/alerting/latest/alertmanager/#high-availability>`_ as well
(to deduplicate alert notifications).

.. important::

   Services **opennebula-prometheus**, **opennebula-alertmanager**, **opennebula-node-exporter**
   and **opennebula-exporter** should be configured, enabled and started on **all** front-end machines.

To configure each alertmanager as a cluster peer, you need to override (or modify) the `opennebula-alertmanager` systemd service.
For example on the "second" front-end:

.. prompt:: bash # auto

   # mkdir -p /etc/systemd/system/opennebula-alertmanager.service.d/
   # cat >/etc/systemd/system/opennebula-alertmanager.service.d/override.conf <<'EOF'
   [Service]
   ExecStart=
   ExecStart=/usr/bin/alertmanager \
             --config.file=/etc/one/alertmanager/alertmanager.yml \
             --storage.path=/var/lib/alertmanager/data/ \
             --cluster.peer=192.168.150.1:9094 \
             --cluster.peer=192.168.150.3:9094
   EOF
   # systemctl restart opennebula-alertmanager.service

.. note::

   You can create the `opennebula-alertmanager.service.d/override.conf` file yourself
   or automatically with ``systemctl edit opennebula-alertmanager.service``.
