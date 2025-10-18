#!/bin/bash

# Définir l'encodage UTF-8
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

YT_DLP_DIR="./yt-dlp"
YT_DLP_EXEC="$YT_DLP_DIR/yt-dlp"
FFMPEG_EXEC="$YT_DLP_DIR/ffmpeg"
DOWNLOADS_DIR="$HOME/Downloads"
AUDIO_DIR="$DOWNLOADS_DIR/Audeo"

# Vérifier et créer dossier yt-dlp
mkdir -p "$YT_DLP_DIR"
mkdir -p "$AUDIO_DIR"

# Fonction pour télécharger un fichier avec curl
download_file() {
    local url=$1
    local output=$2
    echo "Téléchargement de $output ..."
    if curl -L --fail --show-error "$url" -o "$output"; then
        echo "$output téléchargé avec succès."
    else
        echo "Échec du téléchargement de $output. Vérifiez votre connexion internet."
        exit 1
    fi
}

# Vérifier si yt-dlp est présent, sinon le télécharger
if ! [ -x "$YT_DLP_EXEC" ]; then
    echo "yt-dlp introuvable, téléchargement en cours..."
    # verifier le système d'exploitation
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        download_file "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux" "$YT_DLP_EXEC"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        download_file "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos" "$YT_DLP_EXEC"
    else
        echo "Système d'exploitation non pris en charge : $OSTYPE"
        exit 1
    fi
    chmod +x "$YT_DLP_EXEC"
fi

# Mettre à jour yt-dlp
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

while true; do
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
    echo "║      version 1.0 - 14 - 10 - 2025 - by Eclouf      ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo

    read -rp "Entrez l'URL de la vidéo à télécharger : " VIDEO_URL
    if [ -z "$VIDEO_URL" ]; then
        continue
    fi

    # Choix du dossier de destination, créer Audeo s'il n'existe pas
    DEST_FOLDER="$AUDIO_DIR"
    mkdir -p "$DEST_FOLDER"

    echo "______________________________________________________________________________________________________"
    echo "MENU :"
    echo
    echo "Choisissez une ou plusieurs options de téléchargement yt-dlp en séparant par + (exemple : 1+3+5) :"
    echo "1. Télécharger la meilleure qualité vidéo+audio"
    echo "2. Télécharger uniquement l'audio (m4a)"
    echo "3. Télécharger la meilleure vidéo seule"
    echo "4. Télécharger la meilleure audio seule"
    echo "5. Télécharger avec les sous-titres"
    echo "6. Ajouter la miniature de la vidéo"
    echo "7. Ajouter les metadonnées"
    echo "8. Télécharger un album complet (playlist)"
    echo "9. Télécharger un film"
    echo "10. Changer le dossier de destination (par défaut $DEST_FOLDER)"
    echo "0. Quitter"
    echo "________________________________________________________________________________________________________"
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
            0)
                echo "Quitter..."
                exit 0
                ;;
            *)
                echo "Choix invalide : $c"
                ;;
        esac
    done

    if [ "$VALID_CHOICE" -eq 0 ]; then
        echo "Aucun choix valide n'a été saisi. Veuillez réessayer."
        continue
    fi

    echo "Options sélectionnées : $OPTIONS"
    echo "Téléchargement en cours..."

    "$YT_DLP_EXEC" $OPTIONS -o "$DEST_FOLDER/%(title)s.%(ext)s" "$VIDEO_URL"

    echo "Appuyez sur [Entrée] pour continuer..."
    read -r
done
