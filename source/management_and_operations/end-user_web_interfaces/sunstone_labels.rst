.. _sunstone_labels:

================================================================================
Sunstone Labels
================================================================================

Labels can be defined for most of the OpenNebula resources from the admin view.

Each resource **will store the label information in its own template**, thus it can be easily edited from the CLI or Sunstone.

|labels_edit|

This feature enables the possibility to **group the different resources** under a given label and filter them in the admin and cloud views. The user will be able to easily find the template she wants to instantiate, **or select a set of resources** to apply a given action.

|labels_filter|

Label creation
================================================================================

To create a label, go to the Settings section of an user and enter the name of the label.

|labels_create|

.. warning:: When an user applies a label to a resource, he can only applies the labels that he has created. The same happens with the label filter, the user can only filter by the labels that he has created.

.. _suns_views_labels_behavior:

.. |labels_edit| image:: /images/sunstone_labels_edit.png
.. |labels_filter| image:: /images/sunstone_labels_filter.png
.. |labels_create| image:: /images/sunstone_labels_create.png
