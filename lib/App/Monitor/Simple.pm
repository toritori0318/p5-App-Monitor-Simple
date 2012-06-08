package App::Monitor::Simple;

use strict;
use warnings;
our $VERSION = '0.01';

use base 'Exporter';
our @EXPORT_OK = qw/run/;

use Smart::Args;
use AnyEvent;
use IO::CaptureOutput qw/capture/;

sub run {
    args my $command   => { isa => 'Str' },
         my $retry     => { isa => 'Int', default => 0, optional => 1},
         my $interval  => { isa => 'Int', default => 5, optional => 1},
         my $quiet     => { default => 0, optional => 1 };

    my $cv = AnyEvent->condvar;
    my $ret = -1;
    my $count = 0;
    my $w; $w = AnyEvent->timer(
        interval => $interval,
        cb => sub {
            $count++;
            $ret = rsystem($command, $quiet);
            if ($ret == 0 || $retry < $count) {
                undef $w;
                $cv->send;
            }
        }
    );
    $cv->recv;

    if($count == 1 && $ret == 0) {
        # normal
        return 0;
    } elsif($count < $retry) {
        # warnings
        #  Now thinking...
        return 0;
    } else {
        # failure
        return -1;
    }
}

sub rsystem {
    my ($command, $quiet) = @_;
    if($quiet) {
        my ($status, $stdout, $stderr);
        capture sub { $status = system($command) } => \$stdout, \$stderr;
        return $status;
    } else {
        return system($command);
    }
}

1;
__END__
=head1 NAME

App::Monitor::Simple - Simple monitoring tool.

=head1 SYNOPSIS

  use App::Monitor::Simple qw/run/;

  my $ret = run(
      {
          command     => 'ping -c 1 blahhhhhhhhhhhhhhhh.jp',   # required
          interval    => 10,
          retry       => 5,
          quiet       => 1,
      }
  );

=head1 DESCRIPTION

This module provides a simple monitoring.

=head1 METHODS

=head2 run

  my $status = App::Monitor::Simple::run(\%arg);

This method runs the monitoring.

Valid arguments are:

  command   - Specify the monitoring commands.

  interval  - Number of interval seconds. (default: 5)

  retry     - Number of retry count. (default: 0)

  quiet     - if true, suppress stdout / stderror messages. (dafailt: 0)

Return zero if the command succeeds, it returns a non-zero if a failure.
If the retry is specified, the number of times repeat the command.

=head1 AUTHOR

toritori0318 <lt>toritori0318@gmail.com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by toritori0318

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut

