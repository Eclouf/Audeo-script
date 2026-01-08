#!/bin/bash

# Définir l'encodage UTF-8
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# Couleurs pour le texte
# Définir les couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Afficher la bannière
echo
echo "   █████████                  █████                  "
echo "  ███░░░░░███                ░░███                   "
echo " ░███    ░███  █████ ████  ███████   ██████   ██████ "
echo " ░███████████ ░░███ ░███  ███░░███  ███░░███ ███░░███"
echo " ░███░░░░░███  ░███ ░███ ░███ ░███ ░███████ ░███ ░███"
echo " ░███    ░███  ░███ ░███ ░███ ░███ ░███░░░  ░███ ░███"
echo " █████   █████ ░░████████░░████████░░██████ ░░██████ "
echo "░░░░░   ░░░░░   ░░░░░░░░  ░░░░░░░░  ░░░░░░   ░░░░░░  "
echo "╔════════════════════════════════════════════════════╗"
echo "║              Téléchargeur de vidéos                ║"
echo "║           Utilise yt-dlp en ligne de commande      ║"
echo "║----------------------------------------------------║"
echo "║      version 1.1 - 08 - 01 - 2026 - by Eclouf      ║"
echo -e "║       ${BLUE}https://github.com/Eclouf/Audeo-script${NC}       ║"
echo "╚════════════════════════════════════════════════════╝"
echo
YT_DLP_DIR="./yt-dlp"
YT_DLP_EXEC="$YT_DLP_DIR/yt-dlp"
FFMPEG_EXEC="$YT_DLP_DIR/ffmpeg"
DOWNLOADS_DIR="$HOME/Downloads"
AUDIO_DIR="$DOWNLOADS_DIR/Audeo"



# Vérifier et créer dossier yt-dlp
mkdir -p "$YT_DLP_DIR"
mkdir -p "$AUDIO_DIR"

# Vérifier si curl est présent
if ! command -v curl &> /dev/null; then
    echo -e "${RED}curl introuvable, installation en cours...${NC}"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y curl
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y curl
        else
            echo -e "${RED}Impossible d'installer curl. Veuillez l'installer manuellement.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}curl n'a pas pu être trouvé. Veuillez l'installer manuellement.${NC}"
        exit 1
    fi
fi

# Fonction pour télécharger un fichier avec curl
download_file() {
    local url=$1
    local output=$2
    echo -e "${CYAN}Téléchargement de $output ...${NC}"
    if curl -L --fail --show-error "$url" -o "$output"; then
        echo -e "${GREEN}$output téléchargé avec succès.${NC}"
    else
        echo -e "${RED}Échec du téléchargement de $output. Vérifiez votre connexion internet.${NC}"
        exit 1
    fi
}

