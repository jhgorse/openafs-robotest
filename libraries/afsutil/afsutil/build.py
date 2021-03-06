# Copyright (c) 2014-2015 Sine Nomine Associates
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THE SOFTWARE IS PROVIDED 'AS IS' AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

"""Helper to build OpenAFS for development and testing."""

import logging
import os
import sys

logger = logging.getLogger(__name__)

def run(cmd):
    logger.info("Running %s", cmd)
    code = os.system(cmd)
    if code != 0:
        logger.error("Command failed with code %d" % (code))
        sys.exit(code)

def rebuild(chdir=None, cf=None, target=None, clean=True, **kwargs):
    origdir = None
    if chdir is not None:
        logger.info("Changing to directory %s", chdir)
        origdir = os.getcwd()
        os.chdir(chdir)

    if cf is None:
        uname = os.uname()[0]
        options = [
            '--enable-debug',
            '--enable-debug-kernel',
            '--disable-optimize',
            '--disable-optimize-kernel',
            '--without-dot',
            '--enable-transarc-paths',
        ]
        if uname == "Linux":
            options.append('--enable-checking')
        cf = ' '.join(options)

    if target is None:
        if '--enable-transarc-paths' in cf:
            target = 'dest'
        else:
            target = 'all'

    if clean:
        if os.path.isdir('.git'):
            run('git clean -f -d -x -q')
        else:
            if os.path.isfile('./Makefile'):
                run('make clean')
    run('./regen.sh')
    run('./configure %s' % (cf))
    run('make %s' % (target))
    if origdir:
        logger.info("Changing to directory %s", origdir)
        os.chdir(origdir)

if __name__ == '__main__':
    logging.basicConfig(format='%(levelname)s %(message)s',level=logging.INFO)
    rebuild()
