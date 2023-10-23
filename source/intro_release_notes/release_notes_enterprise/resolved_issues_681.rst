.. _resolved_issues_681:

Resolved Issues in 6.8.1
--------------------------------------------------------------------------------

A complete list of solved issues for 6.8.1 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/71?closed=1>`__.

The following new features has been backported to 6.8.1:

- `Optimized implementation of standard input capable commands  <https://github.com/OpenNebula/one/issues/6242>`__. Other commands were updated as well to handle standard input.
- Minor optimization on the ``oneflow-template instantiate`` command when using the ``--multiple`` option.

The following issues has been solved in 6.8.1:

- Fix "NUMA" and "OS & CPU" tabs on Fireedge Sunstone return an error when at least one host contains a NUMA node that has exactly one hugepage.
