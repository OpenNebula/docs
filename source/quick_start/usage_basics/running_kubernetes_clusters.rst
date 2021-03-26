.. _running_kubernetes_clusters:

============================
Running Kubernetes Clusters
============================

In the public OpenNebula System marketplace there are also services available that lets you deploy a multi-VM application. In this exercise we are going to import a Kubernetes cluster service and launch a Kubernetes cluster with it.

.. warning:: We need a metal KVM edge cluster for this. If you haven't already done so, you can follow the same steps of the :ref:`provisioning an edge cluster <first_edge_cluster>` guide, using "metal" edge cloud type and kvm hypervisor. Make sure you request two public IPs.

We are going to assume the edge cluster naming schema "metal-kvm-aws-cluster".

Step 1. Download the OneFlow Service from the marketplace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Login into Sunstone as oneadmin. Go to the ``Storage --> Apps`` tab, and search for Kubernetes. Select the "Service Kubernetes X.XX for OneFlow - KVM" and click on the icon with the cloud and the down arrow inside (two positions to the left from the green "+").

|kubernetes_marketplace|

Now you need to select a datastore, select the metal-kvm-aws-cluster-images datastore.

|metal_kvm_aws_cluster_images_datastore|

The appliance will be ready when the image in ``Storage --> Images`` gets in READY from LOCKED state.

.. |kubernetes_marketplace| image:: /images/kubernetes_marketplace.png
.. |metal_kvm_aws_cluster_images_datastore| image:: /images/metal_kvm_aws_cluster_images_datastore.png

Step 2. Instantiate the Kubernetes Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Proceed to the ``Templates --> Services`` tab and select the "Service Kubernetes 1.18 for OneFlow - KVM" Service Template (that should be the only one available``). Click on "+" and then Instantiate.

A required step is clicking on Network and selecting the metal-kvm-aws-cluster-public network.

|select_metal_aws_cluster_public_network|

Feel free to modify the capacity and to input data to configure the Kubernetes cluster.

|configure_kubernetes_cluster|

Now proceed to ``Instances --> Services`` and wait for the only Service there to get into RUNNING state. You can also check the VMs being deployed in ``Instances --> VMs``.

.. note:: Even though Sunstone shows the VNC console button, VNC access to Containers or VMs running in edge clusters has been deemed insecure and as such OpenNebula filters this traffic. This means that the VNC access won't work to VMs running in edge clusters.

.. |select_metal_aws_cluster_public_network| image:: /images/select_metal_aws_cluster_public_network.png
.. |configure_kubernetes_cluster| image:: /images/configure_kubertes_cluster.png

Step 3. Validate the Kubernetes cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once the service is in RUNNING state, you can start using the Kubernetes cluster. Let's login first into the Kubernetes cluster master. Go to ``Instances --> VMs`` and check the public IP (from the dropdown, the one highlighted in bold).

We'll use the "oneadmin" account in your OpenNebula front-end. Please ssh to the front-end first, and from there as oneadmin, ssh in to the Kubernetes cluster master as "root". You should be greeted with the following message:

.. prompt:: bash $ auto

        ___   _ __    ___
       / _ \ | '_ \  / _ \   OpenNebula Service Appliance
      | (_) || | | ||  __/
       \___/ |_| |_| \___|

     All set and ready to serve 8)

You can use the file in ``/root/.kube/config`` to control the Kubernetes clusters from the outside. We are going to use the root account in the master to perform a simple validation of the cluster.

First step is to check the workers are healthy. You should get a similar output as:

.. prompt:: bash $ auto

    [root@onekube-ip-10-0-17-190 .kube]# kubectl get nodes
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


Now is time to apply it in Kubernetes:

.. prompt:: bash $ auto

   kubectl apply -f kubetest_1pod.yaml

After a few seconds, you should be able to see the simple pod in Running state:

.. prompt:: bash $ auto

   [root@onekube-ip-10-0-17-190 ~]# kubectl get pod
   NAME                        READY   STATUS    RESTARTS   AGE
   kubetest-6bfc69d7ff-fcl22   1/1     Running   0          8m13s

Congrats! You successfully deployed a fully functional Kubernetes cluster in the edge. Have fun with your new OpenNebula cloud!

Step 4. Deploying a Helm Chart
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
