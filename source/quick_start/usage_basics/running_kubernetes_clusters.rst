.. _running_kubernetes_clusters:

============================
Running Kubernetes Clusters
============================

.. ++ = hasta acá

In previous tutorials of this Quick Start Guide, we:

   * Installed an :ref:`OpenNebula Front-end using miniONE <try_opennebula_on_kvm>`,
   * deployed a :ref:`Metal Edge Cluster <first_edge_cluster>` on AWS, and
   * deployed a :ref:`Virtual Machine <running_virtual_machines>` with WordPress on that Metal Edge Cluster.
   
At this point, we are ready to deploy something more complex on our Metal Edge Cluster: an enterprise-grade, CNCF-certified, multi-master Kubernetes cluster based on SUSE Rancher’s RKE2 Kubernetes distribution. Like the VM with WordPress, the Kubernetes distribution is available in the `OpenNebula Public Marketplace <https://marketplace.opennebula.io>`__, as the multi-VM appliance **OneKE**.

To deploy Kubernetes, we’ll follow these high-level steps:

   #. Download the OneKE Service from the OpenNebula Marketplace.
   #. Instantiate a private network on the Edge Cluster.
   #. Instantiate the Kubernetes Service.
   #. Deploy an application on Kubernetes.

.. important:: As mentioned above, in this tutorial we’ll use the infrastructure created in previous tutorials of this Quick Start Guide, namely our :ref:`OpenNebula Front-end <try_opennebula_on_kvm>` and our :ref:`Metal Edge Cluster <first_edge_cluster>`, both deployed on AWS. To complete this tutorial, you will need the Front-end and the Edge Cluster up and running.

A Preliminary Step: Remove ``REPLICA_HOST``
==============================================

It’s known issue in AWS Edge Clusters that the ``REPLICA_HOST`` parameter in the template for the cluster’s datastore may cause QCOW2 image corruption, which causes VMs to boot incorrectly. To avoid the possibility of sporadic VM boot failures, remove the ``REPLICA_HOST`` parameter by following these steps:

   #. Log in to Sunstone as user ``oneadmin``.
   #. Open the left-hand pane (by hovering your mouse over the icons on the left), then select **Storage** -> **Datastore**.
   #. Select the AWS cluster’s system datastore. (It will probably show ID ``101`` if you began this Quick Start Guide on a clean install.)
   #. In the **Attributes** section, find the ``REPLICA_HOST`` attribute and hover your mouse to the right, to display the icons |icon3| for editing the parameter value:
   
      .. image:: /images/kubernetes-replica_host_param.png
   
   #. Click the **Trash** icon |icon4| to delete the ``REPLICA_HOST`` parameter from the datastore.
   
Step 1. Download the OneKE Service from the OpenNebula Marketplace
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The `OpenNebula Public Marketplace <https://marketplace.opennebula.io>`_ is a repository of Virtual Machines and appliances which are curated, tested and certified by OpenNebula.

The Kubernetes cluster packaged in the **OneKE** multi-VM appliance. To download it, follow the same steps as when downloading the WordPress VM:

Log in to Sunstone as user ``oneadmin``.

Open the left-hand pane (by hovering the mouse over the icons on the left), then select **Storage**, then **Apps**. Sunstone will display the **Apps** screen, showing the first page of apps that are available for download.

.. image:: /images/sunstone-apps_list.png
   :align: center
   :scale: 60%

|

In the search field at the top, type ``oneke`` to filter by name. Then, select **Service OneKE <version number>** with the hightest version number, in this case **Service OneKE 1.29** highlighted below.

.. image:: /images/sunstone-service_oneke_1.29.png
   :align: center
   :scale: 60%

|

Click the **Import into Datastore** |icon1| icon.

Sunstone displays the **Download App to OpenNebula** wizard. In the second screen you will need to select a datastore for the appliance. Select the ``aws-edge-cluster-image`` datastore.

|kubernetes-qs-marketplace-datastore|

Click **Finish**. Sunstone will display the appliance template and download the appliance in the background. Wait for the appliance **State** to indicate **READY**. The appliance comprises a 25GB download, so this may take several minutes.

