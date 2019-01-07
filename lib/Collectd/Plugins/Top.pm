package Collectd::Plugins::Top;

use strict;
use warnings;

use Collectd qw( :all );

our $VERSION = 1;
my %CONFIG;

sub top_init{
	if(!exists $CONFIG{TopProcessesCountByMemory}){
		plugin_log(LOG_NOTICE, "INIT TopProcessesCountByMemory does not exists - Set default to 3.");
		$CONFIG{TopProcessesCountByMemory} = 3;
	}
	
	if(!exists $CONFIG{TopProcessesCountByCPU}){
		plugin_log(LOG_NOTICE, "INIT TopProcessesCountByCPU does not exists - Set default to 3.");
		$CONFIG{TopProcessesCountByCPU} = 3;
	}
	return 1;
}

sub top_read
{
	my $v = {
		plugin   => "top",
		type	=> "percent",
		time     => time,
	};

	#plugin_log(LOG_NOTICE, "READ TopProcessesCount ".$CONFIG{TopProcessesCount});

	my $processes = `ps -eo pmem,pcpu,pid,cmd | tail -n +2 | column -t`;
	my $top_memory = `echo "$processes" | sort -k 1 -nr | head -$CONFIG{TopProcessesCountByMemory} | column -t`;
	my $top_cpu = `echo "$processes" | sort -k 2 -nr | head -$CONFIG{TopProcessesCountByCPU} | column -t`;

	my @top_memory_lines = split /\n/, $top_memory;
	my @top_cpu_lines = split /\n/, $top_cpu;
	my $counter = 1;

	foreach my $line (@top_memory_lines) {
		my @chunk = split /[ \t]+/, $line;
			
		$v->{'plugin_instance'} = "$counter-$chunk[2]-$chunk[3]",
		$v->{'type_instance'} = "memory",
		$v->{'values'} = [ $chunk[0] ],
		plugin_dispatch_values($v);
		
#		plugin_log(LOG_NOTICE, "TOP - Values MEMORY $counter - $chunk[0],$chunk[1],$chunk[2],$chunk[3]");
		$counter++;	
	}
	
	$counter = 1;
	foreach my $line (@top_cpu_lines) {
		my @chunk = split /[ \t]+/, $line;
			
		$v->{'plugin_instance'} = "$counter-$chunk[2]-$chunk[3]",		
		$v->{'type_instance'} = "cpu",
		$v->{'values'} = [ $chunk[1] ],
		plugin_dispatch_values($v);
		
#		plugin_log(LOG_NOTICE, "TOP - Values CPU $counter - $chunk[0],$chunk[1],$chunk[2],$chunk[3]");
		$counter++;	
	}
	
	return 1;
}

sub top_config
{
	my @config = @{ $_[0]->{children} };

	foreach(@config) {
		my $okey = $_->{key}; # for error messages
		my $key = lc $okey;
		my @values = $_->{values};

		my $value = $_->{values}->[0];
		plugin_log(LOG_NOTICE, "TOP CONF - Inside foreach $key / $value");
	
		if ($key eq "topprocessescountbymemory") {
			$CONFIG{TopProcessesCountByMemory} = $value;
		} elsif ($key eq "topprocessescountbycpu") {
			$CONFIG{TopProcessesCountByCPU} = $value;
		}
	}

	return 1;
}

plugin_register(TYPE_INIT, "top", "top_init");
plugin_register (TYPE_READ, "top", "top_read");
plugin_register (TYPE_CONFIG, "top", "top_config");

1;
