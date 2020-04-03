# Dada Shell Theme © 2019

if [ -d "/Users" ]; set -gx UDIR 'Users'; else; set -gx UDIR 'home'; end;

set -g DADA "/$UDIR/"(whoami)"/.config/dada/"
set -g home "/$UDIR/"(whoami)

# Save short and full hostnames, e.g. "Vesuvius" and "Vesuvius.local".
set -gx dada_hostname (hostname -s)
set -gx dada_hostname_local (hostname)
set -gx dada_uhostname (whoami)"@$dada_hostname"
set -gx dada_uhostname_local (whoami)"@$dada_hostname_local"

source $DADA"alerts.fish"
source $DADA"aliases.fish"
source $DADA"commands.fish"
source $DADA"cron.fish"
source $DADA"env.fish"
source $DADA"prompt.fish"
source $DADA"tasks.fish"

source $DADA"lib/alerts.fish"
source $DADA"lib/backup.fish"
source $DADA"lib/columns.fish"
source $DADA"lib/cron.fish"
source $DADA"lib/datetime.fish"
source $DADA"lib/fs.fish"
source $DADA"lib/git.fish"
source $DADA"lib/help.fish"
source $DADA"lib/images.fish"
source $DADA"lib/request.fish"
source $DADA"lib/sys.fish"
source $DADA"lib/test.fish"
source $DADA"lib/utils.fish"

source $DADA"functions/dada.fish"
source $DADA"functions/eatsql.fish"
source $DADA"functions/git.fish"
source $DADA"functions/help.fish"
source $DADA"functions/images.fish"
source $DADA"functions/newx.fish"
source $DADA"functions/videos.fish"
source $DADA"functions/zipdir.fish"

source $DADA"test/datetime.fish"

source $DADA"secrets/keys.fish"

source $DADA"init.fish"
