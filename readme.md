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
* `npm install --global trash-cli empty-trash-cli fileicon ascr`
* `pip3 install glances`
* `brew install exa tldr git-extras youtube-dl bat fd ncdu`
* `brew install diff-so-fancy` ([configure](https://github.com/so-fancy/diff-so-fancy))

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
