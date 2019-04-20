# Dada Shell Theme © 2019

set -g DADA "/Users/"(whoami)"/.config/dada/"
set -g home "/Users/"(whoami)

# Hostname, used in several backup scripts. E.g. 'Vesuvius'; without .local suffix.
set -gx dada_hostname (hostname -s)

# In case we want to make a network request.
set -gx dada_ua "Dada Shell Theme/unknown" # modified after we get our version info
# Accept language string for getting localized content.
set -gx dada_acceptlang "ja,en-US;q=0.7,en;q=0.3"

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



