package Collectd::Plugins::Top;

use strict;
use warnings;

use Collectd qw( :all );

my %CONFIG;

sub top_init{
	if(!exists $CONFIG{TopProcessesCount}){
		plugin_log(LOG_NOTICE, "INIT TopProcessesCount does not exists - Set default to 3.");
		$CONFIG{TopProcessesCount} = 3;
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

	my $result = `ps -eo pmem,pcpu,pid,cmd | tail -n +2 | sort -k 1 -nr | head -$CONFIG{TopProcessesCount} | column -t`;

	my @lines = split /\n/, $result;
	my $counter = 1;
	foreach my $line (@lines) {
		my @chunk = split /[ \t]+/, $line;
			
		$v->{'plugin_instance'} = $counter-$chunk[2]."-".$chunk[3],		
		$v->{'type_instance'} = "memory",
		$v->{'values'} = [ $chunk[0] ],
		plugin_dispatch_values($v);
		
		$v->{'plugin_instance'} = $counter-$chunk[2]."-".$chunk[3],		
		$v->{'type_instance'} = "cpu",
		$v->{'values'} = [ $chunk[1] ],
		plugin_dispatch_values($v);
		
		#plugin_log(LOG_NOTICE, "TOP - Values $counter - $chunk[0],$chunk[1],$chunk[2],$chunk[3]");
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
	
		if ($key eq "topprocessescount") {
			$CONFIG{TopProcessesCount} = $value;
		}
	}

	return 1;
}

plugin_register(TYPE_INIT, "top", "top_init");
plugin_register (TYPE_READ, "top", "top_read");
plugin_register (TYPE_CONFIG, "top", "top_config");

1;
