package Check::CLI;

use strict;
use warnings;
use utf8;
use Data::Printer;
use Check::CLI::Man;
use Check::CLI::IN;
use Check::CLI::OUT;

use Mouse;

sub commands {
	my ($self,@commands) = @_;

	# => check <function> <project_name>
	# function未入力の場合, check requires ~ と出力し, project_name未入力の場合, Please ~ と出力
	# check manと入力があると, usageの出力
	exit print "check requires function name!\n" unless defined($commands[0]);
	exit Check::CLI::Man->new->man() if ($commands[0] eq "man");
	exit print "Please write a project name!\n" unless defined($commands[1]);

	# function によって，実行モジュールを変更
	for ($commands[0]) {
		if (/in/) {
			Check::CLI::IN->new->run($commands[1]);
		}elsif (/out/) {
			Check::CLI::OUT->new->run($commands[1]);
		}
	}
}


__PACKAGE__->meta->make_immutable;

1;

