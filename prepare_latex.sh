#!/bin/bash

find source -name "*.rst" | xargs sed -i 's/.. prompt:: .*/.. code-block:: bash/g'