Step 2. Instantiate a Private Network on the Edge Cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

During :ref:`Provisioning an Edge Cluster <first_edge_cluster>`, OpenNebula automatically created a network template for the Edge Cluster. Now we need to instantiate it and assign a range of IPs to it.

In Sunstone, open the left-hand pane, Select **Network** -> **Network Templates**, then select the **aws-edge-cluster-private** Vitual Network template. Click the **Instantiate** |icon2| icon at the top.

.. image:: /images/sunstone-aws_cluster_private_net_template.png
   :align: center

|

Sunstone displays the **Instantiate Network Template** wizard. In the first screen, choose a name for the network, e.g. ``aws-private``.

|kubernetes-aws-private-network|

Click **Next**. In the next screen, click the **+ Address Range** box to select an IP address range for the network.

.. image:: /images/sunstone-aws_cluster_private_net_template-add_addr.png
   :align: center

|

Sunstone displays the **Address Range** dialog box. Here you can define an address range by selecting the first address and the size of the address range. Select a range of private IPv4 addresses, for example ``172.20.0.1``. In this example we’ll set a size of ``100``.

|kubernetes-aws-private-network-range|

Lastly, you will need to add a DNS server for the network. Select the **Context** tab, then the **DNS** input field. Type the address for the DNS server, such as ``8.8.8.8`` or ``1.1.1.1``.

|kubernetes-aws-dns|

Click **Finish**.

At this point, you have instantiated a private network for the Edge Cluster where Kubernetes will be deployed, and are ready to start the Kubernetes Service.

.. |kubernetes-aws-private-network| image:: /images/kubernetes_aws_private_network.png
.. |kubernetes-aws-private-network-range| image:: /images/kubernetes_aws_private_network_address_range.png
.. |kubernetes-aws-dns| image:: /images/kubernetes_aws_dns.png

.. +++++++++++++++++++++++++++++++++++++

Step 3. Instantiate the Kubernetes Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::

    You may want to adjust the VM templates before you progress further - go to ``Templates --> VMs``, click on the ``Service OneKE 1.27`` and blue button ``Update`` at the top.

Proceed to the ``Templates --> Service Templates`` tab and select the ``Service OneKE 1.27`` Service Template. Click on the ``Instantiate`` button (next to Update).

Then we can give our service a name and the number of instances to instantiate, for this example we will use ``OneKE 1.27`` and start ``1`` instance of it.

|kubernetes-qs-service-start|

Then we hit ``Next`` until we reach the ``Network`` step. Under which we select the ``aws-edge-cluster-public`` network, for the public network ID

|kubernetes-qs-pick-networks-public|

and ``aws-private`` for the private network ID.

|kubernetes-qs-pick-networks-private|

You will most likely want to add a custom domain to Kubernetes SANs, so the ``kubectl`` command could be used from "outside" of the cluster.

|kubernetes-qs-add-sans|

You can either use a public DNS server or your local ``/etc/hosts`` file, for example:

.. prompt:: text $ auto

   127.0.0.1 localhost
   1.2.3.4 k8s.yourdomain.it

