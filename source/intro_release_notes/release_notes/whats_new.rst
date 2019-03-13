.. _whats_new:

================================================================================
What's New in 5.9
================================================================================

OpenNebula Core
================================================================================
- **Update hashing algorithm**, now passwords and login tokens are hashed using sha256 instead of sha1. Also csrftoken is now hashed with SHA256 instead of MD5

Other Issues Solved
================================================================================
- `Fixes an issue that makes the network drivers fail when a large number of secturiy groups rules are used <https://github.com/OpenNebula/one/issues/2851>`_.
- `Add new scalability guide with clear resource numeric limits <https://github.com/OpenNebula/one/issues/2705>`_.
- `Support for marketplace addons <https://github.com/OpenNebula/one/issues/2531>`_.
