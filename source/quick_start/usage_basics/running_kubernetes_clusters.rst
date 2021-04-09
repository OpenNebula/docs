.. _running_kubernetes_clusters:

============================
Running Kubernetes Clusters
============================

In the public OpenNebula System Marketplace there are also services available that let you deploy a multi-VM application. In this exercise we are going to import a Kubernetes cluster service and launch a Kubernetes cluster with it.

.. warning:: We need a metal KVM Edge Cluster for this. If you haven't already done so, you can follow the same steps of the :ref:`provisioning an edge cluster <first_edge_cluster>` guide, using "metal" edge cloud type and kvm hypervisor. Make sure you request two public IPs.

We are going to assume the Edge Cluster naming schema "metal-kvm-aws-cluster".

Step 1. Download the OneFlow Service from the Marketplace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Log in to Sunstone as oneadmin. Go to the ``Storage --> Apps`` tab and search for Kubernetes. Select the "Service Kubernetes X.XX for OneFlow - KVM" and click on the icon with the cloud and the down arrow inside (two positions to the left from the green "+").

|kubernetes_marketplace|

Now you need to select a datastore. Select the metal-kvm-aws-cluster-Images Datastore.

|metal_kvm_aws_cluster_images_datastore|

The appliance will be ready when the image in ``Storage --> Images`` switches to READY from its LOCKED state.

.. |kubernetes_marketplace| image:: /images/kubernetes_marketplace.png
.. |metal_kvm_aws_cluster_images_datastore| image:: /images/metal_kvm_aws_cluster_images_datastore.png

Step 2. Instantiate the Kubernetes Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Proceed to the ``Templates --> Services`` tab and select the "Service Kubernetes 1.18 for OneFlow - KVM" Service Template (that should be the only one available``). Click on "+" and then Instantiate.

A required step is clicking on Network and selecting the metal-kvm-aws-cluster-public network.

|select_metal_aws_cluster_public_network|

Feel free to modify the capacity and to input data to configure the Kubernetes cluster.

|configure_kubernetes_cluster|

Now proceed to ``Instances --> Services`` and wait for the only Service there to get into a RUNNING state. You can also check the VMs being deployed in ``Instances --> VMs``.

.. note:: Even though Sunstone shows the VNC console button, VNC access to Containers or VMs running in Edge Clusters has been deemed insecure and as such OpenNebula filters this traffic. This means that the VNC access won't work for VMs running in Edge Clusters.

.. |select_metal_aws_cluster_public_network| image:: /images/select_metal_aws_cluster_public_network.png
.. |configure_kubernetes_cluster| image:: /images/configure_kubertes_cluster.png

Step 3. Validate the Kubernetes cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once the service is in RUNNING state, you can start using the Kubernetes cluster. Let's first log in to the Kubernetes cluster master. Go to ``Instances --> VMs`` and check the public IP (from the dropdown, the one highlighted in bold).

We'll use the "oneadmin" account in your OpenNebula Front-end. Please SSH to the Front-end first, and from there, as oneadmin, you should SSH in to the Kubernetes cluster master as "root". You should be greeted with the following message:

.. prompt:: bash $ auto

        ___   _ __    ___
       / _ \ | '_ \  / _ \   OpenNebula Service Appliance
      | (_) || | | ||  __/
       \___/ |_| |_| \___|

     All set and ready to serve 8)

.. note:: You can use the file in ``/etc/kubernetes/admin.conf`` to control the Kubernetes clusters from the outside. When the Kubernetes Appliance is deployed on the edge, once you copy the ``/etc/kubernetes/admin.conf`` in your system (laptop, workstation), you need to replace in the configuration file the private IP with the public IP of the master VM. Furthermore, you have to use the kubectl option ``--insecure-skip-tls-verify`` every time you perform some operation on the cluster, since the certificate is not valid for the public IP. This will be fixed in a future release of the appliance.

We are going to use the root account in the master to perform a simple validation of the cluster. The first step is to check the workers are healthy. You should get a similar output to:

.. prompt:: yaml $ auto

    [root@onekube-ip-10-0-17-190 ~]# kubectl get nodes
    NAME                                  STATUS   ROLES    AGE   VERSION
    onekube-ip-10-0-109-134.localdomain   Ready    <none>   27m   v1.18.10
    onekube-ip-10-0-17-190.localdomain    Ready    master   29m   v1.18.10

Now create a file "kubetest_1pod.yaml" with the following contents:

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

One way is to create a NodePort Service that opens a specific port on all the cluster VMs, so all traffic sent to this port is forwarded to the Service:

.. prompt:: yaml $ auto

   [root@onekube-ip-10-0-17-190 ~]# kubectl expose pod nginx --type=NodePort --name=nginx

Let's check the service:

.. prompt:: yaml $ auto

    [root@onekube-ip-10-0-17-190 ~]# kubectl get svc
    NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
    kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP        30m
    nginx        NodePort    10.104.44.89   <none>        80:30317/TCP   13s

You can use any public IP of the VMs of the K8s cluster to connect to the nginx application using the port allocated (30317 in our case).

|node_port_nginx_welcome_page|

An alternative way to expose the Service is to use External IPs. In this case, we can use the public IPs of the cluster VMs, or we can add also another public IP by attaching a new NIC (as a Nic Alias) to one of the cluster VMs. In the second case, first of all verify that you have public IPs available from the public network deployed on the edge; in case you can add another IP by following the steps described :ref:`here <edge_public>`

In order to attach a Nic Alias to a VM, go to the ``Instances --> VMs`` tab, select one of the cluster VMs and then select the Network tab of that VM. Then you press the ``attach_nic`` green button and you can attach a Nic Alias by ticking the option ``Attach as an alias`` and selecting the public network.

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

.. note:: The K8s appliance at the moment supports only the NodePort and External IPs services to expose applications. The Load Balancer service will be provided in a future release of the appliance.

Congrats! You successfully deployed a fully functional Kubernetes cluster in the edge. Have fun with your new OpenNebula cloud!

.. |nginx_install_page| image:: /images/nginx_install_page.png
.. |node_port_nginx_welcome_page| image:: /images/node_port_nginx_welcome_page.png
.. |external_ip_nginx_welcome_page| image:: /images/external_ip_nginx_welcome_page.png
.. |nic_alias_attach| image:: /images/nic_alias_attach.png
.. |nic_alias_attached| image:: /images/nic_alias_attached.png
