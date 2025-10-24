# Audeo-script - Cross-platform Video Downloader

```
   █████████                  █████
  ███░░░░░███                ░░███
 ░███    ░███  █████ ████  ███████   ██████   ██████
 ░███████████ ░░███ ░███  ███░░███  ███░░███ ███░░███
 ░███░░░░░███  ░███ ░███ ░███ ░███ ░███████ ░███ ░███
 ░███    ░███  ░███ ░███ ░███ ░███ ░███░░░  ░███ ░███
 █████   █████ ░░████████░░████████░░██████ ░░██████
░░░░░   ░░░░░   ░░░░░░░░  ░░░░░░░░  ░░░░░░   ░░░░░░
                                
```

## Description
Audeo is a cross-platform tool (Windows, Linux, macOS) that simplifies downloading video and audio content using yt-dlp. It provides a user-friendly command-line interface with preconfigured options for different use cases.

## Features
- 🎵 Download videos and music from various platforms
- 🎬 Support for complete playlists and albums
- 📝 Automatic metadata management
- 🖼️ Thumbnail integration
- 📥 Automatic dependency installation
- 🔄 Automatic yt-dlp updates

## Available Versions
- `audeo.bat` - Windows Version (PowerShell)
- `Audeo.sh` - Unix Version (Bash)

## Prerequisites
### Windows
- Windows 10/11
- PowerShell 5.1 or higher

### Linux/macOS
- Bash
- curl
- unzip (Linux only)

## Installation
1. Clone or download this repository
2. Navigate to the project folder

### Windows
```powershell
# Allow PowerShell script execution (if necessary)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# Run the script
.\audeo.bat
```

### Linux/macOS
```bash
# Grant execution permissions
chmod +x Audeo.sh
# Run the script
./Audeo.sh
```

## Usage
1. Run the script corresponding to your operating system
2. Paste the URL of the video/playlist to download
3. Choose one or more options by separating them with +
   - Example: `1+6+7` for high-quality video with thumbnail and metadata

### Available Options
1. Best video+audio quality (MP4)
2. Audio only (M4A)
3. Video only (best quality)
4. Audio only (best quality)
5. With subtitles
6. Add thumbnail
7. Add metadata
8. Complete album (playlist)
9. Movie
10. Change destination folder

### Usage Examples
- To download a YouTube video in MP4: Option `1`
- To extract audio from a video: Option `2`


## Default Destination Folders
- Windows: `%USERPROFILE%\Downloads\yt_cmd`
- Linux/macOS: `~/Downloads/Audeo`


## Configuration
Configuration files in the `conf/` folder allow you to customize download options for albums and movies.

### album.conf
- Optimized audio format (M4A)
- Thumbnail integration
- Automatic track numbering
- Metadata management

### movie.conf
- Optimized video format (MP4)
- Embedded subtitles
- Best video and audio quality
- Thumbnails and metadata

## Troubleshooting
### Windows
- If PowerShell blocks execution, use:
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

### Linux/macOS
- If you have permission errors:
  ```bash
  chmod +x Audeo.sh
  ```
- If you have encoding issues:
  ```bash
  export LANG=C.UTF-8
  export LC_ALL=C.UTF-8
  ```

## Notes
- The script automatically downloads yt-dlp and ffmpeg on first use
- Files are automatically organized in subfolders according to content type


## Author
Eclouf - Version 1.0 (October 2025)
