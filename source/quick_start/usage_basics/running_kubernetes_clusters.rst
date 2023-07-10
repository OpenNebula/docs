.. _running_kubernetes_clusters:

============================
Running Kubernetes Clusters
============================

In the public OpenNebula System Marketplace there are also services available that let you deploy a multi-VM application. In this exercise we are going to import a `Kubernetes cluster service <http://marketplace.opennebula.io/appliance/9b06e6e8-8c40-4a5c-b218-27c749db6a1a>`_ and launch a Kubernetes cluster with it.

This guide assumes that you have deployed the OpenNebula front-end following the :ref:`Deployment Basics guide <deployment_basics>` and a metal Edge Cluster with KVM hypervisor following the :ref:`Provisining an Edge Cluster <first_edge_cluster>` guide. This ensures that your OpenNebula front-end has a publicly accessible IP address so the deployed services can report to the OneGate server (see :ref:`OneGate Configuration <onegate_conf>` for more details). We are going to assume the Edge Cluster naming schema ``metal-aws-edge-cluster``.

.. important:: It's a known issue in AWS edge clusters that the ``REPLICA_HOST`` defined for the system datastores may cause QCOW2 image corruption, which causes VMs to boot incorrectly. To avoid this sporadic failure, remove the ``REPLICA_HOST`` parameter from your cluster's system datastore (go to Storage -> Datastore, select the aws-cluster* system datastore -most likely ID 101 if you started the QS guide from scratch- and delete the ``REPLICA_HOST`` parameter from the Attributes section).

Step 1. Download the OneFlow Service from the Marketplace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Log in to Sunstone as oneadmin. Go to the ``Storage --> Apps`` tab and search for ``OneKE``. Select the ``Service OneKE 1.27`` and click on the icon with the cloud and the down arrow inside (two positions to the right from the green ``+``).

|kubernetes-qs-marketplace|

Now you need to select a datastore. Select the ``metal-aws-edge-cluster-image`` Datastore.

|kubernetes-qs-marketplace-datastore|

The Appliance will be ready when the image in ``Storage --> Images`` switches to ``READY`` from its ``LOCKED`` state. This process may take significant amount of time based on the networking resources available in your infrastructure (Kubernetes 1.24 amounts to a total of 120GB).

.. |kubernetes-qs-marketplace|           image:: /images/kubernetes-qs-marketplace.png
.. |kubernetes-qs-marketplace-datastore| image:: /images/kubernetes-qs-marketplace-datastore.png

Step 2. Instantiate private network
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
During the AWS Edge Cluster provisioning a private private network template was created, we need to instantiate it first and assign a range to it. To do so, go to the ``Network --> Network Templates``, open the ``metal-aws-edge-cluster-private`` Virtual Network Template and click on the instantiate button.

We need to first put the name, e.g. ``aws-private`` and then add an address range, click ``+ Address Range`` and put a private IPv4 range, e.g. ``172.20.0.1``, for size we can put ``100``.

Last thing you need to add to the network is a DNS server, click the ``Context`` tab under Network configuration and put a DNS server, e.g. ``8.8.8.8`` or ``1.1.1.1``.

|kubernetes-qs-create-ar|

Now you are ready to start the Kubernetes Service.

.. |kubernetes-qs-create-ar| image:: /images/kubernetes-qs-create-ar.png

Step 3. Instantiate the Kubernetes Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::

    You may want to adjust the VM templates before you progress further - go to ``Templates --> VMs``, click on the ``Service OneKE 1.27`` and blue button ``Update`` at the top.

Proceed to the ``Templates --> Services`` tab and select the ``Service OneKE 1.27`` Service Template. Click on ``+`` and then ``Instantiate``.

A required step is clicking on ``Network`` and selecting the ``metal-aws-edge-cluster-public`` network for public network.

And for private network we will use the ``aws-private`` we instantiated before.

|kubernetes-qs-pick-networks|

Also, we need to specify some VIPs from the private subnet, put e.g.: ``172.20.0.253`` and ``172.20.0.254``

|kubernetes-qs-pick-vips|

.. note::

    This is specific to AWS deployments. In an on-prem scenario the ``Control Plane Endpoint VIP`` should be IP address taken from a **public** VNET.

You will most likely want to add a custom domain to Kubernetes SANs, so the ``kubectl`` command could be used from "outside" of the cluster.

