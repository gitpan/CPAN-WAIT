#!/app/unido-i06/magic/perl
# Makefile.PL -- 
# ITIID           : $ITI$ $Header $__Header$
# Author          : Ulrich Pfeifer
# Created On      : Fri Jan 31 15:36:26 1997
# Last Modified By: Ulrich Pfeifer
# Last Modified On: Tue Feb 11 15:44:55 1997
# Language        : CPerl
# Update Count    : 18
# Status          : Unknown, Use with caution!
# 
# (C) Copyright 1997, Universität Dortmund, all rights reserved.
# 

use ExtUtils::MakeMaker;

WriteMakefile
  (
   'NAME'	   => 'CPAN::WAIT',
   'VERSION_FROM'  => 'lib/CPAN/WAIT.pm', # finds $VERSION
   'PREREQ_PM'     =>
   {
    CPAN      => 0,
    Net::NNTP => 0,
   },                         
   'dist'          =>
   {
    PREOP        => 'pod2text lib/CPAN/WAIT.pm > README;'.
                    'changelog -update',
    DIST_DEFAULT => 'tardist',
    COMPRESS     => 'gzip -9f'
   },
);
