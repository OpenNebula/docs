========================
Ruby OpenNebula Zone API
========================

This page contains the OpenNebula Zone API (ZONA) Specification for
Ruby. It has been designed as a wrapper for the OpenNebula Zone REST
server, with some basic helpers. This means that you should be familiar
with the XML-RPC API and the JSON formats returned by the OpenNebula
Zone server.

API Documentation
=================

You can consult the `doc
online <http://opennebula.org/doc/4.4/zona/ruby/>`__.

Usage
=====

You can use the Ruby ZONA included in the OpenNebula distribution by
adding the OpenNebula Ruby library path to the search path:

.. code:: code

##############################################################################
# Environment Configuration
##############################################################################
ONE_LOCATION=ENV["ONE_LOCATION"]

if !ONE_LOCATION
RUBY_LIB_LOCATION="/usr/lib/one/ruby"
else
RUBY_LIB_LOCATION=ONE_LOCATION+"/lib/ruby"
end

$: << RUBY_LIB_LOCATION

##############################################################################
# Required libraries
##############################################################################
require 'zona'

Code Sample
===========

This is a small code snippet. As you can see, the code flow would be as
follows:

.. code:: code

#!/usr/bin/env ruby
 
##############################################################################
# Environment Configuration
##############################################################################
ONE_LOCATION=ENV["ONE_LOCATION"]
 
if !ONE_LOCATION
RUBY_LIB_LOCATION="/usr/lib/one/ruby"
else
RUBY_LIB_LOCATION=ONE_LOCATION+"/lib/ruby"
end
 
$: << RUBY_LIB_LOCATION
 
##############################################################################
# Required libraries
##############################################################################
require 'zona'
 
TDB

