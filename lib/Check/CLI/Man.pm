package Check::CLI::Man;

use Mouse;
use Check::CLI;
use feature qw/say/;

sub man {
	my $self = shift;
	say " ";
	say "  check is a easy time logger tool.";
	say " ";
	say "    check has some functions.";
	say "      check in [project] : You can start logging time.";
	say "      check out : You can stop time logging.";
	say "      check list : You can see lists of all projects.";
	say "      check now : You can see which project is running.";
	say "      check total [project] : You can see total time of a project.";
	say "      check view [project] : You can see total time of each day of a project.";
	say "      check alter [project] HH:MM:SS : You can alter the latest record END_TIME of a project.";
	say "      check drop [project] : You can drop a project.";
	say "      check delete [project] : You can delete a latest record from a project.";
	say "      check dump : You can make a dumpfile.";
	say "      check restore : You can restore from a dumpfile.";
	say "      check man : You can see this command mannual.";
	say " ";
}

__PACKAGE__->meta->make_immutable;

1;

