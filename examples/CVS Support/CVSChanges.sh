#!/bin/sh

##
# View changes in a CVS working copy
#
# Wilfredo Sanchez | wsanchez@opensource.apple.com
# Copyright (c) 2002 Wilfredo Sanchez Vega.
# All rights reserved.
#
# Permission to use, copy, modify, and distribute this software for
# any purpose with or without fee is hereby granted, provided that the
# above copyright notice and this permission notice appear in all
# copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHORS DISCLAIM ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHORS BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
# OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
# NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
# WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
##

# EXTENSIONS  : "*"
# OSTYPES     :	"****"
# ROLE        : Viewer
# SERVICEMENU : CVS/View Changes (FileMerge)

##
# Functions
##

do_diff ()
{
  local Target="$1";
  local  Files="";

  # Defer the work here to cvs-view-diffs
  cd $(dirname "${Target}") && cvs-view-diffs $(basename "${Target}");
}

##
# Handle arguments
##

Targets="$@";

##
# Do The Right Thing
##

for Target in ${Targets}; do
  do_diff "${Target}";
done;

exit 0;
