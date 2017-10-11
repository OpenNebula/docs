.. _known_issues_hotfix:

================================================================================
Known Issues
================================================================================

OpenNebula 5.4.2 known issues can be consulted in the `development portal <https://dev.opennebula.org/projects/opennebula/issues?c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&f%5B%5D=status_id&f%5B%5D=tracker_id&f%5B%5D=&group_by=category&op%5Bstatus_id%5D=%3D&op%5Btracker_id%5D=%3D&per_page=100&set_filter=1&utf8=%E2%9C%93&v%5Bstatus_id%5D%5B%5D=1&v%5Bstatus_id%5D%5B%5D=2&v%5Btracker_id%5D%5B%5D=1>`__. In addtion you may need to consider that:

* 5.4.2 is affected by a shutdown bug for HA configurations. This issue only affects the leader of the cluster and may corrupt the cluster term. It is recommended a hard kill of the leader if needed instead of an ordered shutdown of oned. This is already solved, for more information please `follow this link <https://dev.opennebula.org/issues/5451>`__.

No other significant issues are present in 5.4.2 that :ref:`were not present in previous versions of the 5.4 series <known_issues>`.

