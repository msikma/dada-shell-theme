## Dada shell theme

A simple Fish shell theme designed exactly how I want it. This readme also contains instructions for installing all the terminal tools I commonly use.

![Screenshot of Dada shell theme](etc/dada_screenshot_1.png?raw=true)

### Installation

First, install the [Fish shell](https://fishshell.com/) and [set it as the default](https://stackoverflow.com/a/26321141).

Then clone this repository in `~/.config/dada`. Create a file at `~/.config/fish/config.fish` that loads the theme with the following command:

```fish
echo "source ~/.config/dada/dada.fish" > ~/.config/fish/config.fish
```

You should now see the welcome message when opening a new terminal window.

#### Installing utilities

1. Install [Brew](https://brew.sh/):

    `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

2. Install the following Brew packages:

    `brew install bat composer coreutils ecm exa fd findutils flac gawk git-extras gnu-getopt gnu-indent gnu-sed gnu-tar gnutls grep ncdu node python3 rsync streamlink tldr wget xdelta youtube-dl`

3. Install the following [npm](https://www.npmjs.com/) packages:

    `npm i -g ascr cheerio dist-exiftool empty-trash-cli feedparser-promised fileicon imagemagick node-exiftool request sanitize-filename trash-cli vgmpfdl`

After this there are some applications and packages that require extra configuration:

* [Visual Studio Code](https://code.visualstudio.com/): to add the `code-insiders` command (needed for `code`), press **⇧⌘P** and search for "install"
* Clone the [misc-bin](https://bitbucket.org/msikma/misc-bin) and [misc-scripts](https://github.com/msikma/misc-scripts) repos to `~/.bin/`
* `brew install diff-so-fancy` - and [configure it](https://github.com/so-fancy/diff-so-fancy)
* Download [BFG Repo Cleaner](https://rtyley.github.io/bfg-repo-cleaner/) and put its binary in `~/.bin/`
* `ps2pdf` should be installed by default, but just in case it isn't, [it can be found here](https://www.ghostscript.com/doc/current/Ps2pdf.htm)
* [MacDown](https://macdown.uranusjr.com/)
* [ips.py](https://github.com/fbeaudet/ips.py)
* [MultiPatch](http://www.romhacking.net/utilities/746/)
* Quick look plugins:

    * [quick look JSON](http://www.sagtau.com/quicklookjson.html) (copy to `~/Library/QuickLook/` and restart the service with `qlmanage -r`)
    * [Markdown Quick Look plugin](http://inkmarkapp.com/markdown-quick-look-plugin-mac-os-x/)

* For the `ekizo-dl` command (used by the cron job; needs to be symlinked in `~/.bin/`):

    `git clone git@github.com:msikma/ekizo-dl.git ~/Projects/ekizo-dl`

* Install [Git LFS](https://git-lfs.github.com/):

    1. `brew install git-lfs`
    2. `git lfs install`

* Install the two icon repos (for the `color` command):

    1. `git clone https://github.com/msikma/osx-folder-icons ~/Projects/dada-folder-icons`
    2. `git clone git@bitbucket.org:msikma/dada-icons.git ~/Projects/dada-icons`

### Backups

To see the current backup status, use `backup`. This prints a list of the available commands and how long it has been since they were last used.

Backup scripts listed under *"non device specific"* are global; they can be run on any device and store their data in the same place. The other scripts store their data in a directory named after the current hostname (`~/.cache/dada`).

### Cron job

To set up the cron job, run `cron-install`. If this somehow doesn't work, it can be manually installed as follows:

1. Copy the LaunchAgent plist file `etc/com.dada.crontab.plist` to `~/Library/LaunchAgents`
2. Activate it: `launchctl load ~/Library/LaunchAgents/com.dada.crontab.plist`.

Note that the `run-cron.fish` file doesn't use `env` to invoke Fish - it doesn't seem to be supported when running a cron job.

### Copyright

MIT license
