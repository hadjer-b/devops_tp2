set -Eeuo pipefail

LOG="ci.log"

journal() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG"
}

if [ -z "${1:-}" ]; then
    echo "Erreur : URL du deport manquante."
    exit 1
fi

DEPOT=$1
DOSSIER=$(basename "$DEPOT" .git)

journal "start pipeline CI"

if [ -d "$DOSSIER" ]; then
    journal "Update deport.."
    cd "$DOSSIER"
    git pull | tee -a "../$LOG"
    cd ..
else
    journal "Clone deport..."
    git clone "$DEPOT" | tee -a "$LOG"
fi

run_tests() {
    local erreur=0
    
    journal "Execute tests (checking for required files)"
    
    for fichier in "check_disk.sh" "backup.sh" "ci.sh" "backup.log"; do
        if [ -f "$DOSSIER/$fichier" ]; then
            journal " - OK : $fichier est présent."
        else
            journal " - ECHEC : $fichier est manquant !"
            erreur=1
        fi
    done
    
    return $erreur
}

if run_tests; then
    journal "Success: les tests sont reussi."
    exit 0
else
    journal "FAILURE : les tests non pas reussie"
    exit 1
fi
