#!/bin/sh

##
# View diffs in a Subversion working copy
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
# SERVICEMENU : Subversion/View Changes (diff)

##
# Functions
##

do_diff ()
{
  local Target="$1";

  DiffFile=$(mktemp -t "SVN Diff : $(basename "${Target}")");

  if svn diff "${Target}" >> "${DiffFile}" 2>/dev/null && [ -s "${DiffFile}" ]; then
    open -e "${DiffFile}";
    (sleep 10 && rm -f "${DiffFile}";) &
  else
    echo "Can't diff: ${Target}";
    rm -f "${DiffFile}";
  fi;
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