# Fonction pour valider une URL
validate_url() {
    local url=$1
    if [[ $url =~ ^https?:// ]]; then
        return 0
    else
        return 1
    fi
}

# Vérifier si yt-dlp est présent, sinon le télécharger
if ! [ -x "$YT_DLP_EXEC" ]; then
    echo -e "${YELLOW}yt-dlp introuvable, téléchargement en cours...${NC}"
    # verifier le système d'exploitation
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        download_file "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux" "$YT_DLP_EXEC"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        download_file "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos" "$YT_DLP_EXEC"
    else
        echo -e "${RED}Système d'exploitation non pris en charge : $OSTYPE${NC}"
        exit 1
    fi
    chmod +x "$YT_DLP_EXEC"
fi

# Mettre à jour yt-dlp
echo -e "${CYAN}Mise à jour de yt-dlp...${NC}"
"$YT_DLP_EXEC" -U

    # Vérifier et installer les dépendances nécessaires
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if ! command -v unzip &> /dev/null; then
            echo -e "${YELLOW}Installation de unzip...${NC}"
            if command -v apt-get &> /dev/null; then
                sudo apt-get update && sudo apt-get install -y unzip
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y unzip
            else
                echo -e "${RED}Impossible d'installer unzip. Veuillez l'installer manuellement.${NC}"
                return 1
            fi
        fi

        # Vérifier et télécharger ffmpeg si nécessaire
        if [ ! -f "yt-dlp/ffmpeg" ]; then
            echo -e "${YELLOW}ffmpeg introuvable, téléchargement en cours...${NC}"
            
            # Essayer d'abord d'installer via le gestionnaire de paquets
            if command -v apt-get &> /dev/null; then
                sudo apt-get update && sudo apt-get install -y ffmpeg
                if [ $? -eq 0 ]; then
                    ln -s $(which ffmpeg) "yt-dlp/ffmpeg"
                    echo -e "${GREEN}ffmpeg installé avec succès.${NC}"
                    return 0
                fi
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y ffmpeg
                if [ $? -eq 0 ]; then
                    ln -s $(which ffmpeg) "yt-dlp/ffmpeg"
                    echo -e "${GREEN}ffmpeg installé avec succès.${NC}"
                    return 0
                fi
            fi

            # Si l'installation via le gestionnaire de paquets échoue, télécharger manuellement
            echo -e "${YELLOW}Téléchargement manuel de ffmpeg...${NC}"
            TEMP_DIR=$(mktemp -d)
            
            # Télécharger la version statique de ffmpeg pour Linux
            curl -L "https://github.com/eugeneware/ffmpeg-static/releases/latest/download/linux-x64" -o "$TEMP_DIR/ffmpeg"
            
            if [ $? -eq 0 ]; then
                chmod +x "$TEMP_DIR/ffmpeg"
                mv "$TEMP_DIR/ffmpeg" "yt-dlp/ffmpeg"
                rm -rf "$TEMP_DIR"
                echo -e "${GREEN}ffmpeg téléchargé et installé avec succès.${NC}"
            else
                rm -rf "$TEMP_DIR"
                echo -e "${RED}Échec du téléchargement de ffmpeg.${NC}"
                return 1
            fi
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then

        # Vérifier et télécharger ffmpeg si nécessaire
        if [ ! -f "yt-dlp/ffmpeg" ]; then
            echo -e "${YELLOW}ffmpeg introuvable, téléchargement en cours...${NC}"
            download_file "https://evermeet.cx/ffmpeg/getrelease/zip" "$YT_DLP_DIR/ffmpeg.zip"
            echo "Extraction de ffmpeg..."
            unzip -o "$YT_DLP_DIR/ffmpeg.zip" -d "$YT_DLP_DIR"
            rm "$YT_DLP_DIR/ffmpeg.zip"
            chmod +x "$FFMPEG_EXEC"
        fi
    fi

while true; do

    read -rp "Entrez l'URL de la vidéo à télécharger : " VIDEO_URL
    if [ -z "$VIDEO_URL" ]; then
        continue
    fi

    # Valider l'URL
    if ! validate_url "$VIDEO_URL"; then
        echo -e "${RED}URL invalide. Veuillez entrer une URL commençant par http:// ou https://${NC}"
        continue
    fi

    # Choix du dossier de destination, créer Audeo s'il n'existe pas
    DEST_FOLDER="$AUDIO_DIR"
    mkdir -p "$DEST_FOLDER"

    echo -e "╔═══════════════════════════════════════════════════════════════════════════════════╗"
    echo -e "║ ${YELLOW}MENU:${NC}                                                  choix des options: ${GREEN}ex: 1+5${NC} ║"
    echo -e "╠═══════════════════════════════════════════════════════════════════════════════════╣"
    echo -e "║ ${CYAN}1.${NC} Télécharger la meilleure qualité vidéo+audio                                   ║"
    echo -e "║ ${CYAN}2.${NC} Télécharger uniquement l'audio (m4a)                                           ║"
    echo -e "║ ${CYAN}3.${NC} Télécharger la meilleure vidéo seule                                           ║"
    echo -e "║ ${CYAN}4.${NC} Télécharger le meilleur audio seule                                            ║"
    echo -e "║ ${CYAN}5.${NC} Télécharger avec les sous-titres                                               ║"
    echo -e "║ ${CYAN}6.${NC} Ajouter la miniature de la vidéo                                               ║"
    echo -e "║ ${CYAN}7.${NC} Ajouter les metadonnées                                                        ║"
    echo -e "║ ${CYAN}8.${NC} Télécharger un album complet (playlist)                                        ║"
    echo -e "║ ${CYAN}9.${NC} Télécharger un film                                                            ║"
    echo -e "║ ${CYAN}10.${NC} Changer le dossier de destination (par défaut ~\Downloads\Audeo)              ║"
    echo -e "║ ${CYAN}11.${NC} Télécharger un élément d'une playlist                                         ║"
    echo -e "║                                                                                   ║"
    echo -e "║ ${CYAN}0.${NC} Mode debug (affiche les logs détaillés)                                        ║"
    echo -e "║ ${RED}q.${NC} Quitter                                                                        ║"   
    echo -e "╚═══════════════════════════════════════════════════════════════════════════════════╝"
    read -rp "Entrez vos choix : " CHOIX

    OPTIONS=""
    VALID_CHOICE=0

    # Séparer les options par +
    IFS='+' read -ra CHOIX_ARR <<< "$CHOIX"
    for c in "${CHOIX_ARR[@]}"; do
        case "$c" in
            1)
                OPTIONS="$OPTIONS -f bestvideo+bestaudio --merge-output-format mp4"
                VALID_CHOICE=1
                ;;
            2)
                OPTIONS="$OPTIONS -f bestaudio --audio-format m4a"
                VALID_CHOICE=1
                ;;
            3)
                OPTIONS="$OPTIONS -f bestvideo"
                VALID_CHOICE=1
                ;;
            4)
                OPTIONS="$OPTIONS -f bestaudio"
                VALID_CHOICE=1
                ;;
            5)
                OPTIONS="$OPTIONS --write-subs --sub-lang all --embed-subs"
                VALID_CHOICE=1
                ;;
            6)
                OPTIONS="$OPTIONS --embed-thumbnail"
                VALID_CHOICE=1
                ;;
            7)
                OPTIONS="$OPTIONS --embed-metadata"
                VALID_CHOICE=1
                ;;
            8)
                OPTIONS="$OPTIONS --config-location ./conf/album.conf"
                DEST_FOLDER="$DEST_FOLDER/%(album)s_%(playlist_title)s"
                VALID_CHOICE=1
                ;;
            9)
                OPTIONS="$OPTIONS --config-location ./conf/movie.conf"
                DEST_FOLDER="$DEST_FOLDER/%(title)s"
                VALID_CHOICE=1
                ;;
            10)
                read -rp "Entrez le chemin du dossier de sortie (laisser vide pour $DOWNLOADS_DIR) : " inputfolder
                if [ -n "$inputfolder" ]; then
                    DEST_FOLDER="$inputfolder/Audeo"
                else
                    DEST_FOLDER="$AUDIO_DIR"
                fi
                mkdir -p "$DEST_FOLDER"
                ;;
            q|Q)
                echo "Quitter..."
                exit 0
                ;;
            *)
                echo -e "${RED}Choix invalide : $c${NC}"
                ;;
        esac
    done

    if [ "$VALID_CHOICE" -eq 0 ]; then
        echo -e "${RED}ERROR${NC} Aucun choix valide n'a été saisi. Veuillez réessayer."
        continue
    fi

    echo -e "${BLUE}INFO${NC} Options sélectionnées : ${CYAN}$OPTIONS${NC}"
    echo -e "${BLUE}INFO${NC} Téléchargement en cours..."

    "$YT_DLP_EXEC" $OPTIONS -o "$DEST_FOLDER/%(title)s.%(ext)s" "$VIDEO_URL"

    echo -e "Appuyez sur ${GREEN}[Entrée] ${BLUE}pour continuer${NC} ou ${GREEN}[q|Q] ${BLUE}pour quitter${NC}."
    read -r CHOICE
    if [[ "$CHOICE" == "q" || "$CHOICE" == "Q" ]]; then
        echo -e "${GREEN}Fin du script !${NC}"
        exit 0
    fi
done
