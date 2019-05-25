## Dada shell theme

A simple Fish shell theme designed exactly how I want it.

Install in `~/.config/dada`.

### Other commands

Start with:

* `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
* `brew install node python3`

Make sure to install:

* This repository (in `~/.config/dada`)
* GNU coreutils and other tools: `brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep`
* [misc-bin](https://bitbucket.org/msikma/misc-bin)
* [misc-scripts](https://github.com/msikma/misc-scripts) (both of these in `~/.bin/`)
* `npm install --global trash-cli empty-trash-cli fileicon ascr cheerio request feedparser-promised dist-exiftool node-exiftool sanitize-filename`
* `pip3 install glances mdv`
* `brew install exa tldr git-extras youtube-dl bat fd ncdu coreutils flac ecm findutils`
* `brew install diff-so-fancy` ([configure](https://github.com/so-fancy/diff-so-fancy))
* VS Code: `code-insiders` command - ⇧⌘P and search for 'install'
* [vgmpfdl](https://github.com/msikma/vgmpfdl)
* [bfg](https://rtyley.github.io/bfg-repo-cleaner/)
* [MacDown](https://macdown.uranusjr.com/)
* [ekizo-dl](https://github.com/msikma/ekizo-dl) (symlink in `~/.bin/`)

`ps2pdf` should be installed by default, but just in case it isn't it can be found [here](https://www.ghostscript.com/doc/current/Ps2pdf.htm).

Other utilities (unlisted):

* [MultiPatch](http://www.romhacking.net/utilities/746/)
* For the `ekizo-dl` command running in the Cron job: `git clone git@github.com:msikma/ekizo-dl.git` ~/Projects/ekizo-dl

For icons:

* `brew install git-lfs`
* `git lfs install`
* `git clone https://github.com/msikma/osx-folder-icons ~/Projects/osx-folders`
* `git clone git@bitbucket.org:msikma/dada-icons.git ~/Projects/dada-icons`

Add a file in `~/.config/fish` called `config.fish`:

```
echo "source ~/.config/dada/dada.fish" > ~/.config/fish/config.fish
```

### Cron job

To set up the Cron job, simply run `cron-install`. If this somehow doesn't work, it can be manually installed as follows:

1. Copy the LaunchAgent plist file `etc/com.dada.crontab.plist` to `~/Library/LaunchAgents`
2. Activate it: `launchctl load ~/Library/LaunchAgents/com.dada.crontab.plist`.

Note that the `run-cron.fish` file doesn't use `env` to invoke Fish - it doesn't seem to be supported when running a Cron job.

### Copyright

MIT license
