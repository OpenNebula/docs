.. _running_kubernetes_clusters:

============================
Running Kubernetes Clusters
============================

In the public OpenNebula System Marketplace there are also services available that let you deploy a multi-VM application. In this exercise we are going to import a `Kubernetes cluster service <http://marketplace.opennebula.io/appliance/9b06e6e8-8c40-4a5c-b218-27c749db6a1a>`_ and launch a Kubernetes cluster with it.

.. important:: This guide assumes that you have deployed the OpenNebula front-end following the :ref:`Deployment Basics guide <deployment_basics>` and a metal Edge Cluster with KVM hypervisor following the :ref:`Provisining an Edge Cluster <first_edge_cluster>` guide. This ensures that your OpenNebula front-end has a publicly accessible IP address so the deployed services can report to the OneGate server (see :ref:`OneGate Configuration <onegate_conf>` for more details).

We are going to assume the Edge Cluster naming schema ``metal-aws-edge-cluster``.

Step 1. Download the OneFlow Service from the Marketplace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Log in to Sunstone as oneadmin. Go to the ``Storage --> Apps`` tab and search for ``OneKE``. Select the ``Service OneKE 1.24 CE`` and click on the icon with the cloud and the down arrow inside (two positions to the right from the green ``+``).

|kubernetes-qs-marketplace|

Now you need to select a datastore. Select the ``metal-aws-edge-cluster-image`` Datastore.

|kubernetes-qs-marketplace-datastore|

The Appliance will be ready when the image in ``Storage --> Images`` switches to ``READY`` from its ``LOCKED`` state. This process may take significant amount of time based on the networking resources available in your infrastructure (Kubernetes 1.23 amounts to a total of 120GB).

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

    You may want to adjust the VM templates before you progress further - go to ``Templates --> VMs``, click on the ``Service OneKE 1.24 CE`` and blue button ``Update`` at the top.

Proceed to the ``Templates --> Services`` tab and select the ``Service OneKE 1.24 CE`` Service Template. Click on ``+`` and then ``Instantiate``.

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

.. note::

   The **public** IP address (AWS elastic IP) should be taken from OpenNebula after the VNF instance is successfully provisioned.

.. important::

    To make the kubeconfig file work with custom SANs you will need to modify the ``clusters[0].cluster.server`` variable inside the YAML payload, for example: ``server: https://k8s.yourdomain.it:6443``.

Now click on the instantiate button, go to ``Instances --> Services`` and wait for the new Service to get into ``RUNNING`` state. You can also check the VMs being deployed in ``Instances --> VMs``.

.. note::

    After the OneFlow service is deployed you can also **scale up** the worker nodes - the template will start only one - to add more follow onto the tab ``Roles``, click on ``worker`` and green button ``Scale``.

.. note:: Even though Sunstone shows the VNC console button, VNC access to VMs running in Edge Clusters has been deemed insecure and as such OpenNebula filters this traffic. This means that the VNC access won't work for VMs running in Edge Clusters.

.. |kubernetes-qs-pick-networks| image:: /images/kubernetes-qs-pick-networks.png
.. |kubernetes-qs-pick-vips| image:: /images/kubernetes-qs-pick-vips.png
.. |kubernetes-qs-add-sans| image:: /images/kubernetes-qs-add-sans.png

Step 4. Validate the Kubernetes cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once the service is in ``RUNNING`` state, you can start using the Kubernetes cluster. Let's first log in to the Kubernetes cluster VNF. Go to ``Instances --> VMs`` and check the public IP (from the dropdown, the one highlighted in bold).

From here you can reach other VMs from the cluster on their private IP. In our case Kubernets master has IP address ``172.20.0.2``. With the ssh-agent runnign you should be able to connect to it.

We'll use the ``oneadmin`` account in your OpenNebula Front-end. Please SSH to the Front-end first, and from there, as oneadmin, you should SSH in to the Kubernetes cluster master as ``root``. You should be greeted with the following message:

.. prompt:: bash $ auto

        ___   _ __    ___
       / _ \ | '_ \  / _ \   OpenNebula Service Appliance
      | (_) || | | ||  __/
       \___/ |_| |_| \___|

     All set and ready to serve 8)

.. note:: You can use the file in ``/etc/kubernetes/admin.conf`` to control the Kubernetes clusters from the outside. When the Kubernetes Appliance is deployed on the edge, you can copy the ``/etc/kubernetes/admin.conf`` into your system (laptop, workstation) and use ``kubectl`` locally.

