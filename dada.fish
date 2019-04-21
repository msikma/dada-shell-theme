# Dada Shell Theme © 2019

set -g DADA "/Users/"(whoami)"/.config/dada/"
set -g home "/Users/"(whoami)

# Hostname used in several backup scripts, e.g. "Vesuvius".
set -gx dada_hostname (hostname -s)
# Username with device name, e.g "msikma@Vesuvius.local"
set -gx dada_device_name (whoami)"@"(uname -n)

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

source $DADA"functions/eatsql.fish"
source $DADA"functions/git.fish"
source $DADA"functions/newx.fish"
source $DADA"functions/update.fish"

source $DADA"secrets/keys.fish"



