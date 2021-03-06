# Dada Shell Theme © 2019, 2020

# Reloads the theme; useful when developing.
function dada-reload
  source "$DADA""dada.fish"
end

# Updates the shell theme.
function dada-update
  pushd "/$UDIR/"(whoami)"/.config/dada/"
  set old (get_version_short)
  set nvm (git pull)
  set new (get_version_short)
  if [ $old != $new ]
    echo "Updated Dada Shell Theme from "(set_color blue)$old(set_color normal)" to version "(set_color red)$new(set_color normal)"."
  else
    echo "You are already on the latest version of Dada Shell Theme, "(set_color red)$new(set_color normal)"."
  end
  popd
  dada-reload
end
