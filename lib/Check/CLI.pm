package Check::CLI;

use strict;
use warnings;
use utf8;
use Data::Printer;
use Check::CLI::Man;

use Mouse;

sub commands {
	my ($self,@commands) = @_;
    if ($commands[0] eq "man") {
		Check::CLI::Man->new->man();
	}
}


__PACKAGE__->meta->make_immutable;

1;

