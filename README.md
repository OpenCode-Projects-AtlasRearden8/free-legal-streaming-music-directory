# Free & Legal Streaming Music Directory

A friendly directory of **free and legal ways to hear music and calm audio**: library streaming passes, public-radio apps, live coding-game stations, archives for older music, and royalty-free players.

Built the way **Asdale Dynamics, LLC** likes to build things: plain English, step by step, and with the fine print translated into human. Every entry includes a warm blurb *and* an honest "The Fine Print" note about free-tier limits, ads, or library-card requirements.

## What's inside

| Doc | What's there | Best for |
| --- | --- | --- |
| [docs/index.md](docs/index.md) | Start here: everything on one page | Browsing |
| [docs/library-streaming.md](docs/library-streaming.md) | Hoopla, Freegal, Naxos via your library card | Big catalogs, no ads |
| [docs/public-radio.md](docs/public-radio.md) | NPR, KEXP, YourClassical, WFMT, Radio Garden | Radio that respects you |
| [docs/coding-gaming-stations.md](docs/coding-gaming-stations.md) | Rainwave, SomaFM, Chillhop, LoFi Café, OC ReMix | Focus + play sessions |
| [docs/older-music-archives.md](docs/older-music-archives.md) | Internet Archive, National Jukebox, IMSLP | Vintage recordings, public domain |
| [docs/royalty-free-music.md](docs/royalty-free-music.md) | FMA, ccMixter, Pixabay, Incompetech, Bensound, Musopen | Videos, podcasts, projects |

## How to use it

**Read it as markdown:** open `docs/index.md` in any text editor, or view these files on GitHub, which renders Markdown automatically.

**Use the site:** the same directory is a static website in `site/`. Open `site/index.html` directly in your browser, or serve everything with the repo root as the base:

```bash
python3 -m http.server 8000
# then visit http://localhost:8000/site/
```

(Serving from the repo root also makes the site's links into the Markdown guides in `docs/` clickable.)

## Verify the links yourself

`scripts/verify_links.sh` extracts every URL from the README, docs, and site, then checks each with `curl`. It also smoke-tests the static site:

```bash
./scripts/verify_links.sh
```

A few sites (Musopen, Pixabay) block automated tools with a `403` — the script marks them as `BOT-BLOCKED (403)` rather than treating them as dead. That the site *opens in a normal browser* is something a script can't prove for those two; we flag the exception instead of pretending. Everything else must pass with a 200.

## Good to know

- **Scope:** every source here streams for free with no required subscription. When something pushes a paid tier, we say so.
- **Not legal advice:** rights change over time; check a site's terms before using its music in a commercial project.
- **Different directory?** Yes: this one is about *music and calm audio* — it does not duplicate our free audiobook directory or our free sleep-sounds directory, though all three enjoy the same "free and legal, fine print included" spirit.
- **No tracking, no keys:** static files only. No analytics, no API keys, no personal data, no secrets.

## Run / build / test

No build step is required — it's all static Markdown and HTML.

- **Read:** open the files in `docs/`.
- **Serve:** `python3 -m http.server 8000` (repo root), then browse http://localhost:8000/site/
- **Test:** `./scripts/verify_links.sh`
- **License:** MIT — see [LICENSE](LICENSE).

---

Directory and site by **Asdale Dynamics, LLC** — part of Dylan Asdale's beginner-friendly AI hub at [dylanasdale.github.io](https://dylanasdale.github.io). We explain AI "like a friend would": plain English, step by step, never condescending.
