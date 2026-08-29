#!/bin/sh
# The Ladder. Private: served behind the shared sign-in, because goals and a
# family calendar are not public. SS_STORE=1 gives it the small JSON store.
d=$(cd "$(dirname "$0")" && pwd)
HOST=127.0.0.1
for a in "$@"; do
  case "$a" in
    --expose) HOST=0.0.0.0 ;;
    --host=*) HOST="${a#--host=}" ;;
  esac
done
[ -f "$d/data/ladder.pid" ] && kill "$(cat "$d/data/ladder.pid")" 2>/dev/null
rm -f "$d/data/ladder.pid"
mkdir -p "$d/data"
SS_ROOT="$d" SS_INDEX="dashboard.html" SS_SLUG="ladder" SS_STORE=1 \
SS_HTTPS=1 SS_TRUST_PROXY=1 SS_HOST="$HOST" SS_PORT="${SS_PORT:-8773}" \
  nohup python3 "$d/../_shared/serve_static.py" >> "$d/data/server.log" 2>&1 &
echo $! > "$d/data/ladder.pid"
curl -s --retry 30 --retry-connrefused --retry-delay 1 --max-time 30 \
  "http://127.0.0.1:${SS_PORT:-8773}/healthz" >/dev/null 2>&1
echo "ladder -> http://$HOST:${SS_PORT:-8773}"
