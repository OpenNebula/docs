.. _sunstone_labels:

================================================================================
Sunstone Labels
================================================================================

================================================================================
Labels
================================================================================
|labels_edit|

Labels can be defined for most of the OpenNebula resources from the admin view. Each resource will store the label information in its own template, thus it can be easily edited from the CLI or Sunstone. This feature enables the possibility to group the different resources under a given label and filter them in the admin and cloud views. The user will be able to easily find the template she wants to instantiate, or select a set of resources to apply a given action.

|labels_filter|

The list of labels defined for each pool will be shown in the left navigation menu. After clicking on one of these labels only the resources with this label will be shown in the table. This filter is also available in the cloud view inside the virtual machine creation form to easily select a specific template.

To create a label hierarchy, use the '/' character. For example, you could have the labels 'Linux/Ubuntu' and 'Linux/CentOS'. Please note that a resource with the label 'Linux/Ubuntu' is not automatically added to the parent 'Linux' label, but you can do it explicitly.

.. _suns_views_labels_behavior:

.. note:: Labels created from Sunstone will ignore the labels case, and show them in lowercase with the first letter in upper case.
    Eg: ``label with-spaces/andSubtree`` will tranform to ``Label With-spaces/Andsubtree``

Persistent Labels
================================================================================
You can also create persistent labels. These types of labels will not be deleted even when they have no associated resources. To define persistent tags we have 2 options, defining them as system tags, and including them in the file ``/etc/one/sunstone-views.yaml`` or adding them to the user's template. This second form can be done through the CLI or through the sunstone interface, doing Click on the padlock of already-created tags.

|labels_persis|

User Labels
--------------------------------------------------------------------------------
These labels will be saved in the user's template when the user clicks on the padlock. These labels are easily editable from the CLI or Sunstone interface. Add the following template when you save a label in the user's template

.. code-block:: none

    TEMPLATE = [
        LABELS = "labels_persis,label_persis_2"
    ]

System Labels
--------------------------------------------------------------------------------
These labels are defined in ``/etc/one/sunstone-views.yaml``. You can separate them per groups of users or introduce them into the default section.

.. code-block:: yaml

    logo: images/opennebula-5.0.png
    groups:
        oneadmin:
            - admin
            - admin_vcenter
            - groupadmin
            - groupadmin_vcenter
            - user
            - cloud
            - cloud_vcenter
    default:
        - cloud
    default_groupadmin:
        - groupadmin
        - cloud
    labels_groups:
        oneadmin:
            - oneadmin
        default:
            - default

.. |labels_edit| image:: /images/labels_edit.png
.. |labels_persis| image:: /images/labels_persis.png
.. |labels_filter| image:: /images/labels_filter.png
