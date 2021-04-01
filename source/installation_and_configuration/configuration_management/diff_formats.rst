.. _cfg_diff_formats:

============
Diff Formats
============

The configuration management tool ``onecfg`` allows us to compare the configuration files to identify user changes against the OpenNebula distributed files. The result of a comparison, the differential output, describes all the individual changes which were made and which can even be applied again later or on a different machine.

The following table shows supported formats by each subcommand:

+-----------+-----------------------------+-----------------+------------------+
| Format    | Description                 | ``onecfg diff`` | ``onecfg patch`` |
+===========+=============================+=================+==================+
| ``text``  | Easy human-readable text    | YES (default)   | NO               |
+-----------+-----------------------------+-----------------+------------------+
| ``line``  | Single line for one change  | YES             | YES (default)    |
+-----------+-----------------------------+-----------------+------------------+
| ``yaml``  | Complete change structure   | YES             | YES              |
+-----------+-----------------------------+-----------------+------------------+

Only ``line`` format will be described in a detail, as it's powerful in achieving even complex changes and easy enough to read or write manually.

Line Format
===========

Each line of change consists of the following space separated parts:

``<FILENAME> <COMMAND> <PATH> [<JSON VALUE>]``

with the following meanings:

``FILENAME``
------------

Filename is an **absolute path** to the well-known configuration file of OpenNebula that is going to be changed.

``COMMAND``
-----------

Command is a type of operation to be executed on the configuration file. Only the following commands are available:

  - ``ins`` - insert new configuration parameter
  - ``set`` - change existing parameter
  - ``rm``  - remove parameter

``PATH``
--------

