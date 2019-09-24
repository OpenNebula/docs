.. _hooks:

================================================================================
Using Hooks
================================================================================

The Hook systems enables the triggering of custom scripts tied to a change in state in a particular resource, or API call. This opens a wide area of automation for system administrators to tailor their cloud infrastructures.

Overview
================================================================================

The hook subsystem allows to manage the hooks dynamically (create, delete, update,...) and also allows to check the result of each execution and retry it if necessary.

The hook subsystem have 2 main components:

- **Hook Manager Driver**: it receive information about every event triggered in oned a publish it in the event queue. This queue can be used for developing external components, more information is available :ref:`here <hook_manager_events>`.
- **Hook Execution Manager** (HEM): It load all the hooks of the system and subscribe to the event of each hooks, when an event is received in the HEM it take care of executing the corresponding hook with the conditions defined for it.

|hook-subsystem|

Both components are started with OpenNebula daemon. It would be possible to deploy the **HEM** in a different host than oned daemon but this is not recommended for security reasons.

The hook log, which allows to check the result of the different execution of a hook is managed by the oned daemon.

Configuration
================================================================================

Hook Manager
--------------------------------------------------------------------------------

Hook Manager configuration is set in ``HM_MAD`` section inside ``/etc/one/oned.conf``. The configuration attributes are available in the table below:

+-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Parameter   | Description                                                                                                                                                               |
+=============+===========================================================================================================================================================================+
| Executable  | Path of the hook driver executable, can be an absolute path or relative to $ONE_LOCATION/lib/mads (or /usr/lib/one/mads/ if OpenNebula was installed in /)                |
+-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Arguments   | Arguments for the driver executable, the following values are supported:                                                                                                  |
|             |                                                                                                                                                                           |
|             | - ``--publisher-port``, ``-p``: The port where the Hook Manager will publish the events reported by oned.                                                                 |
|             | - ``--logger-port``,    ``-l``: The port where the Hook Manager will receive information about hook executions.                                                           |
|             | - ``--hwm``,            ``-h``: The HWM value for the publisher socket, more information can be found `here: <http://zguide.zeromq.org/page:all#High-Water-Marks>`__.     |
|             | - ``--bind``,           ``-b``: Address where the publisher socket will be binded.                                                                                        |
+-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Hook Execution Manager
--------------------------------------------------------------------------------

Hook Execution Manager configuration is set in ``/etc/one/onehem-server.conf``. The configuration attributes are available in the table below:

+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Parameter             | Description                                                                                                                                                               |
+=======================+===========================================================================================================================================================================+
| debug_level           | Set the log debug level shown in ``/var/log/one/onehem-server.log``                                                                                                       |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| hook_base_path        | Location of hook scripts when commands not given as an absolute path (default value ``/var/lib/one/remotes/hooks``)                                                       |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| subscriber_endpoint   | To subscribe for OpenNebula events must match those in ``HM_MAD`` section of ``oned.conf``.                                                                               |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| replier_endpoint      | To send to oned hook execution results (reply to events) must match those in ``HM_MAD`` section of ``oned.conf``.                                                         |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| concurrency           | Number of hooks executed simultaneously.                                                                                                                                  |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Hook Log
--------------------------------------------------------------------------------

The number of execution log records stored in the database for each hook can be configured in `oned.conf`:

.. code::

    HOOK_LOG_CONF = [
        LOG_RETENTION = 10 ]

With `LOG_RETENTION = 10` as in the example above, the cloud admin will only able to see the last 10 execution record of each hooks. This value can be tunned taking into account the number of hooks and how many times a hooks is executed.2

Hook Types
================================================================================

There are two Hook Types, **API hooks** and **State Hooks** they have some commons options, which are listed below, and some own options which will be described in the corresponding section of each hook type.

+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Option                | Mandatory | Description                                                                                                                                                    |
+=======================+===========+================================================================================================================================================================+
| NAME                  | YES       | The name of the hook.                                                                                                                                          |
+-----------------------+-----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| COMMAND               | YES       | The command that will be executed when hook is triggered. Typically a path to a script.                                                                        |
+-----------------------+-----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ARGUMENTS             | NO        | The arguments that will be passe to the script when the Hook is triggered.                                                                                     |
+-----------------------+-----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ARGUMENTS_STDIN       | NO        | If ``yes`` the ARGUMENTS will be passed through STDIN instead of as command line arguments.                                                                    |
+-----------------------+-----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------+
| TYPE                  | YES       | The hook type either ``api`` or ``state``.                                                                                                                     |
+-----------------------+----------++----------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _api_hooks:

API Hooks
--------------------------------------------------------------------------------

The API Hooks are triggered when a determined API call arrives to oned. The custom attributes for API Hooks are listed below:

