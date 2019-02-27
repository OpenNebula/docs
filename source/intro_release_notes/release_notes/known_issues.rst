.. _known_issues:

================================================================================
Known Issues
================================================================================

A complete list of `known issues for OpenNebula is maintained here <https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22>`__.

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

Upgrade Process
================================================================================

There is an issue where the database upgrade process can drop some XML attributes in the listing column. This issue only impacts on the list operations, including the Sunstone VM list, and the XML data returned by the ``onevm list`` command and ``one.vmpool.info`` API call. This data is updated and fixed by oned as it refreshes the VM information.

If you want to obtain the right listing information after the upgrade, please replace the file ``/usr/lib/one/ruby/onedb/local/5.6.0_to_5.7.80.rb`` `with the one you can download here. <https://raw.githubusercontent.com/OpenNebula/one/one-5.8/src/onedb/local/5.6.0_to_5.7.80.rb>`__

Debian & Ubuntu: Phusion Passenger Pacakge Conflict
================================================================================

Phusion Passenger, used to run the Sunstone inside the Apache or NGINX, can't be installed from the packages available for Debian and Ubuntu due to conflicting dependencies. Passenger must be installed manually, follow the (`documentation <https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/apache/oss/rubygems_norvm/install_passenger.html>`__).
