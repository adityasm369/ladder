#!/bin/sh
d=$(cd "$(dirname "$0")" && pwd)
[ -f "$d/data/ladder.pid" ] && kill "$(cat "$d/data/ladder.pid")" 2>/dev/null
rm -f "$d/data/ladder.pid"; echo "ladder stopped"
