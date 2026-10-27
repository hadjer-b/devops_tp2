set -Eeuo pipefail

DOSSIER_SOURCE="${1:-./data}"
DOSSIER_DEST="${2:-./backups}"

if [ ! -d "$DOSSIER_SOURCE" ]; then
    echo "Erreur: Le dossier source '$DOSSIER_SOURCE' n'existe pas." >&2
    exit 1
fi

mkdir -p "$DOSSIER_DEST"

DATE=$(date '+%Y-%m-%d_%H-%M-%S')
ARCHIVE="$DOSSIER_DEST/backup_$DATE.tar.gz"

echo "Devut de la sauvegarde de '$DOSSIER_SOURCE' vers '$ARCHIVE'..."

tar -czf "$ARCHIVE" "$DOSSIER_SOURCE"
echo "Sauvegarde done: $ARCHIVE"

echo "Nettoyage des archives datant de plus de 7 jours..."
find "$DOSSIER_DEST" -type f -name "backup_*.tar.gz" -mtime +7 -exec rm -f {} \;

echo "Opération terminée avec succès."
exit 0