+-----------------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Option                | Mandatory | Description                                                                                                                                                   |
+=======================+===========+===============================================================================================================================================================+
| CALL                  | YES       | The API call which trigger the hook. For more info about API calls please check :ref:`XML-RPC API section. <api>`                                             |
+-----------------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------+

When an API Hook is defined, ``$API`` can be used inside ``ARGUMENTS`` attribute to send information about the API call. If ``$API`` is used, a base64 encoded xml document containing the value of the API call arguments and the output of the call will be pass to the script/command defined in ``COMMAND`` attribute. The schema of the XML is defined here: <TODO LINK XSD DOCUMENT>

.. note:: If the API call defined in ``CALL`` corresponds with an ``allocate`` or ``delete`` call and ``$API`` is used,  the template of the resource will be sent along with the API call information.

Here can be found an example of API hook which does use the $API option:

.. code::

    NAME      = hook-API
    TYPE      = api
    COMMAND   = "log_new_user.rb"
    ARGUMENTS = $API
    CALL      = "one.user.allocate"
    ARGUMENTS_STDIN = yes

.. _state_hooks:

State Hooks
--------------------------------------------------------------------------------

The State Hooks are only available for **Hosts** and **Virtual Machines** and they are triggered when the resource switch to a determined state. The custom attributes for State Hooks are listed below:

+-----------------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Option                | Mandatory | Description                                                                                                                                                                     |
+=======================+===========+=================================================================================================================================================================================+
| RESOURCE              | YES       | Type of the resource, supported values are ``HOST`` and ``VM``.                                                                                                                 |
+-----------------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| REMOTE                | NO        | If ``yes`` the hook will be executed in the Host which trigger the hook (if ``RESOURCE=HOST``) or in the host where the VM is running (if ``RESOURCE=VM``)                      |
+-----------------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| STATE                 | YES       | The state in which the hook will be triggered.                                                                                                                                  |
+-----------------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| LCM_STATE             | YES       | The lcm state in which the hook will be triggered. (Only if ``RESOURCE=VM``)                                                                                                    |
+-----------------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ON                    | YES       | If ``RESOURCE=VM`` the STATE and LCM_STATE attributes can be avoided by using this attribute. Supported values are: CREATE, RUNNING, SHUTDOWN, STOP, DONE, UNKNOWN, CUSTOM      |
+-----------------------+-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. warning:: Note that ``ON`` attribute is mandatory when ``RESOURCE=VM``, if a value different from ``CUSTOM`` is specified, ``STATE`` and ``LCM_STATE`` can be avoided. Use ``ON=CUSTOM`` with ``STATE`` and ``LCM_STATE`` for defining hooks which will be triggered in states different than the ones supported by ``ON``.

For State Hooks, ``$TEMPLATE`` can be used inside ``ARGUMENTS`` attribute to send the template (in XML format) of the resource which triggered the hook to the hook script/command.

.. note:: The resource template sent to the script/command when $TEMPLATE is used will be encoded using base64.

Here can be found an example of a State Hook for a VM and a Host:

.. code::

    # VM
    NAME = hook-vm
    TYPE = state
    COMMAND = new_vm.rb
    ARGUMENTS = $TEMPLATE
    ON = PROLOG
    RESOURCE = VM

    # HOST
    NAME = hook-host
    TYPE = state
    COMMAND = host-disabled.rb
    STATE = DISABLED
    RESOURCE = HOST
    REMOTE = yes

.. note:: More info about VM and Host state can be found :ref:`here <vm_states>` and :ref:`here <host_states>`

Managing Hooks
================================================================================

Hooks can be managed via CLI and via API. We will see the hook life cycle in the following sections.

Creating Hooks
--------------------------------------------------------------------------------

In order to create a new Hook we need to define a Hook template:

.. code::

   $ cat > hook.tmpl << EOF
        NAME      = hook-vm
        TYPE      = state
        COMMAND   = vm-pending.rb
        ARGUMENTS = "\$TEMPLATE pending"
        ON        = CUSTOM
        RESOURCE  = VM
        STATE     = PENDING
        LCM_STATE = LCM_INIT
    EOF

Once the template is defined we can create the hook by running the following command:

.. code::

    $ onehook create hook.tmpl
      ID: 0

We have just created a hook which will be triggered each time a VM switch to PENDING state.

Checking Hooks Execution
--------------------------------------------------------------------------------

We can check the hook executions by running `onehook show 0`:

.. code::

    $ onehook show 0
      HOOK 0 INFORMATION
      ID                : 0
      NAME              : hook-vm
      TYPE              : state
      LOCK              : None

      HOOK TEMPLATE
      ARGUMENTS="$TEMPLATE pending"
      COMMAND="vm-pending.rb"
      LCM_STATE="LCM_INIT"
      REMOTE="NO"
      RESOURCE="VM"
      STATE="PENDING"

No execution info is shown as we do not have triggered the hook yet. Lets trigger the hook and see what happens:

