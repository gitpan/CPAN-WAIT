#!/app/unido-i06/magic/perl
#                              -*- Mode: Perl -*- 
# test.pl -- 
# ITIID           : $ITI$ $Header $__Header$
# Author          : Ulrich Pfeifer
# Created On      : Fri Jan 31 16:34:58 1997
# Last Modified By: Ulrich Pfeifer
# Last Modified On: Sun Feb  2 21:12:19 1997
# Language        : CPerl
# Update Count    : 12
# Status          : Unknown, Use with caution!
# 
# (C) Copyright 1997, Universität Dortmund, all rights reserved.
# 
# $Locker:  $
# $Log: basic.t,v $
# Revision 1.2  1997/02/04 15:27:24  pfeifer
# *** empty log message ***
#
# 

BEGIN { $| = 1; print "1..5\n"; }
END {print "not ok 1\n" unless $loaded;}
use CPAN::WAIT;
$loaded = 1;
print "ok 1\n";
my $test   = 2;

my
$status = CPAN::WAIT->wh();
print "not " unless $status; print "ok $test\n"; $test++;

$status = CPAN::WAIT->wl(3);
print "not " unless $status; print "ok $test\n"; $test++;

$status = CPAN::WAIT->wq(qw(au=wall and au=larry));
print "not " unless $status; print "ok $test\n"; $test++;

$status = CPAN::WAIT->wr(1);
print "not " unless $status; print "ok $test\n"; $test++;

