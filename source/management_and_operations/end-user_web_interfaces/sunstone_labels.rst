.. _sunstone_labels:

================================================================================
Sunstone Labels
================================================================================

Labels can be defined for most of the OpenNebula resources from the admin view.

Each resource **will store the label information in its own template**, thus it can be easily edited from the CLI or Sunstone.

|labels_edit|

This feature enables the possibility to **group the different resources** under a given label and filter them in the admin and cloud views. The user will be able to easily find the template she wants to instantiate, **or select a set of resources** to apply a given action.

|labels_filter|

The list of labels defined for each pool **will be shown in the left navigation menu**. After clicking on one of these labels, only the resources with this label will be shown in the table.

This filter is **also available in the cloud view** inside the virtual machine creation form to easily select a specific template.

|labels_cloud|

To create a **label hierarchy**, use slash character: ``/``. For example, you could have the labels ``Linux/Ubuntu`` and ``Linux/Centos``.

.. _suns_views_labels_behavior:

Normalization
================================================================================

Labels have a few peculiarities worth taking into account:

* When a resource is assigned a the label with hierarchy, e.g. ``Linux/Ubuntu`` the label parent ``Linux`` **isn't automatically added**, but you can do it manually.

* Labels created from Sunstone **will ignore the labels case**, and show them in lowercase with the first letter in uppercase. For example, ``label with-spaces/andSubtree`` will transform to ``Label With-spaces/Andsubtree``

Persistent Labels
================================================================================
Persistent labels have an extra behavior: it **isn't removed** when it does not have associated resources.

To define persistent a labels we have two options: :ref:`system label <suns_views_system_labels>` or :ref:`user label <suns_views_user_labels>`.

.. _suns_views_user_labels:

User Labels
--------------------------------------------------------------------------------
These labels will be **saved in the User's template** through the CLI or Sunstone interface

|labels_user_persis|

When the user clicks on the **padlock** of already-created labels, it add the following block in the User's template:

.. code-block:: none

    TEMPLATE = [
        LABELS = "Nodejs/Old,Linux/Ubuntu"
    ]

.. _suns_views_system_labels:

System Labels
--------------------------------------------------------------------------------
These labels are defined in ``/etc/one/sunstone-views.yaml``.

You can separate them per groups of users or introduce them into the default section. For example:

.. code-block:: yaml

    logo: images/opennebula-5.0.png
    groups:
        oneadmin:
            - admin
            - groupadmin
            - user
            - cloud
    default:
        - cloud
    default_groupadmin:
        - groupadmin
        - cloud
    labels_groups:
        oneadmin:
            - Linux/Ubuntu
            - Linux/Centos
        default:
            - default

.. |labels_edit| image:: /images/sunstone_labels_edit.png
.. |labels_filter| image:: /images/sunstone_labels_filter.png
.. |labels_cloud| image:: /images/sunstone_labels_cloud.png
.. |labels_user_persis| image:: /images/sunstone_labels_user_persis.png
