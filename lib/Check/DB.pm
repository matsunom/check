package Check::DB;

use DBI;
use Mouse;

has dbh => (
	is      => 'ro',
	default => sub {
		my $dbh = DBI->connect("dbi:SQLite:dbname=projects");
		return $dbh;
	}
);

__PACKAGE__->meta->make_immutable;

1;