.. code::

    $ onevm create --cpu 1 --memory 2 --name test
      ID: 0
    $ onehook show 0
      HOOK 0 INFORMATION
      ID                : 0
      NAME              : hook-vm
      TYPE              : state
      LOCK              : None

      HOOK TEMPLATE
      ARGUMENTS="$TEMPLATE pending"
      COMMAND="vm-pending.rb"
      LCM_STATE="LCM_INIT"
      REMOTE="NO"
      RESOURCE="VM"
      STATE="PENDING"

      EXECUTION LOG
        ID    TIMESTAMP    EXECUTION
        0     09/23 15:10  ERROR (255)

Now we can see that there is an execution which have failed with error code 255. We can see more information about a specific execution by using the ``-e`` option:

..note :: The hook log can be queried by using ``onehook log``. More info about ``onehook log`` command can be found using ``onehook log --help``.

.. code::

    $ onehook show 0 -e 0
      HOOK 0 INFORMATION
      ID                : 0
      NAME              : hook-vm
      TYPE              : state
      LOCK              : None

      HOOK EXECUTION RECORD
      EXECUTION ID      : 0
      TIMESTAMP         : 09/23 15:10:38
      COMMAND           : /var/lib/one/remotes/hooks/vm-pending.rb PFZNPgogIDxJRD4wPC9JRD4KICA8VUlEPjA8L1VJRD4KICA8R0lEPjA8L0dJRD4KICA8VU5BTUU+b25lYWRtaW48L1VOQU1FPgogIDxHTkFNRT5vbmVhZG1pbjwvR05BTUU+CiAgPE5BTUU+dGVzdDwvTkFNRT4KICA8UEVSTUlTU0lPTlM  +CiAgICA8T1dORVJfVT4xPC9PV05FUl9VPgogICAgPE9XTkVSX00+MTwvT1dORVJfTT4KICAgIDxPV05FUl9BPjA8L09XTkVSX0E+CiAgICA8R1JPVVBfVT4wPC9HUk9VUF9VPgogICAgPEdST1VQX00+MDwvR1JPVVBfTT4KICAgIDxHUk9VUF9BPjA8L0dST1VQX0E  +CiAgICA8T1RIRVJfVT4wPC9PVEhFUl9VPgogICAgPE9USEVSX00+MDwvT1RIRVJfTT4KICAgIDxPVEhFUl9BPjA8L09USEVSX0E+CiAgPC9QRVJNSVNTSU9OUz4KICA8TEFTVF9QT0xMPjA8L0xBU1RfUE9MTD4KICA8U1RBVEU+MTwvU1RBVEU+CiAgPExDTV9TVEFURT4wPC9MQ01fU1RBVEU+CiAgPFBSRVZfU1RBVEU  +MTwvUFJFVl9TVEFURT4KICA8UFJFVl9MQ01fU1RBVEU+MDwvUFJFVl9MQ01fU1RBVEU+CiAgPFJFU0NIRUQ+MDwvUkVTQ0hFRD4KICA8U1RJTUU+MTU2OTI0NDIzODwvU1RJTUU+CiAgPEVUSU1FPjA8L0VUSU1FPgogIDxERVBMT1lfSUQvPgogIDxNT05JVE9SSU5HLz4KICA8VEVNUExBVEU  +CiAgICA8QVVUT01BVElDX1JFUVVJUkVNRU5UUz48IVtDREFUQVshKFBVQkxJQ19DTE9VRCA9IFlFUykgJiAhKFBJTl9QT0xJQ1kgPSBQSU5ORUQpXV0+PC9BVVRPTUFUSUNfUkVRVUlSRU1FTlRTPgogICAgPENQVT48IVtDREFUQVsxXV0+PC9DUFU  +CiAgICA8TUVNT1JZPjwhW0NEQVRBWzJdXT48L01FTU9SWT4KICAgIDxWTUlEPjwhW0NEQVRBWzBdXT48L1ZNSUQ+CiAgPC9URU1QTEFURT4KICA8VVNFUl9URU1QTEFURS8+CiAgPEhJU1RPUllfUkVDT1JEUy8+CjwvVk0+ pending
      ARGUMENTS         :
      <VM>
      <ID>0</ID>
      <UID>0</UID>
      <GID>0</GID>
      <UNAME>oneadmin</UNAME>
      <GNAME>oneadmin</GNAME>
      <NAME>test</NAME>
      <PERMISSIONS>
          <OWNER_U>1</OWNER_U>
          <OWNER_M>1</OWNER_M>
          <OWNER_A>0</OWNER_A>
          <GROUP_U>0</GROUP_U>
          <GROUP_M>0</GROUP_M>
          <GROUP_A>0</GROUP_A>
          <OTHER_U>0</OTHER_U>
          <OTHER_M>0</OTHER_M>
          <OTHER_A>0</OTHER_A>
      </PERMISSIONS>
      <LAST_POLL>0</LAST_POLL>
      <STATE>1</STATE>
      <LCM_STATE>0</LCM_STATE>
      <PREV_STATE>1</PREV_STATE>
      <PREV_LCM_STATE>0</PREV_LCM_STATE>
      <RESCHED>0</RESCHED>
      <STIME>1569244238</STIME>
      <ETIME>0</ETIME>
      <DEPLOY_ID/>
      <MONITORING/>
      <TEMPLATE>
          <AUTOMATIC_REQUIREMENTS><![CDATA[!(PUBLIC_CLOUD = YES) & !(PIN_POLICY = PINNED)]]></AUTOMATIC_REQUIREMENTS>
          <CPU><![CDATA[1]]></CPU>
          <MEMORY><![CDATA[2]]></MEMORY>
          <VMID><![CDATA[0]]></VMID>
      </TEMPLATE>
      <USER_TEMPLATE/>
      <HISTORY_RECORDS/>
      </VM> pending
      EXIT CODE         : 255

      EXECUTION STDOUT


      EXECUTION STDERR
      ERROR MESSAGE --8<------
      Internal error No such file or directory - /var/lib/one/remotes/hooks/vm-pending.rb
      ERROR MESSAGE ------>8--

