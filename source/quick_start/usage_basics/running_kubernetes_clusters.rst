.. _running_kubernetes_clusters:

============================
Running Kubernetes Clusters
============================

In the public OpenNebula System Marketplace there are also services available that let you deploy a multi-VM application. In this exercise we are going to import an `OneKE Service <https://marketplace.opennebula.io/appliance/7c82d610-73f1-47d1-a85a-d799e00c631e>`_ and launch a Kubernetes (RKE2) cluster with it.

This guide assumes that you have deployed the OpenNebula front-end following the :ref:`Deployment Basics guide <deployment_basics>` and a metal Edge Cluster with KVM hypervisor following the :ref:`Provisining an Edge Cluster <first_edge_cluster>` guide. This ensures that your OpenNebula front-end has a publicly accessible IP address so the deployed services can report to the OneGate server (see :ref:`OneGate Configuration <onegate_conf>` for more details). We are going to assume the Edge Cluster naming schema ``aws-edge-cluster``.

.. important:: It's a known issue in AWS edge clusters that the ``REPLICA_HOST`` defined for the system datastores may cause QCOW2 image corruption, which causes VMs to boot incorrectly. To avoid this sporadic failure, remove the ``REPLICA_HOST`` parameter from your cluster's system datastore (go to Storage -> Datastore, select the aws-cluster* system datastore -most likely ID 101 if you started the QS guide from scratch- and delete the ``REPLICA_HOST`` parameter from the Attributes section).

Step 1. Download the OneFlow Service from the Marketplace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Log in to Sunstone as oneadmin. Go to the ``Storage --> Apps`` tab and search for ``OneKe 1.27``. Select the ``Service OneKE 1.27`` and click on the icon with the cloud and the down arrow inside.

|kubernetes-qs-marketplace|

Now you need to select a datastore. Select the ``aws-edge-cluster-image`` Datastore.

|kubernetes-qs-marketplace-datastore|

The Appliance will be ready when the image in ``Storage --> Images`` switches to ``READY`` from its ``LOCKED`` state. This process may take significant amount of time based on the networking resources available in your infrastructure (Kubernetes 1.27 amounts to a total of 52GB).

.. |kubernetes-qs-marketplace|           image:: /images/kubernetes-qs-marketplace.png
.. |kubernetes-qs-marketplace-datastore| image:: /images/aws_cluster_images_datastore.png

Step 2. Instantiate private network
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
During the AWS Edge Cluster provisioning a private network template was created, we need to instantiate it first and assign a range to it. To do so, go to the ``Network --> Network Templates``, open the ``aws-edge-cluster-private`` Virtual Network Template and click on the instantiate button.

First we need to give the network a name, e.g. ``aws-private``

|kubernetes-aws-private-network|

Then hit ``Next`` & click ``+ Address Range`` and select a private IPv4 range, e.g. ``172.20.0.1``, for size we can use ``100``.

|kubernetes-aws-private-network-range|

Last thing you need to add to the network is a DNS server, click the ``Context`` tab and add a DNS server, e.g. ``8.8.8.8`` or ``1.1.1.1``.

|kubernetes-aws-dns|

Now you are ready to start the Kubernetes Service.

.. |kubernetes-aws-private-network| image:: /images/kubernetes_aws_private_network.png
.. |kubernetes-aws-private-network-range| image:: /images/kubernetes_aws_private_network_address_range.png
.. |kubernetes-aws-dns| image:: /images/kubernetes_aws_dns.png

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
