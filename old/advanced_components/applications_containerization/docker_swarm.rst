.. _docker_swarm_overview:

================================================================================
Docker Engine Clusters
================================================================================

Swarm Classic
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check the OpenNebula `blog post <https://opennebula.org/docker-swarm-with-opennebula/>`__ to learn how to use Docker Swarm Classic on an OpenNebula cloud.

Swarmkit / Swarm mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check `Docker documentation <https://docs.docker.com/get-started/part4/#create-a-cluster>`__ to use Swarmkit / Swarm mode. If you have discovery issues, please check your multicast support is OK.

As long as your VM template includes only one network, you should not even need to give --advertise-addr or --listen-addr

Autoscaling via OneFlow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A service of Docker engines can be defined in :ref:`OneFlow <appflow_use_cli>`, and the autoscaling mechanisms of OneFlow used to automatically grow/decrease the number of Docker engines based on application metrics.