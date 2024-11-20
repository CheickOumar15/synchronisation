#!/bin/bash

# Afficher l'aide
if [[ $1 == "-h" || $# < 3 ]]; then
    echo "Usage: $0 <serveur> <dossier_distant> <dossier_local> [--upload | --auto]"
    echo "Options:"
    echo "  --upload   Déploie des fichiers du local vers le serveur sans suppression"
    echo "  --auto     Active la synchronisation automatique toutes les 10 secondes"
    exit 1
fi

# Variables
REMOTE=$1
REMOTE_DIR=$2
LOCAL_DIR=$3
OPTION=$4

# Synchronisation simple
sync_files() {
    rsync -avz "$REMOTE:$REMOTE_DIR" "$LOCAL_DIR"
}

# Déploiement local -> serveur
upload_files() {
    rsync -avz --ignore-existing "$LOCAL_DIR/" "$REMOTE:$REMOTE_DIR"
}

# Synchronisation automatique
auto_sync() {
    while true; do
        rsync -avz "$REMOTE:$REMOTE_DIR" "$LOCAL_DIR"
        sleep 10
    done
}

# Exécution en fonction de l'option
case $OPTION in
    --upload) upload_files ;;
    --auto) auto_sync ;;
    *) sync_files ;;
esac