We are going to use the root account in the master to perform a simple validation of the cluster. The first step is to check the workers are healthy. You should get a similar output to:

.. prompt:: yaml $ auto

    root@onekube-ip-172-20-0-2:~# kubectl get nodes
    NAME                    STATUS   ROLES                       AGE   VERSION
    onekube-ip-172-20-0-2   Ready    control-plane,etcd,master   13m   v1.24.1+rke2r2
    onekube-ip-172-20-0-3   Ready    <none>                      10m   v1.24.1+rke2r2
    onekube-ip-172-20-0-4   Ready    <none>                      10m   v1.24.1+rke2r2

Now create a file ``kubetest_1pod.yaml`` with the following contents:

.. prompt:: yaml $ auto

   kind: Deployment
   apiVersion: apps/v1
   metadata:
     name: kubetest
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: kubetest_pod
     template:
       metadata:
         labels:
           app: kubetest_pod
       spec:
         containers:
         - name: simple-http
           image: python:2.7
           imagePullPolicy: IfNotPresent
           command: ["/bin/bash"]
           args: ["-c", "echo \"ONEKUBE TEST OK: Hello from $(hostname)\" > index.html; python -m SimpleHTTPServer 8080"]
           ports:
           - name: http
             containerPort: 8080

Now it's time to apply it in Kubernetes:

.. prompt:: yaml $ auto

   kubectl apply -f kubetest_1pod.yaml

After a few seconds, you should be able to see the simple pod in RUNNING state:

.. prompt:: yaml $ auto

    root@onekube-ip-172-20-0-2:~# kubectl get pod
    NAME                        READY   STATUS    RESTARTS   AGE
    kubetest-7655fb5bdb-ztblz   1/1     Running   0          69s

Step 5. Connect to Kubernetes API via SSH tunnel (optional)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By default Kubernetes API Server's extra SANs are set to **localhost,127.0.0.1** which allows to access Kubernetes API via SSH tunnels.

.. note::

    We recommend using the ``ProxyCommand`` SSH feature, for example:

To download the **/etc/kubernetes/admin.conf** (kubeconfig) file:

.. prompt:: text [remote]$ auto

    [remote]$ mkdir -p ~/.kube/
    [remote]$ scp -o ProxyCommand='ssh -A root@1.2.3.4 -W %h:%p' root@172.20.0.2:/etc/kubernetes/admin.conf ~/.kube/config

.. note::

    The ``1.2.3.4`` is a **public** address of a VNF node, ``172.20.0.2`` is a **private** address of a master node (inside internal VNET).

To create SSH tunnel, forward ``6443`` port and query cluster nodes:

.. prompt:: text [remote]$ auto

    [remote]$ ssh -o ProxyCommand='ssh -A root@1.2.3.4 -W %h:%p' -L 6443:localhost:6443 root@172.20.0.2

.. important::

    You must make sure that the cluster endpoint inside the kubeconfig file (**~/.kube/config**) points to **localhost**, for example:

    .. prompt:: text [remote]$ auto

        gawk -i inplace -f- ~/.kube/config <<'EOF'
        /^    server: / { $0 = "    server: https://localhost:6443" }
        { print }
        EOF

and then in another terminal:

.. prompt:: text [remote]$ auto

    [remote]$ kubectl get nodes
    NAME                    STATUS   ROLES                       AGE   VERSION
    onekube-ip-172-20-0-2   Ready    control-plane,etcd,master   15m   v1.24.1+rke2r2
    onekube-ip-172-20-0-3   Ready    <none>                      13m   v1.24.1+rke2r2
    onekube-ip-172-20-0-4   Ready    <none>                      12m   v1.24.1+rke2r2

Step 6. Deploy an Application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Let's deploy nginx on the cluster:

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

It's a known issue in AWS edge clusters that the ``REPLICA_HOST`` defined for the system datastores may cause
QCOW2 image corruption, which causes VMs to start but they never boot correctly, which in turn silently causes
OneFlow services to lock up.

If you're experiencing such behavior and strangely truncated OS disks
(go ``Instances`` -> ``VMs`` -> pick a VM -> ``Storage`` -> look at ``vda`` -> ``Size``, if the size is very small like 20MiB it may be truncated),
then please consider removing the ``REPLICA_HOST`` parameter from your cluster's system datastore or at least retry the deployment.
