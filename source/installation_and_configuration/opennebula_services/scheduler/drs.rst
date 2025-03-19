.. _scheduler_drs:

==============================
Distributed Resource Scheduler
==============================

The **OpenNebula Distributed Resource Scheduler** (DRS) is responsible for:

* Initial placement of virtual machines according to the system requirements, including: capacity control, resource compatibility, and affinity groups
* Cluster-wise workload optimization, according to the balancing policies specified by the user

Scheduling Algorithm
====================

OpenNebula DRS uses the integer linear programming (ILP) optimizer.
Details about host filtering, storage, VNets, PCI devices, etc.

Configuration
=============

Configuration files and options.

Scheduling Policies
===================

Explain packing and load balancing.
Explain how to configure linear combinations of objectives and what they represent.

Solvers
=======

OpenNebula DRS uses the Python package PuLP to communicate with ILP solvers. It can use any solver supported by PuLP (https://coin-or.github.io/pulp/technical/solvers.html).

Currently, DRS comes with GLPK Solver (https://www.gnu.org/software/glpk/), but a user can also install and apply CBC Solver (https://coin-or.github.io/Cbc/), or some commercial solver like Gurobi Optimizer (https://www.gurobi.com/).

Explain configuring the solver.

Service Control and Logs
========================

systemctl … .

Predictive DRS
==============

Explain predictions.

Using Distributed Resource Scheduler from Sunstone
==================================================

Is this applicable already?
