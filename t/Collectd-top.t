# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Collectd-top.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 1;
#BEGIN { use_ok('Collectd-top') };
#TODO: No test at the moment, need to write some...
BEGIN { ok(1,'Test OK') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

