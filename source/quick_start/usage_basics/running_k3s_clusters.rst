.. _running_k3s_clusters:

=====================
Running K3S Clusters
=====================

In the public OpenNebula System marketplace there are services available that lets you deploy a multi-VM application. In this case, we are going to import a K3S cluster service and launch a K3s cluster with it.

.. warning:: We need a metal Firecracker edge cluster for this. If you haven't already done so, you can follow the same steps of the :ref:`provisioning an edge cluster <first_edge_cluster>` guide, using "metal" edge cloud type and firecracker hypervisor. Make sure you request two public IPs.

We are going to assume the edge cluster has been named "fc-metal-aws-cluster".

Step 1. Download the OneFlow K3s Service from the Marketplace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Login into Sunstone as oneadmin. Go to the ``Storage --> Apps`` tab, and search for K3s. Select the "Service K3Ss - Firecracker" and click on the icon with the cloud and the down arrow inside (two positions to the right from the green "+").

|k3s_marketplace|

Now you need to select a datastore, select the fc-metal-aws-cluster-image datastore.

|k3s_fc_metal_aws_cluster_image_datastore|

The appliance will be ready when the image in ``Storage --> Images`` (named "Service K3s - Firecracker-0") gets in READY from LOCKED state.

.. |k3s_marketplace| image:: /images/k3s_marketplace.png
.. |k3s_fc_metal_aws_cluster_image_datastore| image:: /images/k3s_fc_metal_aws_cluster_image_datastore.png

Step 2. Import the Kernel and Update the K3s VM Template
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In order to deploy Firecracker microVMs, you need to import a kernel from the MarketPlace. Go to ``Storage --> Apps`` tab, and search for kernel. Select "Kernel 4.19 x86_64 - Firecracker" and click on the icon with the cloud and the down arrow inside (two positions to the right from the green "+"). 

|k3s_kernel_marketplace|

You need to select the files datastore to download the kernel.

|k3s_kernel_files_datastore|

You need to modify the k3s VM template to add the kernel just imported. Proceed to the ``Templates --> VMs`` tab and select the ``Service K3s - Firecracker-0`` VM Template. Click on update, proceed to the OS&CPU tab and in the kernel section select "Kernel 4.19 x86_64 - Firecracker".

|add_kernel_k3s_vm_template|

.. |k3s_kernel_marketplace| image:: /images/k3s_kernel_marketplace.png
.. |k3s_kernel_files_datastore| image:: /images/k3s_kernel_files_datastore.png
.. |add_kernel_k3s_vm_template| image:: /images/add_kernel_k3s_vm_template.png


Step 3. Instantiate the K3s Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Proceed to the ``Templates --> Services`` tab and select the "Service K3s - Firecracker" Service Template. Click on "+" and then Instantiate. In the Custom Attribute section, write the name of the cluster where to deploy the service, that is fc-metal-aws-cluster.

|instantiate_cluster_k3s_service|

Now proceed to ``Instances --> Services`` and wait for the only Service there to get into RUNNING state. You can also check the VMs being deployed in ``Instances --> VMs``.

|k3s_service_running|

|k3s_service_vm_running|

.. note:: Even though Sunstone shows the VNC console button, VNC access to Containers or VMs running in edge clusters has been deemed insecure and as such OpenNebula filters this traffic. This means that the VNC access won't work to VMs running in edge clusters.

.. |instantiate_cluster_k3s_service| image:: /images/k3s_service_instantiate.png
.. |k3s_service_running| image:: /images/k3s_service_running.png
.. |k3s_service_vm_running| image:: /images/k3s_service_vm_running.png


Step 3. Validate the K3s cluster and Deploy an Application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once the service is in RUNNING state, you can start using the K3s cluster. Let's login first into the K3s server node. Go to ``Instances --> VMs`` and check the public IP of the server VM (from the dropdown, the one highlighted in bold).

|k3s_server_public_ip|

We'll use the "oneadmin" account in your OpenNebula front-end. Please ssh to the front-end first, and from there as oneadmin, ssh in to the K3s cluster server node as "root".

You can use the file in ``/etc/rancher/k3s/k3s.yaml`` to control the K3s cluster from the outside. We are going to use the root account in the server node to deploy an nginx application.

First step is to check if the cluster is healthy. You should get a similar output as:

.. prompt:: bash $ auto

    root@k3s-server-0:~# k3s kubectl get nodes
    NAME           STATUS   ROLES    AGE   VERSION
    k3s-server-0   Ready    master   88s   v1.17.17+k3s1
    k3s-agent-1    Ready    <none>   64s   v1.17.17+k3s1

Now deploy nginx on the cluster:

.. prompt:: yaml $ auto

    root@k3s-server-0:~# k3s kubectl create deployment nginx --image=nginx
   
After a few seconds, you should be able to see the deployment

.. prompt:: bash $ auto

    root@k3s-server-0:~# k3s kubectl get deployment
    NAME    READY   UP-TO-DATE   AVAILABLE   AGE
    nginx   1/1     1            1           7s   

and the related pod in running state

.. prompt:: bash $ auto

    root@k3s-server-0:~# k3s kubectl get pods
    NAME                     READY   STATUS    RESTARTS   AGE
    nginx-86c57db685-4bmv4   1/1     Running   0          36s

Now create a Service object that exposes the nginx deployment:

.. prompt:: bash $ auto

    root@k3s-server-0:~# k3s kubectl expose deployment nginx --type=LoadBalancer --port 8080 --target-port 80 --name=nginx

Let's check the service:

.. prompt:: bash $ auto

    root@k3s-server-0:~# k3s kubectl get svc
    NAME         TYPE           CLUSTER-IP    EXTERNAL-IP                  PORT(S)          AGE
    kubernetes   ClusterIP      10.43.0.1     <none>                       443/TCP          4m46s
    nginx        LoadBalancer   10.43.89.55   18.168.60.179,52.56.88.133   8080:31087/TCP   11s

and use one of the EXTERNAL IPs to connect to the nginx application using the port 8080

|nginx_install_page|

Congrats! You successfully deployed a fully functional K3s cluster in the edge. Have fun with your new OpenNebula cloud!

.. |k3s_server_public_ip| image:: /images/k3s_server_public_ip.png
.. |nginx_install_page| image:: /images/nginx_install_page.png
