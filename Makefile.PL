#                              -*- Mode: Perl -*- 
# $Basename: Makefile.PL $
# $Revision: 1.4 $
# Author          : Ulrich Pfeifer
# Created On      : Fri Jan 31 15:36:26 1997
# Last Modified By: Ulrich Pfeifer
# Last Modified On: Mon Aug 11 17:55:55 1997
# Language        : CPerl
# Update Count    : 24
# Status          : Unknown, Use with caution!
# 
# (C) Copyright 1997, Ulrich Pfeifer, all rights reserved.
# 
# 

use ExtUtils::MakeMaker;

WriteMakefile
  (
   'NAME'	   => 'CPAN::WAIT',
#  $Format: "   'VERSION' => '$ModuleVersion$',"$
   'VERSION' => '0.25',
   'PREREQ_PM'     =>
   {
    CPAN      => 0,
    Net::NNTP => 0,
   },                         
   'dist'          =>
   {
    PREOP        => 'pod2text lib/CPAN/WAIT.pm > README;',
    DIST_DEFAULT => 'tardist',
    COMPRESS     => 'gzip -9f'
   },
);
