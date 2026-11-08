#!/usr/bin/env bash
# Verifies every external URL in README.md, docs/*.md and site/index.html,
# then smoke-tests the static site with a local HTTP server.
#
# Usage: ./scripts/verify_links.sh
set -u
cd "$(dirname "$0")/.."

UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"
TIMEOUT=25

# Domains that 403 automated traffic but normally open in browsers. Reported
# honestly as BOT-BLOCKED, not counted as hard failures.
KNOWN_BOT_BLOCKED="pixabay.com musopen.org"

pass=0; bblocked=0; fail=0

# Collect unique URLs from README, docs and the site page.
# Strip trailing markdown/punctuation artifacts, and skip localhost examples.
urls=$(grep -hoE 'https?://[a-zA-Z0-9._~:/?#@!$&'"'"'()*+,;=%-]+' \
      README.md docs/*.md site/index.html \
      | sed -E 's/[*),.]+$//' | grep -v '^http://localhost' | sort -u)

if [ -z "$urls" ]; then
  echo "ERROR: no URLs found in README.md, docs/*.md, site/index.html"
  exit 1
fi

is_known_botblocked() {
  local d="$1"
  for b in $KNOWN_BOT_BLOCKED; do
    [ "$d" = "$b" ] && return 0
  done
  return 1
}

printf "\n%-10s %s\n" "STATUS" "URL"
while IFS= read -r url; do
  code=$(curl -sSL -o /dev/null -w "%{http_code}" --max-time "$TIMEOUT" -A "$UA" "$url" 2>/dev/null)
  case "$code" in
    2*)
      printf "%-10s %s\n" "OK($code)" "$url"; pass=$((pass+1)) ;;
    301|302|303|307|308)
      printf "%-10s %s\n" "OK($code)" "$url"; pass=$((pass+1)) ;;
    403)
      if is_known_botblocked "$(echo "$url" | grep -oE '(pixabay\.com|musopen\.org)')"; then
        printf "%-10s %s\n" "BOT-BLOCKED(403)" "$url"; bblocked=$((bblocked+1))
      else
        printf "%-10s %s\n" "FAIL($code)" "$url"; fail=$((fail+1))
      fi ;;
    000)
      printf "%-10s %s\n" "UNREACHABLE" "$url"; fail=$((fail+1)) ;;
    *)
      printf "%-10s %s\n" "FAIL($code)" "$url"; fail=$((fail+1)) ;;
  esac
done <<< "$urls"

# Smoke test: serve the repo root and fetch site/index.html plus every
# local (relative) href we ship in it, to be sure the site serves itself.
printf "\n%s\n" "---- site smoke test ----"
port=$(comm -23 <(seq 8000 8049) <(ss -ltn 2>/dev/null | grep -oE ':(80[0-9]{2})' | tr -d ':' | sort -u | head -3) 2>/dev/null | head -1)
[ -z "$port" ] && port=8123
python3 -m http.server "$port" >/dev/null 2>&1 &
srv_pid=$!
sleep 1.5
site_fail=0
for page in "site/index.html" "docs/index.md" "docs/library-streaming.md" \
            "docs/public-radio.md" "docs/coding-gaming-stations.md" \
            "docs/older-music-archives.md" "docs/royalty-free-music.md" "README.md" "LICENSE"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$port/$page")
  if [ "$code" != "200" ]; then
    echo "SERVE FAIL ($code): /$page"
    site_fail=$((site_fail+1))
  fi
done
kill "$srv_pid" 2>/dev/null
wait "$srv_pid" 2>/dev/null

if [ $site_fail -eq 0 ]; then
  echo "site smoke test: all 9 pages served with HTTP 200"
else
  echo "site smoke test: $site_fail page(s) failed"
fi

printf "\n---- summary ----\n"
echo "external links OK:      $pass"
echo "bot-blocked 403 (flagged, not failed): $bblocked"
echo "external links FAILED:  $fail"
echo "site serve failures:    $site_fail"

if [ "$fail" -gt 0 ] || [ "$site_fail" -gt 0 ]; then
  echo "RESULT: FAIL"
  exit 1
fi
echo "RESULT: PASS"
