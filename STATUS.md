# STATUS.md — Free & Legal Streaming Music Directory

Last updated: 2026-11-08

## What was built

A directory of **free and legal ways to hear music and calm audio**, maintained for Dylan Asdale / Asdale Dynamics, LLC, in two parallel formats:

- **Markdown guides (`docs/`)** — start at `docs/index.md`, then five category docs:
  - `docs/library-streaming.md` — Hoopla, Freegal, Naxos (library-card streaming)
  - `docs/public-radio.md` — NPR, KEXP, YourClassical, WFMT, Radio Garden
  - `docs/coding-gaming-stations.md` — Rainwave, SomaFM, Chillhop, LoFi Café, Lofi Girl, OC ReMix
  - `docs/older-music-archives.md` — Internet Archive audio, IA 78 RPM, IA etree, National Jukebox, IMSLP
  - `docs/royalty-free-music.md` — FMA, ccMixter, Pixabay Music, Incompetech, Bensound, Musopen
- **Static website (`site/index.html`)** — a single self-contained HTML page (no JS, no external assets) mirroring the directory as cards with "Fine print" callouts.
- **Link verification (`scripts/verify_links.sh`)** — extracts every external URL from README/docs/site, curls each, and smoke-tests local serving of all 9 pages.

Every entry in every category carries a warm blurb **plus an honest "The Fine Print" section** (free-tier limits, ads, library-card requirements, license quirks). Scope is deliberately distinct from our free-audiobook and free-sleep-sounds directories.

## How to run it

- **Read:** open `README.md`, then `docs/index.md` (plain text or a Markdown renderer).
- **Serve the site:**
  ```bash
  python3 -m http.server 8000        # from the repo root
  # then visit http://localhost:8000/site/
  ```
  Or just open `site/index.html` directly in a browser. Serving from the repo root keeps the site's `../docs/` links clickable.
- **Verify links + build:**
  ```bash
  ./scripts/verify_links.sh
  ```

## Verification results (2026-11-08)

- `./scripts/verify_links.sh` → **RESULT: PASS**
  - 28 external links returned HTTP 200
  - 2 links flagged as `BOT-BLOCKED (403)` (see known gaps)
  - 0 external link failures
  - 0 site-serve failures — all 9 local pages (`site/index.html`, 6 docs, README, LICENSE) served HTTP 200
- HTML parse check (tag-balance via Python `html.parser`) → PASS
- Site-local relative links resolve to real files → PASS
- No CJK/garbled tokens, no secrets or personal data, `LICENSE` copyright line is exactly `Copyright (c) 2026 Asdale Dynamics, LLC`
- Links verified with a browser-shaped User-Agent; sites were manually probed while curating (e.g., confirming the IA `78rpm` collection URL, dropping a dead radio station that failed TLS repeatedly)

## Known gaps

- **Musopen and Pixabay Music 403-block automated traffic** (confirmed via both curl and a separate fetch pipeline). They are famous, stable services, so they're listed, but the script honestly reports them as `BOT-BLOCKED (403)` rather than "verified" — neither this tool nor a browser claim could be machine-proven from this environment.
- External catalogs rotate (library services especially); individual albums/availability change without notice.
- Licenses for royalty-free sources change; the docs tell readers to check current terms, but we do not (and cannot legally) re-verify licenses continuously.
- Deeper per-station metadata (stream URLs, direct audio endpoints) intentionally not documented — playback is left to each service's own player, which keeps every downstream player URL out of scope.
- The site links to `docs/` relatively (`../docs/…`), so serving `site/` as the *only* served directory (`--directory site`) breaks those two doc links; serve the repo root instead (README says so).

## Fine print of our own

MIT licensed (`LICENSE`, exact line: `Copyright (c) 2026 Asdale Dynamics, LLC`). No analytics, no API keys, no personal data, no secrets. Plain commit messages only; nothing was pushed or published.
