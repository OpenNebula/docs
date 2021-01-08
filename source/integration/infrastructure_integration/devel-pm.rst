.. _devel-pm:

================================================================================
Provision Driver
================================================================================

The provision driver communicates with the remote infrastructure provider (e.g. bare metal cloud hosting) to allocate and control new resources. These resources are expected to be later added into the OpenNebula as virtualization hosts, and can represent new individual bare metal hosts (e.g., to act as KVM hypervisors) or VMware vCenter.

The OpenNebula server isn't dealing directly with the provision drivers. Standalone tool ``oneprovision`` provides full interaction between the drivers (triggering particular driver actions) and the OpenNebula (creating and managing provisioned host objects).

The structure of the driver with actions is very similar to the :ref:`Virtualization Driver <devel-vmm>`, the main difference is the type of objects the drivers deal with. The virtualization driver works with the OpenNebula VMs, but the provision driver works with the OpenNebula hosts.

Actions
================================================================================

Every action should have an executable program (mainly scripts) located in the remote dir (``remotes/pm/<driver_directory>``) that performs the desired action. These scripts receive some parameters (and in the case of ``DEPLOY`` also STDIN) and give back the error message or information in some cases writing to STDOUT.

.. note::

    Except the listed arguments, all action scripts also get following arguments after all specified arguments:

    - **HOST\_ID** - ID of the OpenNebula host
    - **HOST** - Name of the OpenNebula host

Provision actions, they are the same as the names of the scripts:

-  **cancel**: Destroy a provision

   -  Arguments:

      -  **DEPLOY\_ID**: Provision deployment ID
      -  **HOST**: Name of OpenNebula host

   -  Response

      -  Success: -
      -  Failure: Error message

-  **deploy**: Create new provision

   -  Arguments:

      -  **DEPLOYMENT\_FILE**: where to write the deployment file. You have to write whatever comes from STDIN to a file named like this parameter. In shell script you can do: ``cat > $domain``
      -  **HOST**: Name of OpenNebula host

   -  Response

      -  Success: Deploy ID, unique identification from provider
      -  Failure: Error message

-  **poll**: Get information about a provisioned host

   -  Arguments:

      -  **DEPLOY\_ID**: Provision deployment ID
      -  **HOST**: Name of OpenNebula host

   -  Response

      -  Success: Output as for **poll** action in the :ref:`Virtualization Driver <devel-vmm>`
      -  Failure: Error message

-  **reboot**: Orderly reboots a provisioned host

   -  Arguments:

      -  **DEPLOY\_ID**: Provision deployment ID
      -  **HOST**: Name of OpenNebula host

   -  Response

      -  Success: -
      -  Failure: Error message

-  **reset**: Hard reboots a provisioned host

   -  Arguments:

      -  **DEPLOY\_ID**: Provision deployment ID
      -  **HOST**: Name of OpenNebula host

   -  Response

      -  Success: -
      -  Failure: Error message

-  **shutdown**: Orderly shutdowns a provisioned host

   -  Arguments:

      -  **DEPLOY\_ID**: Provision deployment ID
      -  **HOST**: Name of OpenNebula host
      -  **LCM\_STATE**: Emulated LCM_STATE string

   -  Response

      -  Success: -
      -  Failure: Error message

Deployment File
================================================================================

The deployment file contains the OpenNebula host XML object representation. It's may be used in the situation when OpenNebula host still isn't in the database and doesn't have host ID assigned, but the driver actions need to work with its metadata.

Example:

.. code::

    <HOST>
      <NAME>provision-c968cbcf40716f8e18caddbb8757c2ca7ed0942a357d511b</NAME>
      <IM_MAD>kvm</IM_MAD>
      <VM_MAD>kvm</VM_MAD>
      <TEMPLATE>
        <IM_MAD>kvm</IM_MAD>
        <VM_MAD>kvm</VM_MAD>
        <PROVISION>
          <PLAN>baremetal_0</PLAN>
          <HOSTNAME>TestOneProvision1-C7</HOSTNAME>
          <BILLING_CYCLE>hourly</BILLING_CYCLE>
          <OS>centos_7</OS>
        </PROVISION>
        <PROVISION_CONFIGURATION_BASE64>*****</PROVISION_CONFIGURATION_BASE64>
        <PROVISION_CONFIGURATION_STATUS>pending</PROVISION_CONFIGURATION_STATUS>
        <PROVISION_CONNECTION>
          <REMOTE_USER>root</REMOTE_USER>
          <REMOTE_PORT>22</REMOTE_PORT>
          <PUBLIC_KEY>/var/lib/one/.ssh/ddc/id_rsa.pub</PUBLIC_KEY>
          <PRIVATE_KEY>/var/lib/one/.ssh/ddc/id_rsa</PRIVATE_KEY>
        </PROVISION_CONNECTION>
        <CONTEXT>
          <SSH_PUBLIC_KEY>*****</SSH_PUBLIC_KEY>
        </CONTEXT>
      </TEMPLATE>
    </HOST>

