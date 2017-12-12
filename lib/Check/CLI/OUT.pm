package Check::CLI::OUT;

use Mouse;
use Check::CLI;
use feature qw/say/;

sub run {
	my ($self,$command) = @_;
	print "OUT : $command\n";
}

__PACKAGE__->meta->make_immutable;

1;