If we check the ``EXECUTION STDERR`` we can see that the hook fails because the script does not exists:

.. code::

    Internal error No such file or directory - /var/lib/one/remotes/hooks/vm-pending.rb

Retrying Hook Executions
--------------------------------------------------------------------------------

As the hooks have failed because the file does not exist lets create the file and retry the hook execution.

.. note:: Note that any hook execution can be retried regardless of it result.

.. code::

    $ vim /var/lib/one/remotes/hooks/vm-pending.rb
      #!/usr/bin/ruby
      puts "Executed!"

    $ chmod 760 /var/lib/one/remotes/hooks/vm-pending.rb
    $ onehook retry 0 0
    $ onehook show 0
      HOOK 0 INFORMATION
      ID                : 0
      NAME              : hook-vm
      TYPE              : state
      LOCK              : None

      HOOK TEMPLATE
      ARGUMENTS="$TEMPLATE pending"
      COMMAND="vm-pending.rb"
      LCM_STATE="LCM_INIT"
      REMOTE="NO"
      RESOURCE="VM"
      STATE="PENDING"

      EXECUTION LOG
      ID       TIMESTAMP    RC    EXECUTION
      0        09/23 15:10  255   ERROR
      1        09/23 15:59    0   SUCCESS

Developing Hooks
================================================================================

For developing new hooks we need to take into account which type of hook we want to develop (API or STATE) as it will be able to get different type of information.

Here it's available an example of each type of hook which read the parameters and print them. This examples are good starting points for developing custom hooks.

API Hook example
--------------------------------------------------------------------------------

.. code::

    #!/usr/bin/ruby

    require 'base64'
    require 'nokogiri'

    #api_info= Nokogiri::XML(Base64::decode64(STDIN.gets.chomp)) for reading from STDIN
    api_info = Nokogiri::XML(Base64::decode64(ARGV[0]))

    success = api_info.xpath("/CALL_INFO/RESULT").text.to_i == 1
    uname   = api_info.xpath('//PARAMETER[TYPE="IN" and POSITION=2]/VALUE').text

    if !success
        puts "Failing to create user"
        exit -1
    end

    puts "User #{uname} successfully created"



State Hook example (HOST)
--------------------------------------------------------------------------------
.. code::

    #!/usr/bin/ruby

    require 'base64'
    require 'nokogiri'

    #host_template = Nokogiri::XML(Base64::decode64(STDIN.gets.chomp)) for reading from STDIN
    host_template = Nokogiri::XML(Base64::decode64(ARGV[0]))

    host_id = host_template.xpath("//ID").text.to_i
    uid   = host_template.xpath("//UID").text.to_i

    puts "User #{uid} created Host #{host_id}"

State Hook example (VM)
--------------------------------------------------------------------------------

.. code::

    #!/usr/bin/ruby

    require 'base64'
    require 'nokogiri'

    #vm_template = Nokogiri::XML(Base64::decode64(STDIN.gets.chomp)) for reading from STDIN
    vm_template = Nokogiri::XML(Base64::decode64(ARGV[0]))

    vm_id = vm_template.xpath("//ID").text.to_i
    uid   = vm_template.xpath("//UID").text.to_i

    puts "User #{uid} created VM #{vm_id}"

.. note:: Note that any linux command can be specify in ``COMMAND`` attribute, it could be useful for debugging. (e.g ``COMMAND="/usr/bin/echo"``)

.. |hook-subsystem| image:: /images/hooks-subsystem-architecture.png
