# Collectd-Plugins-Top version 0.01
=================================

A simple collectd plugin to send memory and CPU usage (in percentage) of top N processes (default 3).

## INSTALLATION

To install this module type the following:

````
   perl Makefile.PL
   make
   make test
   make install
````

in `/opt/collectd/etc/collectd.conf`:

````
...
<LoadPlugin "perl">
  Globals true
</LoadPlugin>
...
<Plugin perl>
        BaseName "Collectd::Plugins"
        LoadPlugin "Top"
        <Plugin "top">
                TopProcessesCount "4"
        </Plugin>
</Plugin>
...
````

## DEPENDENCIES

This module requires no special dependency

## COPYRIGHT AND LICENCE

Collectd-Plugins-Top by Michel Gokan is licensed under a Creative Commons Attribution 4.0 International License.
