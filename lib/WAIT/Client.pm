#                              -*- Mode: Perl -*- 
# Client.pm -- 
# ITIID           : $ITI$ $Header $__Header$
# Author          : Ulrich Pfeifer
# Created On      : Fri Jan 31 10:49:37 1997
# Last Modified By: Ulrich Pfeifer
# Last Modified On: Sun Feb  2 21:09:06 1997
# Language        : CPerl
# Update Count    : 5
# Status          : Unknown, Use with caution!
# 
# (C) Copyright 1997, Universität Dortmund, all rights reserved.
# 
# $Locker$
# $Log$
# 
# Code snarfed from Net::NNTP and modified

package WAIT::Client;
use Net::NNTP ();
use Net::Cmd qw(CMD_OK);
use Carp;
use strict;
use vars qw(@ISA);

@ISA = qw(Net::NNTP);

sub search
{
  my $wait = shift;
  
  $wait->_SEARCH(@_)
    ? $wait->read_until_dot()
      : undef;
}

sub info
{
  @_ == 2 or croak 'usage: $wait->info( HIT-NUMBER )';
  my $wait = shift;
  
  $wait->_INFO(@_)
    ? $wait->read_until_dot()
      : undef;
}

sub get
{
  @_ == 2 or croak 'usage: $wait->info( HIT-NUMBER )';
  my $wait = shift;
  
  $wait->_GET(@_)
    ? $wait->read_until_dot()
      : undef;
}

sub database
{
  @_ == 2 or croak 'usage: $wait->database( DBNAME )';
  my $wait = shift;
  
  $wait->_DATABASE(@_);
}

sub table
{
  @_ == 2 or croak 'usage: $wait->table( TABLE )';
  my $wait = shift;
  
  $wait->_TABLE(@_);
}

sub hits
{
  @_ == 2 or croak 'usage: $wait->hits( NUM-MAX-HITS )';
  my $wait = shift;
  
  $wait->_HITS(@_);
}

sub _SEARCH   { shift->command('SEARCH',   @_)->response == CMD_OK }
sub _INFO     { shift->command('INFO',     @_)->response == CMD_OK }
sub _GET      { shift->command('GET',      @_)->response == CMD_OK }
sub _DATABASE { shift->command('DATABASE', @_)->response == CMD_OK }
sub _TABLE    { shift->command('TABLE',    @_)->response == CMD_OK }
sub _HITS     { shift->command('HITS',     @_)->response == CMD_OK }

1;
