#!/app/unido-i06/magic/perl
# Makefile.PL -- 
# ITIID           : $ITI$ $Header $__Header$
# Author          : Ulrich Pfeifer
# Created On      : Fri Jan 31 15:36:26 1997
# Last Modified By: Ulrich Pfeifer
# Last Modified On: Fri Jan 31 16:54:40 1997
# Language        : CPerl
# Update Count    : 8
# Status          : Unknown, Use with caution!
# 
# (C) Copyright 1997, Universität Dortmund, all rights reserved.
# 
# $Locker$
# $Log$
# 

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
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
    PREOP        => 'co -l README && pod2text lib/CPAN/WAIT.pm > README && '.
                    'ci -u README',
    DIST_DEFAULT => 'tardist',
    COMPRESS     => 'gzip -9f'
   },
);
