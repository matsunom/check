package Check::CLI::IN;

use Check::CLI;
use Check::DB;
use Data::Printer;
use feature qw/say/;

has 'dbh' => (
	is  => 'ro',
	default => sub {
		Check::DB->new();
	}
);

sub run {
	my ($self,$command) = @_;
	my $db = $self->dbh;

	# project table の中に存在するかチェック_check_exists()
	my $select = <<'EOS';
insert * from projects;
EOS

	$db->dbh->prepare($select);
	$db->dbh->execute;

	print "in : $command\n";
}


1;

