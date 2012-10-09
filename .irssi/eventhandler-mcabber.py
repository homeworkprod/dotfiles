#!/usr/bin/env python

"""
An event handler script for MCabber_, an ncurses-based Jabber/XMPP client.

When direct or MUC (multi-user chat) messages come in, the wmii_ window
manager's tag that MCabber_ runs on is highlighted.

To be able to have wmii_ identify that tag, pass something to the terminal when
launching MCabber_ that it can look for. I use `rxvt-unicode`_ (a.k.a. urxvt)
as terminal and launch MCabber with this shell script::

    #!/bin/sh

    # Start MCabber with a custom window title so the window manager can recognize it.
    urxvt -title mcabber -e mcabber &

That allows me to use the following tag rule in ``~/.wmii-3.5/wmiirc``::

    /mcabber/ -> jabber

You can change the resulting tag name (here: "jabber"), but have to change
``TAG_NAME`` below, too.

Save this script as ``~/.mcabber/eventhandler.py`` and adjust the configuration
(usually ``~/.mcabber/mcabberrc``) with this line::

    set events_command = ~/.mcabber/eventhandler.py

.. _MCabber: http://mcabber.com/
.. _wmii: http://wmii.suckless.org/
"""

import subprocess
import sys


TAG_NAME = 'im'
TAG_COLORS = '#eeeeee #aa0000 #ee0000'

if len(sys.argv) >= 3 and sys.argv[1] == 'MSG' and sys.argv[2] in ('IN', 'MUC'):
    # Determine currently selected tag.
    p = subprocess.Popen(['wmiir', 'read', '/tag/sel/ctl'], stdout=subprocess.PIPE)
    current_tag = p.stdout.readline().strip()

    # Highlight target tag if not already selected.
    if current_tag != TAG_NAME:
        subprocess.Popen(['wmiir', 'write', '/lbar/' + TAG_NAME],
            stdin=subprocess.PIPE).communicate(TAG_COLORS + ' ' + TAG_NAME)
