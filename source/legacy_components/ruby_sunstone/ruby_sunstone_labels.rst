.. _ruby_sunstone_labels:

================================================================================
Sunstone Labels
================================================================================

Labels can be defined for most of the OpenNebula resources from the admin view.

Each resource **will store the label information in its own template**, thus it can be easily edited from the CLI or Sunstone.

|ruby_sunstone_labels_edit|

This feature enables the possibility to **group the different resources** under a given label and filter them in the admin and cloud views. The user will be able to easily find the template she wants to instantiate, **or select a set of resources** to apply a given action.

|ruby_sunstone_labels_filter|

The list of labels defined for each pool **will be shown in the left navigation menu**. After clicking on one of these labels, only the resources with this label will be shown in the table.

This filter is **also available in the cloud view** inside the virtual machine creation form to easily select a specific template.

|ruby_sunstone_labels_cloud|

To create a **label hierarchy**, use slash character: ``/``. For example, you could have the labels ``Linux/Ubuntu`` and ``Linux/RedHat``.

.. _ruby_suns_views_labels_behavior:

Normalization
================================================================================

Labels have a few peculiarities worth taking into account:

* When a resource is assigned a the label with hierarchy, e.g. ``Linux/Ubuntu`` the label parent ``Linux`` **isn't automatically added**, but you can do it manually.

* Labels created from Sunstone **will ignore the labels case**, and show them in lowercase with the first letter in uppercase. For example, ``label with-spaces/andSubtree`` will transform to ``Label With-spaces/Andsubtree``

Persistent Labels
================================================================================
Persistent labels have an extra behavior: it **isn't removed** when it does not have associated resources.

To define persistent a labels we have two options: :ref:`system label <ruby_suns_views_system_labels>` or :ref:`user label <ruby_suns_views_user_labels>`.

.. _ruby_suns_views_user_labels:

User Labels
--------------------------------------------------------------------------------
These labels will be **saved in the User's template** through the CLI or Sunstone interface

|ruby_sunstone_labels_user_persis|

When the user clicks on the **padlock** of already-created labels, it add the following block in the User's template:

.. code-block:: none

    TEMPLATE = [
        LABELS = "Nodejs/Old,Linux/Ubuntu"
    ]

.. _ruby_suns_views_system_labels:

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
            - Linux/RedHat
        default:
            - default

.. |ruby_sunstone_labels_edit| image:: /images/ruby_sunstone_labels_edit.png
.. |ruby_sunstone_labels_filter| image:: /images/ruby_sunstone_labels_filter.png
.. |ruby_sunstone_labels_cloud| image:: /images/ruby_sunstone_labels_cloud.png
.. |ruby_sunstone_labels_user_persis| image:: /images/ruby_sunstone_labels_user_persis.png
