.. _ec2qug:

================================================================================
OpenNebula EC2 Usage
================================================================================

The `EC2 Query API <http://docs.amazonwebservices.com/AWSEC2/latest/DeveloperGuide/index.html?using-query-api.html>`__ offers the functionality exposed by Amazon EC2: upload images, register them, run, monitor and terminate instances, etc. In short, Query requests are HTTP or HTTPS requests that use the HTTP verb GET or POST and a Query parameter.

OpenNebula implements a subset of the EC2 Query interface, enabling the creation of public clouds managed by OpenNebula.

AMIs
--------------------------------------------------------------------------------

-  **upload image**: Uploads an image to OpenNebula
-  **register image**: Register an image into OpenNebula
-  **describe images**: Lists all registered images belonging to one particular user.

Instances
--------------------------------------------------------------------------------

-  **run instances**: Runs an instance of a particular image (that needs to be referenced).
-  **describe instances**: Outputs a list of launched images belonging to one particular user.
-  **terminate instances**: Shuts down a set of virtual machines (or cancels, depending on their state).
-  **reboot instances**: Reboots a set of virtual machines.
-  **start instances**: Starts a set of virtual machines.
-  **stop instances**: Stops a set of virtual machines.

EBS
--------------------------------------------------------------------------------

-  **create volume**: Creates a new DATABLOCK in OpenNebula
-  **delete volume**: Deletes an existing DATABLOCK.
-  **describe volumes**: Describe all available DATABLOCKs for this user
-  **attach volume**: Attaches a DATABLOCK to an instance
-  **detach volume**: Detaches a DATABLOCK from an instance

-  **create snapshot**:
-  **delete snapshot**:
-  **describe snapshot**:

Elastic IPs
--------------------------------------------------------------------------------

-  **allocate address**: Allocates a new elastic IP address for the user
-  **release address**: Releases a publicIP of the user
-  **describe addresses**: Lists elastic IP addresses
-  **associate address**: Associates a publicIP of the user with a given instance
-  **disassociate address**: Disassociate a publicIP of the user currently associated with an instance

Keypairs
--------------------------------------------------------------------------------

-  **create keypair**: Creates the named keypair
-  **delete keypair**: Deletes the named keypair, removes the associated keys
-  **describe keypairs**: List and describe the key pairs available to the user

Tags
--------------------------------------------------------------------------------

-  **create-tags**
-  **describe-tags**
-  **remove-tags**

The description of the commands can be accessed from the :ref:`Command Line Reference <cli>`.

User Account Configuration
================================================================================

An account is needed in order to use the OpenNebula cloud. The cloud administrator will be responsible for assigning these accounts, which have a one to one correspondence with OpenNebula accounts, so all the cloud administrator has to do is check the :ref:`configuration guide to setup accounts <ec2qcg_cloud_users>`, and automatically the OpenNebula cloud account will be created.

In order to use such an account, end users can make use of clients programmed to access the services described in the previous section. For this they have to set up their environment, particularly the following aspects:

-  **Authentication**: This can be achieved in three different ways, here listed in order of priority (i.e. values specified in the argument line supersede environmental variables)

   -  Using the **commands arguments**. All the commands accept an **Access Key** (as the OpenNebula username) and a **Secret Key** (as the OpenNebula hashed password)
   -  Using **EC2\_ACCESS\_KEY** and **EC2\_SECRET\_KEY** environment variables the same way as the arguments
   -  If none of the above is available, the **ONE\_AUTH** variable will be checked for authentication (with the same used for OpenNebula CLI).

-  **Server location**: The command needs to know where the OpenNebula cloud service is running. That information needs to be stored within the **EC2\_URL** environment variable (in the form of an HTTP URL, including the port if it is not the standard 80).

.. warning:: The ``EC2_URL`` has to use the FQDN of the EC2-Query Server

Hello Cloud!
================================================================================

Let's take a walk through a typical usage scenario. In this brief scenario it will be shown how to upload an image to the OpenNebula image repository, how to register it in the OpenNebula cloud and perform operations upon it.

-  **upload\_image**

Assuming we have a working Gentoo installation residing in an **.img** file, we can upload it into the OpenNebula cloud using the ``econe-upload`` command:

.. prompt:: bash $ auto

    $ econe-upload /images/gentoo.img
    Success: ImageId ami-00000001
    $ econe-register ami-00000001
    Success: ImageId ami-00000001

-  **describe\_images**

We will need the **ImageId** to launch the image, so in case we have forgotten, we can list registered images using the ``econe-describe-images`` command:

.. prompt:: bash $ auto

    $ econe-describe-images -H
    Owner        ImageId       Status         Visibility   Location
    ------------------------------------------------------------------------------
    helen        ami-00000001  available      private      19ead5de585f43282acab4060bfb7a07

-  **run\_instance**

Once we recall the ImageId, we will need to use the ``econe-run-instances`` command to launch a Virtual Machine instance of our image:

.. prompt:: bash $ auto

    $ econe-run-instances -H ami-00000001
    Owner       ImageId                InstanceId InstanceType
    ------------------------------------------------------------------------------
    helen       ami-00000001           i-15       m1.small

We will need the **InstanceId** to monitor and shutdown our instance, so we better write that down: ``i-15``.

-  **describe\_instances**

If we have too many instances launched and we don't remember all of them, we can ask ``econe-describe-instances`` to show us which instances we have submitted.

.. prompt:: bash $ auto

    $ econe-describe-instances  -H
    Owner       Id    ImageId      State         IP              Type
    ------------------------------------------------------------------------------------------------------------
    helen       i-15  ami-00000001 pending       147.96.80.33    m1.small

We can see that the instance with Id ``i-15`` has been launched, but it is still pending, i.e., it still needs to be deployed into a physical host. If we try the same command again after a short while, we should see it running, as in the following excerpt:

.. prompt:: bash $ auto

    $ econe-describe-instances  -H
    Owner       Id    ImageId      State         IP              Type
    ------------------------------------------------------------------------------------------------------------
    helen       i-15  ami-00000001 running      147.96.80.33     m1.small

-  **terminate\_instances**

After we put the Virtual Machine to a good use, it is time to shut it down to make space for other Virtual Machines (and, presumably, to stop being billed for it). For that we can use ``econe-terminate-instances``, passing to it as an argument the **InstanceId** that identifies our Virtual Machine:

.. prompt:: bash $ auto

    $ econe-terminate-instances i-15
    Success: Terminating i-15 in running state

.. note:: You can obtain more information on how to use the above commands from their Usage help by passing them the ``-h`` flag.
