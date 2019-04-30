# Dada Shell Theme © 2019

set -g DADA "/Users/"(whoami)"/.config/dada/"
set -g home "/Users/"(whoami)

# Save short and full hostnames, e.g. "Vesuvius" and "Vesuvius.local".
set -gx dada_hostname (hostname -s)
set -gx dada_hostname_local (hostname)
set -gx dada_uhostname (whoami)"@$dada_hostname"
set -gx dada_uhostname_local (whoami)"@$dada_hostname_local"

source $DADA"aliases.fish"
source $DADA"commands.fish"
source $DADA"cron.fish"
source $DADA"env.fish"
source $DADA"prompt.fish"

source $DADA"lib/backup.fish"
source $DADA"lib/columns.fish"
source $DADA"lib/datetime.fish"
source $DADA"lib/fs.fish"
source $DADA"lib/git.fish"
source $DADA"lib/help.fish"
source $DADA"lib/request.fish"
source $DADA"lib/sys.fish"

source $DADA"functions/eatsql.fish"
source $DADA"functions/git.fish"
source $DADA"functions/help.fish"
source $DADA"functions/newx.fish"
source $DADA"functions/update.fish"

source $DADA"secrets/keys.fish"



