@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM Verifier si yt-dlp est à jour
yt-dlp\yt-dlp.exe -U

echo.
echo    █████████                  █████                  
echo   ███░░░░░███                ░░███                   
echo  ░███    ░███  █████ ████  ███████   ██████   ██████ 
echo  ░███████████ ░░███ ░███  ███░░███  ███░░███ ███░░███
echo  ░███░░░░░███  ░███ ░███ ░███ ░███ ░███████ ░███ ░███
echo  ░███    ░███  ░███ ░███ ░███ ░███ ░███░░░  ░███ ░███
echo  █████   █████ ░░████████░░████████░░██████ ░░██████ 
echo ░░░░░   ░░░░░   ░░░░░░░░  ░░░░░░░░  ░░░░░░   ░░░░░░                   
echo ╔════════════════════════════════════════════════════╗
echo ║                Téléchargeur de vidéos              ║
echo ║         Utilise yt-dlp en ligne de commande        ║
echo ║----------------------------------------------------║
echo ║      version 1.0 - 14 - 10 - 2025 - by Eclouf      ║
echo ╚════════════════════════════════════════════════════╝
echo.
REM Vérifie si yt-dlp.exe est présent, sinon le télécharge
if not exist ".\yt-dlp\yt-dlp.exe" (
    if not exist ".\yt-dlp" (
        mkdir ".\yt-dlp"
    )
    echo yt-dlp.exe introuvable, téléchargement en cours...
    powershell -Command "Invoke-WebRequest -Uri https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe -OutFile 'yt-dlp\yt-dlp.exe'"
    if exist "yt-dlp\yt-dlp.exe" (
        echo yt-dlp.exe téléchargé avec succès.
    ) else (
        echo Echec du téléchargement de yt-dlp.exe. Vérifiez votre connexion internet.
        pause
        exit /b 1
    )
)

if not exist ".\yt-dlp\ffmpeg.exe" (
    echo ffmpeg.exe introuvable, téléchargement en cours...
    powershell -Command "Invoke-WebRequest -Uri https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip -OutFile 'yt-dlp\ffmpeg.zip'"
    if exist "yt-dlp\ffmpeg.zip" (
        echo Extraction de ffmpeg.exe...
        powershell -Command "Expand-Archive -Path 'yt-dlp\ffmpeg.zip' -DestinationPath 'yt-dlp' -Force"
        del "yt-dlp\ffmpeg.zip"
        for /r "yt-dlp" %%i in (ffmpeg.exe) do move "%%i" "yt-dlp\ffmpeg.exe"
        echo ffmpeg.exe téléchargé et extrait avec succès.
    ) else (
        echo Echec du téléchargement de ffmpeg.exe. Vérifiez votre connexion internet.
        pause
        exit /b 1
    )
)

set "FFMPEG_PATH=.\yt-dlp\ffmpeg.exe"

:MENU
REM Demande à l'utilisateur l'URL de la vidéo
set /p "VIDEO_URL=Entrez l'URL de la vidéo à télécharger : "
if "!VIDEO_URL!"=="" goto MENU

REM Définit le dossier de destination par défaut
set DEST_FOLDER=%USERPROFILE%\Downloads
REM Vérifier si le dossier Audeo existe, sinon le créer
if not exist "!DEST_FOLDER!\Audeo" (
    mkdir "!DEST_FOLDER!\Audeo"
    set DEST_FOLDER=%DEST_FOLDER%\Audeo
) else set DEST_FOLDER=%DEST_FOLDER%\Audeo

REM Affiche le menu
echo ______________________________________________________________________________________________________
echo MENU :
echo .
echo Choisissez une ou plusieurs options de téléchargement yt-dlp en séparant par + (exemple : 1+3+5) :
echo 1. Télécharger la meilleure qualité vidéo+audio
echo 2. Télécharger uniquement l'audio (m4a)
echo 3. Télécharger la meilleure vidéo seule
echo 4. Télécharger la meilleure audio seule
echo 5. Télécharger avec les sous-titres
echo 6. Ajouter la miniature de la vidéo
echo 7. Ajouter les metadonnées
echo 8. Télécharger un album complet (playlist)
echo 9. Télécharger un film
echo 10. Changer le dossier de destination (par défaut %USERPROFILE%\Downloads\Audeo)
echo 0. Quitter
echo ________________________________________________________________________________________________________
set /p "CHOIX=Entrez vos choix : "
set CHOIX=!CHOIX: =!

REM Initialise options à vide
set OPTIONS=
set VALID_CHOICE=0

REM Remplace les "+" par des espaces pour la boucle for
set "CHOIX_TMP=!CHOIX:+= !"
for %%a in (!CHOIX_TMP!) do (
    if "%%a"=="1" (
        set "OPTIONS=!OPTIONS! -f bestvideo+bestaudio --merge-output-format mp4"
        set VALID_CHOICE=1
    )
    if "%%a"=="2" (
        set "OPTIONS=!OPTIONS! -f bestaudio --audio-format m4a"
        set VALID_CHOICE=1
    )
    if "%%a"=="3" (
        set "OPTIONS=!OPTIONS! -f bestvideo"
        set VALID_CHOICE=1
    )
    if "%%a"=="4" (
        set "OPTIONS=!OPTIONS! -f bestaudio"
        set VALID_CHOICE=1
    )
    if "%%a"=="5" (
        set "OPTIONS=!OPTIONS! --write-subs --sub-lang all --embed-subs"
        set VALID_CHOICE=1
    )
    if "%%a"=="6" (
        set "OPTIONS=!OPTIONS! --embed-thumbnail"
        set VALID_CHOICE=1
    )
    if "%%a"=="7" (
        set "OPTIONS=!OPTIONS! --embed-metadata"
        set VALID_CHOICE=1
    )
    if "%%a"=="8" (
        set "OPTIONS=!OPTIONS! --config-location .\conf\album.conf"
        set DEST_FOLDER=%DEST_FOLDER%"\%%(album,playlist_title)s"
        set VALID_CHOICE=1
    )
    if "%%a"=="9" (
        set "OPTIONS=!OPTIONS! --config-location .\conf\movie.conf"
        set DEST_FOLDER=%DEST_FOLDER%"\%%(title)s"
        set VALID_CHOICE=1
    )
    if "%%a"=="10" (
        set /p "DEST_FOLDER=Entrez le chemin du dossier de sortie (laisser vide pour %USERPROFILE%\Downloads) : "
        if "!DEST_FOLDER!"=="" set DEST_FOLDER=%USERPROFILE%\Downloads
        REM Vérifier si le dossier Audeo existe, sinon le créer
        if not exist "!DEST_FOLDER!\Audeo" (
            mkdir "!DEST_FOLDER!\Audeo"
            set DEST_FOLDER=%DEST_FOLDER%\Audeo
        ) else set DEST_FOLDER=%DEST_FOLDER%\Audeo
    )
    if "%%a"=="0" (
        echo Quitter...
        exit /b 0
    )
)

REM Vérifie si options sont présentes
if !VALID_CHOICE! equ 0 (
    echo Aucun choix valide n'a été saisi. Veuillez réessayer.
    goto MENU
)

REM Affiche résumé des options choisies
echo Options sélectionnées : !OPTIONS!

REM Exécute yt-dlp avec les paramètres fournis
echo Téléchargement en cours...
.\yt-dlp\yt-dlp.exe !OPTIONS! -o "!DEST_FOLDER!\%%(title)s.%%(ext)s" !VIDEO_URL!

pause
goto MENU
