# homebrew-tap

Homebrew formulae for my tools.

```sh
brew install mac-lucky/tap/pushward
```

| Formula | Source |
|---|---|
| `pushward` | [pushward-cli](https://github.com/mac-lucky/pushward-cli), the PushWard command-line client |

Formulae build from the source release and come with bottles for Apple Silicon macOS and for Linux (x86_64 and arm64), so an install is a download, not a build. Intel Macs build from source. A release of the tool opens a bump PR here; `brew test-bot` builds the bottles on it and the PR is published once those pass. Don't edit the `bottle do` blocks by hand.
