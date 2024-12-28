#!/usr/bin/env bash

# Load configurations
source configs.txt

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly APP_FOLDER="${SCRIPT_DIR}/downloads"
readonly TEMP_DIR="${SCRIPT_DIR}/temp_downloads"
readonly REVANCED_API="https://api.revanced.app/v2/patches/latest"
readonly USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) FlashBrowser/1.0.0 Chrome/83.0.4103.122 Electron/9.4.4 Safari/537.36"

# Logger function
log() {
    local level=$1
    local message=$2
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') ${level}: ${message}"
}

# Make HTTP requests with consistent headers
make_request() {
    local output_file=$1
    local url=$2
    
    curl -H "User-Agent: ${USER_AGENT}" \
         -H "Accept: */*" \
         -H "Accept-Encoding: gzip, deflate" \
         -H "Accept-Language: en-US;q=0.5" \
         -H "Referer: https://apkpure.com/" \
         --compressed \
         -s \
         -L \
         -o "$output_file" "$url"
}

# Get supported version from ReVanced API
get_supported_version() {
    local pkg_name=$1
    jq -r --arg pkg_name "$pkg_name" '.. | objects | select(.name == "\($pkg_name)" and .versions != null) | .versions[-1]' | uniq
}

# Download APK from APKPure
download_from_apkpure() {
    local package=$1
    local version=$2
    local log_file="/tmp/download_log.txt"

    # Get version if not provided
    if [ -z "$version" ]; then
        version=$(make_request - "$REVANCED_API" | get_supported_version "$package")
        
        if [ -z "$version" ]; then
            version=$(make_request - "https://apkpure.com/search?q=$package" | 
                     pup 'div[data-dt-app='"$package"'] attr{data-dt-version}')
        fi
    fi

    # Get version code
    local search_url="https://apkpure.com/search?q=$package"
    local code_path=$(make_request - "$search_url" | 
                     pup 'div[data-dt-app='"$package"']' | 
                     pup 'a.first-info attr{href}')"/versions"
    
    local version_code=$(make_request - "$code_path" | 
                        pup 'a[data-dt-version='"$version"'] attr{data-dt-versioncode}')
    
    # Download APK
    local download_url="https://d.apkpure.com/b/APK/$package?versionCode=$version_code"
    make_request "${package}.apk" "$download_url" 2>&1 | tee "$log_file"

    # Verify download
    if [ ! -s "${package}.apk" ]; then
        log "ERROR" "Failed to download ${package}.apk"
        return 1
    fi
}

# Process download and move APK
process_download() {
    local source=$1
    local app_name=$2
    local pkg_name=$3
    local version=$4

    log "INFO" "Starting download for $pkg_name version $version from $source"

    # Create a temporary directory for downloads
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR" || exit 1

    case "$source" in
        "apkpure")
            if ! download_from_apkpure "$pkg_name" "$version"; then
                log "ERROR" "Failed to download $pkg_name"
                cd "$SCRIPT_DIR" || exit 1
                return 1
            fi
            ;;
        *)
            log "ERROR" "Unknown source $source"
            cd "$SCRIPT_DIR" || exit 1
            return 1
            ;;
    esac

    # Ensure download directory exists
    mkdir -p "${APP_FOLDER}"

    if [ -s "${pkg_name}.apk" ]; then
        mv "${pkg_name}.apk" "${APP_FOLDER}/${pkg_name}.apk"
        log "SUCCESS" "Downloaded $pkg_name $version from $source"
        cd "$SCRIPT_DIR" || exit 1
        return 0
    else
        log "ERROR" "APK file is empty or download failed for $pkg_name $version from $source"
        [ -f /tmp/download_log.txt ] && cat /tmp/download_log.txt >&2
        cd "$SCRIPT_DIR" || exit 1
        return 1
    fi
}

# Verify APK signature
verify_apk() {
    local apk_file=$1
    
    if [ ! -f "$apk_file" ]; then
        log "ERROR" "APK file not found: $apk_file"
        return 1
    fi

    if ! command -v apksigner &> /dev/null; then
        log "WARNING" "apksigner is not found. Skipping verification."
        return 0
    fi

    log "INFO" "Verifying APK: $apk_file"
    local output=$(apksigner verify "$apk_file" 2>&1)
    
    if [[ $output == *"Malformed APK"* ]]; then
        log "VERIFICATION" "[BAD] $apk_file is not passing the verification!"
        rm -f "$apk_file"
        return 1
    else
        log "VERIFICATION" "[GOOD] $apk_file is passing the verification!"
        return 0
    fi
}

# Main execution
main() {
    # Create download directory if it doesn't exist
    mkdir -p "$APP_FOLDER"

    # Trim any whitespace from config values
    BUILD_REVANCED=$(echo "$BUILD_REVANCED" | tr -d '[:space:]')
    BUILD_REVANCED_MUSIC=$(echo "$BUILD_REVANCED_MUSIC" | tr -d '[:space:]')

    # Define apps to process
    declare -A apps=(
        [REVANCED]="apkpure $BUILD_REVANCED $APPNAME_REVANCED $PKGNAME_REVANCED $VERSION_REVANCED"
        [REVANCED_MUSIC]="apkpure $BUILD_REVANCED_MUSIC $APPNAME_REVANCED_MUSIC $PKGNAME_REVANCED_MUSIC $VERSION_REVANCED_MUSIC"
    )

    local download_success=0
    local download_failed=0

    # Process each app
    for app in "${!apps[@]}"; do
        IFS=' ' read -r source buildFlag appName pkgName version <<< "${apps[$app]}"
        if [ "$buildFlag" = "true" ]; then
            log "INFO" "Processing $pkgName version $version"
            if process_download "$source" "$appName" "$pkgName" "$version"; then
                ((download_success++))
            else
                ((download_failed++))
                log "ERROR" "Failed to process $pkgName"
            fi
            sleep 20s
        else
            log "SKIP" "Skipping $pkgName (build flag: $buildFlag)"
        fi
    done

    # Verify downloaded APKs
    log "INFO" "Verifying downloaded APKs..."
    for apk_file in "${APP_FOLDER}"/*.apk; do
        if [ -f "$apk_file" ]; then
            verify_apk "$apk_file"
        fi
    done

    # Summary
    log "SUMMARY" "Successfully downloaded: $download_success, Failed: $download_failed"
}

# Execute main function
main
