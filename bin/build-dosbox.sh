#!/usr/bin/env fish

function get_version
  # "0.82.21"
  set xversion (cat vs/config_package.h | sed -e "/PACKAGE_VERSION/!d" -e "s/.*PACKAGE_VERSION \"\(.*\)\".*/\1/g")
  # "master"
  set branch (git describe --all | sed -e "s/heads\///g")
  # "16047"
  set commits (git rev-list head --count)

  # "0.82.21 master-16047"
  echo "$xversion $branch-$commits"
end

function rebuild --argument-names arg
  if begin [ "$arg" = "-h" ]; or [ "$arg" = "--help" ]; end
    echo 'usage: build-dosbox [--no-pull] [-h|--help]'
    exit 0
  end
  if begin [ "$arg" != "--no-pull" ]; and [ -n "$arg" ]; end
    echo 'usage: build-dosbox [--no-pull] [-h|--help]'
    exit 0
  end
  if [ ! -d ~/Source/dosbox-x ]
    echo 'build-dosbox: error: could not find DOSBox-X source directory at ~/Source/dosbox-x'
    exit 1
  end
  mkdir -p ~/Source/dosbox-x-builds

  pushd ~/Source/dosbox-x
  make clean
  if [ "$arg" != "--no-pull" ]
    git pull
  end
  rm -rf dosbox-x.app
  ./build-macosx-sdl2
  make dosbox-x.app
  
  if [ "$status" -ne 0 ]
    echo 'build-dosbox: error: could not build DOSBox-X'
    exit 1
  end

  # Get name for the new build.
  set xversion (get_version)
  set name "DOSBox-X $xversion.app"
  echo "$xversion" > ./dosbox-x.app/Contents/Resources/version.txt
  echo (date) > ./dosbox-x.app/Contents/Resources/built.txt
  rm -rf ~/Source/dosbox-x-builds/"$name"
  rm -rf ~/Source/dosbox-x-builds/"DOSBox-X Latest.app"
  mv dosbox-x.app ~/Source/dosbox-x-builds/"$name"
  ln -s ~/Source/dosbox-x-builds/"$name" ~/Source/dosbox-x-builds/"DOSBox-X Latest.app"

  echo (set_color yellow)"Built "(set_color cyan)"$name"(set_color yellow)" and symlinked it to "(set_color blue)"DOSBox-X Latest.app"(set_color yellow)"."(set_color normal)
  popd
end

rebuild $argv
