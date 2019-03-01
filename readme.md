## Dada shell theme

A simple Fish shell theme designed exactly how I want it.

Install in `~/.config/dada`.

### Other commands

Start with:

* brew install node python3

Make sure to install:

* This repository (in `~/.config/dada`)
* [misc-bin](https://bitbucket.org/msikma/misc-bin)
* [misc-scripts](https://github.com/msikma/misc-scripts) (both of these in `~/.bin/`)
* `npm install --global trash-cli empty-trash-cli fileicon ascr cheerio request feedparser-promised dist-exiftool node-exiftool sanitize-filename`
* `pip3 install glances mdv`
* `brew install exa tldr git-extras youtube-dl bat fd ncdu coreutils flac`
* `brew install diff-so-fancy` ([configure](https://github.com/so-fancy/diff-so-fancy))
* VS Code: `code-insiders` command - ⇧⌘P and search for 'install'
* [vgmpfdl](https://github.com/msikma/vgmpfdl)

`ps2pdf` should be installed by default, but just in case it isn't it can be found [here](https://www.ghostscript.com/doc/current/Ps2pdf.htm).

Other utilities (unlisted):

* [MultiPatch](http://www.romhacking.net/utilities/746/)

For icons:

* `brew install git-lfs`
* `git lfs install`
* `git clone https://github.com/msikma/osx-folder-icons ~/Projects/osx-folders`
* `git clone git@bitbucket.org:msikma/dada-icons.git ~/Projects/dada-icons`

Add a file in `~/.config/fish` called `config.fish`:

```
echo "source ~/.config/dada/dada.fish" > ~/.config/fish/config.fish
```

### Copyright

MIT license
