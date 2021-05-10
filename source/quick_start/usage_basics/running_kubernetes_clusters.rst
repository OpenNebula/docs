.. _running_kubernetes_clusters:

============================
Running Kubernetes Clusters
============================

In the public OpenNebula System Marketplace there are also services available that let you deploy a multi-VM application. In this exercise we are going to import a `Kubernetes cluster service <https://marketplace.opennebula.io/appliance/07520eee-6552-11eb-85e7-98fa9bde1a93>`_ and launch a Kubernetes cluster with it.

.. warning:: We need a metal KVM Edge Cluster for this. If you haven't already done so, you can follow the same steps of the :ref:`provisioning an edge cluster <first_edge_cluster>` guide, using "metal" edge cloud type and kvm hypervisor. Make sure you request two public IPs.

We are going to assume the Edge Cluster naming schema ``metal-kvm-aws-cluster``.

Step 1. Download the OneFlow Service from the Marketplace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Log in to Sunstone as oneadmin. Go to the ``Storage --> Apps`` tab and search for ``Kubernetes``. Select the ``Service Kubernetes 1.18 for OneFlow - KVM`` and click on the icon with the cloud and the down arrow inside (two positions to the right from the green ``+``).

|kubernetes_marketplace|

Now you need to select a datastore. Select the ``metal-kvm-aws-cluster-Images`` Datastore.

|metal_kvm_aws_cluster_images_datastore|

The Appliance will be ready when the image in ``Storage --> Images`` switches to ``READY`` from its ``LOCKED`` state.

.. |kubernetes_marketplace| image:: /images/kubernetes_marketplace.png
.. |metal_kvm_aws_cluster_images_datastore| image:: /images/metal_kvm_aws_cluster_images_datastore.png

Step 2. Instantiate the Kubernetes Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::

    You may want to adjust the VM templates before you progress further - go to ``Templates --> VMs``, click on the ``Service Kubernetes 1.18 for OneFlow - KVM-0`` and blue button ``Update`` at the top.

    Here you can increase memory for the nodes, disk capacity, add SSH key, etc. How to modify the VM template is summarized in the short `Quick Start <https://docs.opennebula.io/appliances/service/kubernetes.html#update-vm-template>`_ for the Kubernetes Appliance.

Proceed to the ``Templates --> Services`` tab and select the ``Service Kubernetes 1.18 for OneFlow - KVM`` Service Template (that should be the only one available). Click on ``+`` and then ``Instantiate``.

A required step is clicking on ``Network`` and selecting the ``metal-kvm-aws-cluster-public`` network.

|select_metal_aws_cluster_public_network|