|kubernetes-qs-add-sans|

You can either use a public DNS server or local ``/etc/hosts`` file, for example:

.. prompt:: text $ auto

   127.0.0.1 localhost
   1.2.3.4 k8s.yourdomain.it

.. important::

    To make the kubeconfig file work with custom SANs you will need to modify the ``clusters[0].cluster.server`` variable inside the YAML payload, for example: ``server: https://k8s.yourdomain.it:6443``.

Now click on the instantiate button, go to ``Instances --> Services`` and wait for the new Service to get into ``RUNNING`` state. You can also check the VMs being deployed in ``Instances --> VMs``.

.. note::

   The **public** IP address (AWS elastic IP) should be consulted in OpenNebula after the VNF instance is successfully provisioned. Go to ``Instances --> VMs`` and check the IP column to see what IP has OpenNebula assigned the VNF instance.

.. note::

    After the OneFlow service is deployed you can also **scale up** the worker nodes - the template will start only one - to add more follow onto the tab ``Roles``, click on ``worker`` and green button ``Scale``.

.. note:: Even though Sunstone shows the VNC console button, VNC access to VMs running in Edge Clusters has been deemed insecure and as such OpenNebula filters this traffic. This means that the VNC access won't work for VMs running in Edge Clusters.

.. |kubernetes-qs-pick-networks| image:: /images/kubernetes-qs-pick-networks.png
.. |kubernetes-qs-pick-vips| image:: /images/kubernetes-qs-pick-vips.png
.. |kubernetes-qs-add-sans| image:: /images/kubernetes-qs-add-sans.png

Step 4. Deploy an Application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Connect to the master Kubernetes node (from the Open Nebula front-end node):

.. prompt:: text $ auto

    $ ssh -A -J root@1.2.3.4 root@172.20.0.2

where ``1.2.3.4`` should be the **public** address (AWS elastic IP) of a VNF node.

.. important::

    If you don't use ``ssh-agent`` then the ``-A`` flag makes no difference to you (it can be skipped).
    In such case, you need to copy your **private** ssh key (used to connect to VNF) into the VNF node itself
    at the location ``~/.ssh/id_rsa`` and make sure file permissions are correct, i.e. ``0600`` (or ``u=rw,go=``).
    For example:

    .. prompt:: text $ auto

        $ ssh root@1.2.3.4 install -m u=rwx,go= -d /root/.ssh/ # make sure ~/.ssh/ exists
        $ scp ~/.ssh/id_rsa root@1.2.3.4:/root/.ssh/           # copy the key
        $ ssh root@1.2.3.4 chmod u=rw,go= /root/.ssh/id_rsa    # make sure the key is secured

Check if ``kubectl`` is working:

.. prompt:: text $ auto

    $ kubectl get nodes
    NAME                    STATUS   ROLES                       AGE   VERSION
    onekube-ip-172-20-0-2   Ready    control-plane,etcd,master   15m   v1.24.1+rke2r2
    onekube-ip-172-20-0-3   Ready    <none>                      13m   v1.24.1+rke2r2
    onekube-ip-172-20-0-4   Ready    <none>                      12m   v1.24.1+rke2r2

Deploy nginx on the cluster:

.. prompt:: yaml $ auto

   $ kubectl run nginx --image=nginx --port 80

After a few seconds, you should be able to see the nginx pod running

.. prompt:: yaml $ auto

    $ kubectl get pods
    NAME    READY   STATUS    RESTARTS   AGE
    nginx   1/1     Running   0          12s

In order to access the application, we need to create a Service and IngressRoute objects that expose the application.

External IP Ingress
+++++++++++++++++++

Create a ``expose-nginx.yaml`` file with the following contents:

.. prompt:: yaml $ auto

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

.. prompt:: text $ auto

    $ kubectl apply -f expose-nginx.yaml
    service/nginx created
    ingressroute.traefik.containo.us/nginx created

Access the VNF node public IP in you browser using plain HTTP:

|external_ip_nginx_welcome_page|

Congrats! You successfully deployed a fully functional Kubernetes cluster in the edge. Have fun with your new OpenNebula cloud!

.. |external_ip_nginx_welcome_page| image:: /images/external_ip_nginx_welcome_page.png

Known Issues
~~~~~~~~~~~~

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
