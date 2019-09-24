.. _hook_manager_events:

===========================
Hook Manager Events
===========================

The Hook Manager publish the OpenNebula events over a `ZeroMQ publisher socket <http://zguide.zeromq.org/page:all#Getting-the-Message-Out>`__. This can be used for developing custom components that suscribe to specific events to perform custom actions.

Hook Manager Messages
===========================

The hook manager sends two different types of messages:

   - **EVENT** messages: represent an OpenNebula event, which potentially could trigger a hook if the Hook Execution Manager is subscribed to it.
   - **RETRY** messages: represent a retry action of a given hook execution. These event messages are specific to the Hook Execution Manager.

Both messages have a **key** that can be used by the subscriber to receive messages related to an specific event class; and a **content** that contains the information related to the event **encoded in base64**.

Event Messages Format
---------------------------

There are two different types of EVENT messages, representing API and state events. The key format for both types are listed below:

+---------------+---------------------------------------------------------------------------------------------------------------------+
| EVENT         | Key format                                                                                                          |
+===============+=====================================================================================================================+
| API           | ``EVENT API <API_CALL> <SUCCESS>`` (e.g. ``EVENT API one.vm.allocate 1` or `Key: EVENT API one.hook.info 0``)       |
+---------------+---------------------------------------------------------------------------------------------------------------------+
| STATE (HOST)  | ``EVENT STATE HOST/<HOST_STATE>/`` (e.g. ``EVENT STATE HOST/INIT/``)                                                |
+---------------+---------------------------------------------------------------------------------------------------------------------+
| STATE (VM)    | ``EVENT STATE VM/<STATE>/<LCM_STATE>`` (e.g. ``EVENT STATE VM/PENDING/LCM_INIT``)                                   |
+---------------+---------------------------------------------------------------------------------------------------------------------+

Keys are used to subscribe to specific events. Note also that you do not need to specify the whole key, form example ``EVENT STATE HOST/ERROR/`` will suscribe for state changes to ``ERROR`` on the hosts, while ``EVENT STATE HOST/`` will suscribe for all state changes of the hosts.

The content of an event message is an XML document containing information related to the event, the XSD representing this content are available `here <https://github.com/OpenNebula/one/tree/master/share/doc/xsd>`__.

Retry Messages Format
---------------------------

The key format of the retry messages is just the word ``RETRY``, no more info is needed in the key. The retry messages content is an XML file with information about the execution to retry. The XSD representing this content is available `here <https://github.com/OpenNebula/one/tree/master/share/doc/xsd>`__.

Subscriber script example
===========================

Below there is an example of script which retrieve all the event messages and prints their key and their content.

.. code::

    #!/usr/bin/ruby

    require 'ffi-rzmq'
    require 'base64'

    @context    = ZMQ::Context.new(1)
    @subscriber = @context.socket(ZMQ::SUB)

    @subscriber.setsockopt(ZMQ::SUBSCRIBE, "EVENT")
    @subscriber.connect("tcp://localhost:2101")

    key = ''
    content = ''

    loop do
        @subscriber.recv_string(key)
        @subscriber.recv_string(content)

        puts "Key: #{key}\nContent: #{Base64.decode64(content)}"
        puts "\n===================================================================\n"
    end

.. note:: Note that the key and the content as read separately as `ZeroMQ envelopes <http://zguide.zeromq.org/page:all#Pub-Sub-Message-Envelopes>`__ are used.