Feel free to set any `contextualization parameters <https://docs.opennebula.io/appliances/service/kubernetes.html#k8s-context-param>`_ (shown in the picture below) to configure the Kubernetes cluster. You will most likely want to setup IP range for the `Kubernetes LoadBalancer <https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer>`_ - that can be done either by providing the complete config in ``ONEAPP_K8S_LOADBALANCER_CONFIG`` (it's a `configmap for MetalLB <https://metallb.universe.tf/configuration/#layer-2-configuration>`_) or set one in ``ONEAPP_K8S_LOADBALANCER_RANGE`` (e.g.: ``10.0.0.0-10.255.255.255``). More info on the topic can be found in the `LoadBalancer Service section <https://docs.opennebula.io/appliances/service/kubernetes.html#loadbalancer-service>`_ of the Kubernetes Appliance documentation.

.. note::

    Master related context parameters apply to the role **master** which is on the left. No need to setup or change anything for the **worker** on the right.

|configure_kubernetes_cluster|

Now proceed to ``Instances --> Services`` and wait for the only Service there to get into a ``RUNNING`` state. You can also check the VMs being deployed in ``Instances --> VMs``.

.. note::

    After the OneFlow service is deployed you can also **scale up** the worker nodes - the template will start only one - to add more follow onto the tab ``Roles``, click on ``worker`` and green button ``Scale``.

.. note:: Even though Sunstone shows the VNC console button, VNC access to Containers or VMs running in Edge Clusters has been deemed insecure and as such OpenNebula filters this traffic. This means that the VNC access won't work for VMs running in Edge Clusters.

.. |select_metal_aws_cluster_public_network| image:: /images/select_metal_aws_cluster_public_network.png
.. |configure_kubernetes_cluster| image:: /images/configure_kubernetes_cluster.png

Step 3. Validate the Kubernetes cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once the service is in ``RUNNING`` state, you can start using the Kubernetes cluster. Let's first log in to the Kubernetes cluster master. Go to ``Instances --> VMs`` and check the public IP (from the dropdown, the one highlighted in bold).

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

    [root@onekube-ip-10-0-17-190 ~]# kubectl get nodes
    NAME                                  STATUS   ROLES    AGE   VERSION
    onekube-ip-10-0-109-134.localdomain   Ready    <none>   27m   v1.18.10
    onekube-ip-10-0-17-190.localdomain    Ready    master   29m   v1.18.10

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

   [root@onekube-ip-10-0-17-190 ~]# kubectl get pod
   NAME                        READY   STATUS    RESTARTS   AGE
   kubetest-6bfc69d7ff-fcl22   1/1     Running   0          8m13s

Step 4. Deploy an Application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Let's deploy nginx on the cluster:

.. prompt:: yaml $ auto

   [root@onekube-ip-10-0-17-190 ~]# kubectl run nginx --image=nginx --port 80

After a few seconds, you should be able to see the nginx pod running

.. prompt:: yaml $ auto

    [root@onekube-ip-10-0-17-190 ~]# kubectl get pods
    NAME    READY   STATUS    RESTARTS   AGE
    nginx   1/1     Running   0          12s

In order to access the application, we need to create a Service object that exposes the application.

NodePort Service
++++++++++++++++

One way is to create a `NodePort Service <https://kubernetes.io/docs/concepts/services-networking/service/#nodeport>`_ that opens a specific port on all the cluster VMs, so all traffic sent to this port is forwarded to the Service:

.. prompt:: yaml $ auto

   [root@onekube-ip-10-0-17-190 ~]# kubectl expose pod nginx --type=NodePort --name=nginx

Let's check the service:

.. prompt:: yaml $ auto

    [root@onekube-ip-10-0-17-190 ~]# kubectl get svc
    NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
    kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP        30m
    nginx        NodePort    10.104.44.89   <none>        80:30317/TCP   13s

You can use any public IP of the VMs of the K8s cluster to connect to the nginx application using the port allocated (``30317`` in our case).

|node_port_nginx_welcome_page|

External IP Service
+++++++++++++++++++

.. warning::

    When this kind of service is used then losing the node where the External IP is bound will also drop the access to the service! There is a better approach with LoadBalancer type of service described in the next section.

An alternative way to expose the Service is to use **External IPs** and expose the service directly. In this case, we can use the public IPs of the cluster VMs, or we can add also another public IP by attaching a new NIC (as a Nic Alias) to one of the cluster VMs. In the second case, first of all verify that you have public IPs available from the public network deployed on the edge; if you can then add another IP by following the steps described :ref:`here <edge_public>`

In order to attach a Nic Alias to a VM, go to the ``Instances --> VMs`` tab, select one of the cluster VMs and then select the ``Network`` tab of that VM. Then you press the ``attach_nic`` green button and you can attach a Nic Alias by ticking the option ``Attach as an alias`` and selecting the public network.

|nic_alias_attach|

Check the private IP of the Nic Alias

|nic_alias_attached|

and create the yaml file (service.yaml) using the private IP of the Nic Alias as in the following:

.. prompt:: yaml $ auto

  apiVersion: v1
  kind: Service
  metadata:
    name: nginx
  spec:
    selector:
      app: nginx
    ports:
      - name: http
        protocol: TCP
        port: 80
        targetPort: 80
    externalIPs:
      - 10.0.93.120

then you can deploy the service using

.. prompt:: yaml $ auto

  [root@onekube-ip-10-0-17-190 ~]# kubectl apply -f service.yaml

and you can check the service using

.. prompt:: yaml $ auto

  [root@onekube-ip-10-0-17-190 ~]# kubectl get svc
  NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
  kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP   30m
  nginx        ClusterIP   10.99.198.56   10.0.93.120   80/TCP    8s

Now you can access the application using the public IP of the Nic Alias in the browser:

|external_ip_nginx_welcome_page|

LoadBalancer Service
++++++++++++++++++++

We can improve the previous setup by configuring the Appliance with a `LoadBalancer range <https://docs.opennebula.io/appliances/service/kubernetes.html#k8s-context-param>`_ context parameter (``ONEAPP_K8S_LOADBALANCER_CONFIG`` or ``ONEAPP_K8S_LOADBALANCER_RANGE``) and expose the service as a `Kubernetes type LoadBalancer <https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer>`_.

.. important::

    **The range must match the actually intended range of publishable IP addresses!**

    E.g. in this scenario we could setup:

    .. code::

        ONEAPP_K8S_LOADBALANCER_RANGE="10.0.93.120-10.0.93.120"

    Our range spans only one address because we have only one available IP address for loadbalancing.

The setup is very similar to the previous one but when we are creating the NIC alias we will also tick the ``External`` checkbox button. This way the IP will not be actually assigned anywhere but it will be reserved for our loadbalancing usage.

The effect can be achieved with this command:

.. prompt:: yaml $ auto

   [root@onekube-ip-10-0-17-190 ~]# kubectl expose pod nginx --type=LoadBalancer --name=nginx --load-balancer-ip=10.0.93.120


The advantage is that there is no one node where is this External IP bound. The whole Kubernetes cluster *owns* it and when the node - which is actually responding to this IP - fails then the IP will *flow* accross the cluster to the next healthy node thanks to the LoadBalancer service.

.. note::

    If the reader understands how the `Keepalived <https://www.keepalived.org/>`_ functions then this is very similar. The difference is that the provider of the LoadBalancer is not assigning the IP(s) on the cluster nodes but it just replies to the ARP requests or sends *gratuitous* ARP messages when failover needs to happen. For more info read the official documentation of the LoadBalancer which the Appliance is using: `MetalLB ARP/Layer2 <https://metallb.universe.tf/concepts/layer2/>`_.

Congrats! You successfully deployed a fully functional Kubernetes cluster in the edge. Have fun with your new OpenNebula cloud!

.. |nginx_install_page| image:: /images/nginx_install_page.png
.. |node_port_nginx_welcome_page| image:: /images/node_port_nginx_welcome_page.png
.. |external_ip_nginx_welcome_page| image:: /images/external_ip_nginx_welcome_page.png
.. |nic_alias_attach| image:: /images/nic_alias_attach.png
.. |nic_alias_attached| image:: /images/nic_alias_attached.png
