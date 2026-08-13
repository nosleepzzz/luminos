# Hosting and deployment

## Website

GitHub Pages serves the landing page from this repository (`website/` / root `index.html` via existing Pages workflows).

## ISO distribution (after a real build exists)

| Channel | Role |
| --- | --- |
| **GitHub Releases** | Primary tagged ISO + `.sha256` |
| **SourceForge** | Public mirror only |

### SourceForge API key safety

- Store credentials as a local environment variable or GitHub Actions secret named `SOURCEFORGE_API_KEY`.
- Never commit keys, paste them into issues/chat, or bake them into scripts in-tree.
- Rotate any key that was exposed.

Upload automation is deferred until Phase 1 produces a verified bootable Glass ISO on a Linux build host.

## Package repo (optional later)

`tools/make-repo.sh` can build a small `lumin-tools` pacman package for custom mirrors. Not required for the first Glass ISO.
