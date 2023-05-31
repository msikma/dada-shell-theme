#!/usr/bin/env fish

set USAGE 'usage: build-dosbox [--no-symlink] [--no-clean] [--no-pull]
                    [-h|--help] [--legacy-symlink]'

function get_branch
  cat .git/HEAD | sed -e 's/ref: \(.*\)$/\1/g' | sed -e 's/refs\/heads\/\(.*\)$/\1/g'
end

function get_version
  # "0.82.21"
  set xversion (cat vs/config_package.h | sed -e "/PACKAGE_VERSION/!d" -e "s/.*PACKAGE_VERSION \"\(.*\)\".*/\1/g")
  # "master"
  set branch (get_branch)
  # "16047"
  set commits (git rev-list head --count)

  # "0.82.21 master-16047"
  echo "$xversion $branch-$commits"
end

function rebuild --argument-names arg
  if begin [ "$arg" = "-h" ]; or [ "$arg" = "--help" ]; end
    echo $USAGE
    exit 0
  end
  if [ -n "$arg" ]
    if begin [ "$arg" != "--no-pull" ]; and [ "$arg" != "--no-symlink" ]; and [ "$arg" != "--legacy-symlink" ]; and [ "$arg" != "--no-clean" ]; end
      echo $USAGE
      exit 0
    end
  end
  if [ ! -d ~/Source/dosbox-x ]
    echo 'build-dosbox: error: could not find DOSBox-X source directory at ~/Source/dosbox-x'
    exit 1
  end
  mkdir -p ~/Source/dosbox-x-builds

  pushd ~/Source/dosbox-x
  if ! contains -- "--no-clean" $argv
    make clean
  end
  if ! contains -- "--no-pull" $argv
    git pull
  end
  rm -rf dosbox-x.app
  # note: temporarily disable avcodec: <https://github.com/joncampbell123/dosbox-x/issues/3283>
  ./build-macos --disable-avcodec
  make dosbox-x.app
  
  if [ "$status" -ne 0 ]
    echo 'build-dosbox: error: could not build DOSBox-X'
    exit 1
  end

  # Get name for the new build.
  set xversion (get_version)
  set name "DOSBox-X $xversion.app"
  set branch (get_branch)
  echo "$xversion" > ./dosbox-x.app/Contents/Resources/version.txt
  echo (date) > ./dosbox-x.app/Contents/Resources/built.txt
  rm -rf ~/Source/dosbox-x-builds/"$name"
  mv dosbox-x.app ~/Source/dosbox-x-builds/"$name"
  if contains -- "--legacy-symlink" $argv
    rm -rf ~/Source/dosbox-x-builds/"DOSBox-X Legacy.app"
    ln -s ~/Source/dosbox-x-builds/"$name" ~/Source/dosbox-x-builds/"DOSBox-X Legacy.app"
    echo (set_color yellow)"Built "(set_color cyan)"$name"(set_color yellow)" and symlinked it to "(set_color blue)"DOSBox-X Legacy.app"(set_color yellow)"."(set_color normal)
  else if begin; ! contains -- "--no-symlink" $argv; and [ "$branch" = "master" ]; end
    rm -rf ~/Source/dosbox-x-builds/"DOSBox-X Latest.app"
    ln -s ~/Source/dosbox-x-builds/"$name" ~/Source/dosbox-x-builds/"DOSBox-X Latest.app"
    echo (set_color yellow)"Built "(set_color cyan)"$name"(set_color yellow)" and symlinked it to "(set_color blue)"DOSBox-X Latest.app"(set_color yellow)"."(set_color normal)
  else
    echo (set_color yellow)"Built "(set_color cyan)"$name"(set_color yellow)"."(set_color normal)
  end
  popd
end

rebuild $argv
