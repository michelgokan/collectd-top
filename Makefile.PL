use 5.018002;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Collectd::Plugins::Top',
    VERSION_FROM      => 'lib/Collectd/Plugins/Top.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT => 'collectd-top: A plugin to measure and send top processes by CPU or Memory',
       AUTHOR         => 'root <root@>') : ()),
);
