# Site vitrine Memoa — refonte
Dossier statique autonome : index.html + img/. Aucune dépendance de build. Polices Inter/Sora via Google Fonts (comme avant).
Déploiement : déposer le contenu du dossier à la racine de memoaacademia.com (ou GitHub Pages / Netlify / Vercel statique).
Liens app : variable APP_URL en bas de index.html (https://app.memoaacademia.com/, inchangée). Routes conservées : #/connexion, #/creer-un-compte, #/premium, #/installer, #/aide, #/legal/*.

## Mise à jour : objectif « installer l'app »
- Nouvelle accroche : « Arrive à l'examen l'esprit tranquille. »
- Bouton « Installer l'app » placé en grand dans le hero, dans l'en-tête, dans les tarifs et en bas de page (tous utilisent data-install).
- Barre d'installation fixe sur mobile (#dock), visible après le hero, masquée près du bloc final et dans l'app installée.
- FAQ « Comment installer Memoa ? » passée en premier et ouverte, avec la mention « pas encore sur le Play Store ».
