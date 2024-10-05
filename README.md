---

<div align="center">
  <h3>🎶 Last.fm for YouTube Music </h3>
  <p>Last.fm integration for the YouTube Music iOS app.</p>
</div>

---

## Requirements
- A jailbroken device OR the YouTube Music IPA sideloaded with this tweak.

## Setup - Scripted

- Fill out the `LASTFM_API_KEY` and `LASTFM_API_SECRET` variables in `Makefile`
= With docker installed on the system, run `build.sh`

## Setup - Manual
- Fill out the `LASTFM_API_KEY` and `LASTFM_API_SECRET` variables in `Makefile`
- Install [Theos](https://github.com/theos/theos)
- Build with `[make|gmake] clean package FINALPACKAGE=1`



## Licensing
See [LICENSE](/LICENSE).
