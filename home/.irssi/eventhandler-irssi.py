#!/usr/bin/env python

"""Highlight a wmii_ tag on irssi events.

.. _wmii: http://wmii.suckless.org/
"""

import subprocess
import sys


TAG_NAME = 'im'
TAG_COLORS = '#eeeeee #aa0000 #ee0000'

# Determine currently selected tag.
p = subprocess.Popen(['wmiir', 'read', '/tag/sel/ctl'], stdout=subprocess.PIPE)
current_tag = p.stdout.readline().strip()

# Highlight target tag if not already selected.
if current_tag != TAG_NAME:
    subprocess.Popen(['wmiir', 'write', '/lbar/' + TAG_NAME],
        stdin=subprocess.PIPE).communicate(TAG_COLORS + ' ' + TAG_NAME)
