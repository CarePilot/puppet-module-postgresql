Puppet PostgreSQL Module
========================

Module for configuring PostgreSQL.

Tested on Debian GNU/Linux 6.0 Squeeze. Patches for other
operating systems welcome.


TODO
----

* Actual implementation.


Installation
------------

Clone this repo to a postgresql directory under your Puppet
modules directory:

    git clone git://github.com/uggedal/puppet-module-postgresql.git postgresql

If you don't have a Puppet Master you can create a manifest file
based on the notes below and run Puppet in stand-alone mode
providing the module directory you cloned this repo to:

    puppet apply --modulepath=modules test_postgresql.pp


Usage
-----

To install and configure PostgreSQL, include the module:

    include postgresql

You can override defaults in the PostgreSQL config by including
the module with this special syntax:

    class { postgresql: listen_addresses => 'localhost',
                        max_connections => 100,
                        shared_buffers => '24MB',
    }

Creating a database is done with the `postgresql::database` resource:

    postgresql::database { "blog":
      owner => "bloguser",
    }
