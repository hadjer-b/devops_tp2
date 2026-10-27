
SEUIL="${1:-80}"

UTILISATION=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
echo "Pourcentage d'utilisation du disque : ${UTILISATION}% (Seuil : ${SEUIL}%)"

if [ "$UTILISATION" -ge "$SEUIL" ]; then
    echo "ALERT: espace disque utilise sur '/' a depasse le seuil (${UTILISATION}% >= ${SEUIL}%) !"
    exit 1
else
    echo "OK: l'utilisation du disque est sous le seuil."
    exit 0
fi