.. important:: To make the kubeconfig file work with custom SANs you will need to modify the ``clusters[0].cluster.server`` variable inside the YAML payload (for example: ``server: https://k8s.yourdomain.it:6443``) which can be found in the file whose path is a value of the $KUBECONFIG variable on the k8s master node (the details on how to log in to that node are given below in :ref:`Step 4. Provisining an Edge Cluster <step-4>`).

To be able to expose an example application you should enable OneKE's Traefik / HAProxy solution for ingress traffic:

|kubernetes-qs-enable-ingress|

Now click on the instantiate button in the Sunstone web-GUI, go to ``Instances --> Services`` or via command line interface (CLI)

.. prompt:: bash $ auto

   [oneadmin@FN]$ oneflow list

and wait for the new Service to get into ``RUNNING`` state. You can also check the VMs being deployed in Sunstone under the ``Instances --> VMs`` tab or via the CLI:

.. prompt:: bash $ auto

   [oneadmin@FN]$ onevm list

.. note:: The **public** IP address (AWS elastic IP) should be consulted in OpenNebula after the VNF instance is successfully provisioned. Go to ``Instances --> VMs`` and check the IP column to see what IP OpenNebula has assigned the VNF instance, or via the CLI:

.. prompt:: bash $ auto

   [oneadmin@FN]$ onevm show -j <VNF_VM_ID>|jq -r .VM.TEMPLATE.NIC[0].EXTERNAL_IP

.. important:: This is specific to AWS deployments. One needs to add a corresponding inbound rule into AWS security group (SG) with AWS elastic IP of VNF node for 5030 port and apply the updated SG against the AWS FN node.


If the OneFlow service is stuck in DEPLOYING state, please, check :ref:`OneFlow service is stuck in DEPLOYING <oneflow-service-is-stuck-in-deploying>`


After the OneFlow service is deployed you can also **scale up** the worker nodes - the template will start only one - to add more follow onto the tab ``Roles``, click on ``worker`` and then the green button ``Scale``.

.. note:: Even though Sunstone shows the VNC console button, VNC access to VMs running in Edge Clusters has been deemed insecure and as such OpenNebula filters this traffic. This means that the VNC access won't work for VMs running in Edge Clusters.


.. |kubernetes-qs-service-start| image:: /images/kubernetes_service_start.png
.. |kubernetes-qs-pick-networks-public| image:: /images/kubernetes-qs-pick-networks-public.png
.. |kubernetes-qs-pick-networks-private| image:: /images/kubernetes-qs-pick-networks-private.png
.. |kubernetes-qs-add-sans| image:: /images/kubernetes-qs-add-sans.png
.. |kubernetes-qs-enable-ingress| image:: /images/kubernetes-qs-enable-ingress.png

.. _step-4:

Step 4. Deploy an Application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Connect to the master Kubernetes node (from the Open Nebula front-end node):

.. prompt:: bash $ auto

    $ ssh -A -J root@1.2.3.4 root@172.20.0.2

where ``1.2.3.4`` should be the **public** address (AWS elastic IP) of a VNF node which can be extracted by executing the following command:

.. prompt:: bash $ auto

   [oneadmin@FN]$ onevm show -j <VNF_VM_ID>|jq -r .VM.TEMPLATE.NIC[0].EXTERNAL_IP


.. important::

    If you don't use ``ssh-agent`` then the ``-A`` flag makes no difference to you (it can be skipped).
    In such case, you need to copy your **private** ssh key (used to connect to VNF) into the VNF node itself
    at the location ``~/.ssh/id_rsa`` and make sure file permissions are correct, i.e. ``0600`` (or ``u=rw,go=``).
    For example:

    .. prompt:: bash $ auto

        $ ssh root@1.2.3.4 install -m u=rwx,go= -d /root/.ssh/ # make sure ~/.ssh/ exists
        $ scp ~/.ssh/id_rsa root@1.2.3.4:/root/.ssh/           # copy the key
        $ ssh root@1.2.3.4 chmod u=rw,go= /root/.ssh/id_rsa    # make sure the key is secured

Check if ``kubectl`` is working:

.. prompt:: bash root@oneke-ip-172-20-0-2:~#  auto

   root@oneke-ip-172-20-0-2:~# kubectl get nodes
   NAME                  STATUS   ROLES                       AGE   VERSION
   oneke-ip-172-20-0-2   Ready    control-plane,etcd,master   18m   v1.27.2+rke2r1
   oneke-ip-172-20-0-3   Ready    <none>                      16m   v1.27.2+rke2r1


Deploy nginx on the cluster:

.. prompt:: bash root@oneke-ip-172-20-0-2:~# auto

   root@oneke-ip-172-20-0-2:~# kubectl run nginx --image=nginx --port 80
   pod/nginx created

After a few seconds, you should be able to see the nginx pod running

.. prompt:: bash root@oneke-ip-172-20-0-2:~# auto

   root@oneke-ip-172-20-0-2:~# kubectl get pods
   NAME    READY   STATUS    RESTARTS   AGE
   nginx   1/1     Running   0          86s

In order to access the application, we need to create a Service and IngressRoute objects that expose the application.

External IP Ingress
+++++++++++++++++++

Create a ``expose-nginx.yaml`` file with the following contents:

.. code-block:: yaml

    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx
    spec:
      selector:
        run: nginx
      ports:
        - name: http
          protocol: TCP
          port: 80
          targetPort: 80
    ---
    apiVersion: traefik.containo.us/v1alpha1
    kind: IngressRoute
    metadata:
      name: nginx
    spec:
      entryPoints: [web]
      routes:
        - kind: Rule
          match: Path(`/`)
          services:
            - kind: Service
              name: nginx
              port: 80
              scheme: http

Apply the manifest using ``kubectl``:

.. prompt:: bash root@oneke-ip-172-20-0-2:~# auto

   root@oneke-ip-172-20-0-2:~# kubectl apply -f expose-nginx.yaml
   service/nginx created
   ingressroute.traefik.containo.us/nginx created

Access the VNF node public IP in you browser using plain HTTP:

|external_ip_nginx_welcome_page|

Congrats! You successfully deployed a fully functional Kubernetes cluster in the edge. Have fun with your new OpenNebula cloud!

.. |external_ip_nginx_welcome_page| image:: /images/external_ip_nginx_welcome_page.png

Known Issues
~~~~~~~~~~~~
.. _oneflow-service-is-stuck-in-deploying:

OneFlow service is stuck in DEPLOYING
+++++++++++++++++++++++++++++++++++++

Any major failure can result in OneFlow services to lock up, that can happen when **any** of the VMs belonging
to the service does not commit ``READY=YES`` to OneGate in time. You can recognize this by inspecting
the ``/var/log/one/oneflow.log`` file on your OpenNebula frontend machine, just look for:

.. code-block:: text

    [E]: [LCM] [one.document.info] User couldn't be authenticated, aborting call.

This means that provisioning of your OneFlow service already took too much time and it's not possible to
recover such a broken instance, it must be recreated.

.. important::

    But before you recreate it, please make sure your environment
    has good connection to the public Internet and in general its performance is not impaired.

The stuck in DEPLOYING state for a OneFlow service can not be terminated via the 'delete' operation. In order to do so, one needs to use the following command:

.. prompt:: bash $ auto

   [oneadmin@FN]$ oneflow recover --delete <service_ID>

Another issue you might face is the VNF node can't contact the OneGate server on FN. In that case there are messages in the ``/var/log/one/oneflow.log`` file like this:


.. code-block:: text

    [EM] Timeout reached for VM [0] to report

In such a case, only the VNF node will be deployed and no k8s ones. Thus you must SSH into the VNF node and run as root:

.. prompt:: bash $ auto

   [root@VNF]$ onegate vm show

to check if the VNF is able to contact the OneGate server on FN. A successful response should look like the one below:

.. code-block:: text

    [root@VNF]$ onegate vm show
    VM 0
    NAME            	: vnf_0_(service_3)

and in case of failure:


.. code-block:: text

    [root@VNF]$ onegate vm show
    Timeout while connected to server (Failed to open TCP connection to <AWS elastic IP of FN>:5030 (execution expired)).
    Server: <AWS elastic IP of FN>:5030

Check on the VNF node if ONEGATE_ENDPOINT is set to the AWS elastic IP address of FN:

.. code-block:: text

    [root@VNF]$ grep ONEGATE -r /run/one-context*

Make sure a corresponding inbound rule exists in the AWS security group (SG) with AWS elastic IP on port 5030 and modifications have been applied to AWS FN node.

.. |icon1| image:: /images/icons/sunstone/import_into_datastore.png
.. |icon2| image:: /images/icons/sunstone/instantiate.png
.. |icon3| image:: /images/icons/sunstone/parameter_manipulation_icons.png
.. |icon4| image:: /images/icons/sunstone/trash.png