Path uniquely identifies the location of the changed parameter as a slash ``/`` separated XPath-like segments and key from document root and without leading slash (e.g., ``path/path/path/key``). **If  any path element contains spaces, the whole path must be quoted with (and only with!) double quotes** (``"``), internal double quotes must be escaped by backslash (``\``).

.. note::

    For YAML configuration files, the path elements and values starting with ``:`` are transformed into Ruby symbols.

Examples:

- for following ``/etc/one/oned.conf`` snippet

.. code::

    PORT = 2633                                  # path 1

    DB = [ BACKEND = "sqlite",                   # path 2
           TIMEOUT = 2500 ]

    IM_MAD = [
          NAME       = "monitord",
          EXECUTABLE = "onemonitord",
          ARGUMENTS  = "-c monitord.conf",
          THREADS    = 8 ]                       # path 3

these paths are valid to address the emphasized parameters:

  1. ``PORT``
  2. ``DB/BACKEND`` or ``"DB/BACKEND"``
  3. ``IM_MAD/"monitord"/THREADS`` or ``"IM_MAD/\"monitord\"/THREADS"``

.. important::

	In the ``oned.conf``-like configurations, some nested structures are unique (e.g., ``DB=[...]`` is just a single database connection configuration) and some can appear several times (e.g., ``VM_MAD=[...]`` configures execution of different drivers for different hypervisors, one section for each driver). In the second case, the nested structure is uniquely addressed by a value of one identifying parameter inside the structure, usually ``NAME``. This value (including the quotes) is placed as part of the path. See path 3 above.

- for the following ``/etc/one/sunstone-server.conf`` snippet

.. code::

    # OpenNebula sever contact information
    :one_xmlrpc: http://localhost:2633/RPC2     # path 4
    :one_xmlrpc_timeout: 60

these paths are valid to address the emphasized parameter(s):

  4. ``:one_xmlrpc`` or ``":one_xmlrpc"``

- for the following ``/etc/one/cli/oneimage.yaml`` snippet

.. code::

    ---
    :ID:
      :desc: ONE identifier for the Image       # path 5
      :size: 4
      :adjust: true

these paths are valid to address the emphasized parameter(s):

  5. ``:IP/:desc`` or ``":IP/:desc"``

.. important::

   Path accepts only double quotes (``"``) to enclose paths that include spaces. Single quotes (``'``) are always understood as part of the string.

``JSON VALUE``
--------------

The value encoded in JSON is mandatory only for ``ins`` and ``set`` commands. It can contain simple values or complex structures, **string values must be quoted with (and only with!) double quotes** (``"``).

Examples:

- no text is an uninitialized value
- ``null`` - uninitialized value
- ``11`` - Integer value ``11``
- ``"11"`` - String value ``11``
- ``'11'`` - **invalid JSON value!**
- ``"'11'"`` - String value ``'11'``
- ``"\"11\"`` - String value ``"11"`` (strings with inner quotes must be escaped)
- ``true`` - Boolean value ``true``
- ``"true"`` - String value ``true``
- ``["apple", "orange"]`` - Array with 2 String values ``apple`` and ``orange``
- ``['apple', 'orange"]`` - **invalid JSON value!**
- ``{"fruit": "apple"}`` - Hash with key ``fruit`` with value ``apple``
- ``{'fruit': 'apple'}`` - **invalid JSON value!**

.. important::

   When the value in the addressed configuration file contains quotes, these must also be specified in the JSON value or within a path. This leads to double quoting of values; the first quotes identify a JSON string and the second (inner) escaped quotes are passed to the configuration file (e.g., ``"\"quoted string\"'``). This is usually seen in the ``oned.conf``-like configuration files.

Examples
--------

.. prompt:: bash # auto

    # onecfg diff --format line
    /etc/one/cli/oneimage.yaml ins :ID/:adjust false
    /etc/one/cli/oneimage.yaml set :USER/:size 15
    /etc/one/cli/oneimage.yaml set :GROUP/:size 15
    /etc/one/cli/oneimage.yaml ins :NAME/:expand false
    /etc/one/oned.conf set DEFAULT_DEVICE_PREFIX "\"sd\""
    /etc/one/oned.conf set VM_MAD/"vcenter"/ARGUMENTS "\"-p -t 15 -r 0 -s sh vcenter\""
    /etc/one/oned.conf rm  VM_MAD/"vcenter"/DEFAULT
    /etc/one/oned.conf ins HM_MAD/ARGUMENTS "\"-p 2101 -l 2102 -b 127.0.0.1\""
    /etc/one/oned.conf ins VM_RESTRICTED_ATTR "\"NIC/FILTER\""

How to read the output? Let's go through few examples from above:

- ``/etc/one/cli/oneimage.yaml ins :ID/:adjust false`` - add new key ``:adjust`` with Boolean value ``false`` into top Hash structure ``:ID``
- ``/etc/one/cli/oneimage.yaml set :USER/:size 15`` - value for existing key ``:size`` inside top Hash structure ``:USER`` changes to ``15``
- ``/etc/one/oned.conf rm VM_MAD/"vcenter"/DEFAULT`` - remove key ``DEFAULT`` from ``VM_MAD`` section for ``vcenter``

Text Format
===========

Text format is similar to line format with visually separated sections for each configuration file and without a redundant filename on each line. It's easier to read by humans but can't be used as an input of the ``patch`` subcommand.

Example
-------

.. prompt:: bash # auto

    # onecfg diff --format text
    /etc/one/cli/oneimage.yaml
    - ins :ID/:adjust false
    - set :USER/:size 15
    - set :GROUP/:size 15
    - ins :NAME/:expand false

    /etc/one/oned.conf
    - set DEFAULT_DEVICE_PREFIX "\"sd\""
    - set VM_MAD/"vcenter"/ARGUMENTS "\"-p -t 15 -r 0 -s sh vcenter\""
    - rm  VM_MAD/"vcenter"/DEFAULT
    - ins HM_MAD/ARGUMENTS "\"-p 2101 -l 2102 -b 127.0.0.1\""
    - ins VM_RESTRICTED_ATTR "\"NIC/FILTER\""

YAML Format
===========

Contains complete information about the changes, the old original and new values, position (index) of value within an array, and even preserves symbolized keys and values (which are used in several configuration files). This format is recommended for use if it's expected to identify and apply (patch) changes most accurately.

Example
-------

.. prompt:: bash # auto

    # onecfg diff --format yaml
    ---
    patches:
      "/etc/one/cli/oneimage.yaml":
        class: Yaml::Strict
        change:
        - path:
          - :ID
          key: :adjust
          value: false
          state: ins
          extra: {}
        - path:
          - :USER
          key: :size
          value: 15
          old: 8
          state: set
          extra: {}
        - path:
          - :GROUP
          key: :size
          value: 15
          old: 8
          state: set
          extra: {}
        - path:
          - :NAME
          key: :expand
          value: false
          state: ins
          extra: {}
