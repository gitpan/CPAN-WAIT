#                              -*- Mode: Perl -*- 
# WAIT.pm -- 
# ITIID           : $ITI$ $Header $__Header$
# Author          : Ulrich Pfeifer
# Created On      : Fri Jan 31 11:30:46 1997
# Last Modified By: Ulrich Pfeifer
# Last Modified On: Fri Jan 31 20:07:52 1997
# Language        : CPerl
# Update Count    : 70
# Status          : Unknown, Use with caution!
# 
# (C) Copyright 1997, Universität Dortmund, all rights reserved.
# 
# $Locker: pfeifer $
# $Log: WAIT.pm,v $
# Revision 1.1  1997/01/31 16:03:50  pfeifer
# Initial revision
#
# 

package CPAN::WAIT;
require CPAN::Config;
require Exporter;
require CPAN;
require WAIT::Client;
require FileHandle;
use Carp;
use vars qw(@EXPORT_OK @ISA $VERSION);

$VERSION   = '0.13';
@ISA       = qw(Exporter);
@EXPORT_OK = qw(wh wq wr wd wl);

my ($host, $port, $con);

unless ($CPAN::Config->{'wait_list'}) {
  $CPAN::Config->{'wait_list'} = ['wait://ls6.informatik.uni-dortmund.de'];
}
my $server;
for $server (@{$CPAN::Config->{'wait_list'}}) {
  if ($server =~ m(^wait://([^:]+)(?::(\d+))?)) {
    ($host, $port) = ($1, $2 || 1404);
    $con = new WAIT::Client $host, Port => $port;
    last if $con;
  }
}
my $tmp = $CPAN::META->catfile
  (
   $CPAN::Config->{'cpan_home'},
   'w4c.pod'
   );

unless ($con) {
  warn <<EOM
Could not connect to the WAIT server at $host port $port
So no searching available. Either your box is not connected to the
Internet or the WAIT server is down for maintenance.

EOM
  ;
}

sub wq {
  my $self = shift;
  my $result;
  local ($") = ' ';
  
  print "Searching for @_\n";
  unless ($result = $con->search(@_)) {
    print "Your query contains a syntax error.\n";
    query_help();
  } else {
    print @{$result};
    print "Type 'wr <number>' or 'wd <number>' to examine the results\n";
  }
  $result;
}

sub wr {
  my $self = shift;
  my $hit  = shift;
  my $result;
  
  if (@_ or !$hit) {
    print "USAGE: w <hit-number>\n";
  } else {
    print "What is hit number $hit\n";
    $result = $con->info($hit);
    print @$result;
  }
  $result;
}

sub wd {
  my $self = shift;
  my $hit  = shift;
  my $result;

  if (@_ or !$hit) {
    print "USAGE: g <hit-number>\n";
    return;
  } 
  print "Get hit number $hit ...";
  my $text  = $con->get($hit);
  my $lines = ($text)?@$text:'no';
  print " done\nGot $lines lines\nRunning perldoc on it ...\n";
  
  # perldoc does not read STDIN; so we need a temp file
  {
    my $fh = new FileHandle ">$tmp";
    $fh->print(@{$text});
  }

  # is system available every were ??
  system $^X, '-S', 'perldoc', $tmp
    and warn "Could not run '$^X -S perldoc $tmp': $?\n"
      and print @$text;         # should we pipe to a pager here?
  $text;
}

sub wl {
  my $self = shift;
  my $hits = shift;

  if (@_) {
    print "USAGE: wl <maximum-hit-count>\n";
    return;
  } 
  $con->hits($hits);
}

sub wh {
  my $self = shift;
  my $cmd  = shift;

  if ($cmd and $cmd =~ /q$/) {
    query_help();
  } else {
    print qq[
Available commands:
wq        query           search the WAIT4CPAN server
wr        hit-number      display search result record
wr        hit-number      fetch the document and run perldoc on it
wl        count           limit search to <count> hits
wh        command         displays help on command if available
];
  }
  1;
}


sub query_help {
  print q{
Here are some query examples:

information retrieval               free text query 
information or retrieval            same as above 
des=information retrieval           `information' must be in the description 
des=(information retrieval)         one of them in description 
des=(information or retrieval)      same as above 
des=(information and retrieval)     both of them in description 
des=(information not retrieval)     `information' in description and
                                    `retrieval' not in description 
des=(information system*)           wild-card search
au=ilia                             author names may be misspelled

You can build arbitary boolean combination of the above examples.
Field names may be abbreviated.
}
}

END {
  unlink $tmp if -e $tmp;
}

$con;

__DATA__

=head1 NAME

CPAN::WAIT - adds commands to search a WAIT4CPAN server to the CPAN C<shell()>

=head1 SYNOPSIS

  perl -MCPAN -e shell
  > ws au=wall
  > wr 3
  > wd 3
  > wl 20
  > wh
  > wh ws

=head1 DESCRIPTION

B<CPAN::WAIT> adds some comands to the CPAN C<shell()> to perform
searches on a WAIT server. It connects to a WAIT server using a simple
protocoll resembling NNTP as described in RFC977. It uses the
B<WAIT::Client> module to handle this connection. This in turn
inherits from B<Net::NNTP> from the F<libnet> package. So you need
B<Net::NNTP> to use this module.

The commands available are:

=over 

=item B<wh> [B<command>]

Displays a short help message if called without arguments. If you
provide the name of another command you will get more information on
this command if available. Currently only B<ws> will be explained.

=item B<wl> I<count>

Limit the number of hits returned in a search to I<count>. The limit
usually is set ot 10 of you don't set it.

=item B<ws> I<query>

Send a query to the server. 

Here are some query examples:

  information retrieval               free text query 
  information or retrieval            same as above 
  des=information retrieval           `information' must be in the description 
  des=(information retrieval)         one of them in description 
  des=(information or retrieval)      same as above 
  des=(information and retrieval)     both of them in description 
  des=(information not retrieval)     `information' in description and
                                      `retrieval' not in description 
  des=(information system*)           wild-card search
  au=ilia                             author names may be misspelled

You can build arbitary boolean combination of the above examples.
Field names may be abbreviated. For further information see
F<http://ls6-www.informatik.uni-dortmund.de/CPAN>

The result should look like this:

  ws au=wall

   1 8.039 a2p - Awk to Perl translator 
   2 8.039 s2p - Sed to Perl translator 
   3 8.039 perlipc - Perl interprocess communication (signals, fifos, pipes, safe subprocesses, sockets, and semaphores) 
   4 8.039 ExtUtils::DynaGlue - Methods for generating Perl extension files 
   5 8.039 h2xs - convert .h C header files to Perl extensions 
   6 8.039 Sys::Syslog, openlog, closelog, setlogmask, syslog - Perl interface to the UNIX syslog(3) calls 
   7 8.039 h2ph - convert .h C header files to .ph Perl header files 
   8 8.039 Shell - run shell commands transparently within perl 
   9 8.039 pl2pm - Rough tool to translate Perl4 .pl files to Perl5 .pm modules. 
  10 8.039 perlpod - plain old documentation 

=item B<wr> I<hit-number>

Display the Record of hit number I<hit-number>:

  wr 1
  
  source          authors/id/CHIPS/perl5.003_24.tar.gz
  headline        a2p - Awk to Perl translator 
  size            5643
  docid           data/perl/x2p/a2p.pod


=item B<wd> I<hit-number>

Fetches the full text from the server and runs B<perlpod> on it. Make
sure that you have B<perlpod> in your path. Also check if your
B<perlpod> version can handle absolute pathes. Some older versions
ironically do not find a document if the full patch is given on the
command line.

=back

=head1 AUTHOR

Ulrich Pfeifer E<lt>F<pfeifer@ls6.informatik.uni-dortmund.de>E<gt>

