#!/usr/bin/env bash

# Load configurations
source configs.txt

# Constants
readonly GITHUB_API_BASE="https://api.github.com/repos/revanced"
readonly REPOS=(
    "revanced-cli/releases/latest"
    "gmscore/releases/latest"
    "revanced-patches/releases/latest"
)

# Logger function
log() {
    local level=$1
    local message=$2
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') ${level}: ${message}"
}

verify_apk() {
    local apk_file=$1
    
    if ! command -v apksigner &> /dev/null; then
        log "WARNING" "apksigner is not found. Skipping verification."
        return
    fi

    local output=$(apksigner verify "$apk_file" 2>&1)
    
    if [[ $output == *"Malformed APK"* ]]; then
        log "VERIFICATION" "[BAD] $apk_file is not passing the verification!"
        rm -f "$apk_file"
    else
        log "VERIFICATION" "[GOOD] $apk_file is passing the verification!"
    fi
}

# Print banner
print_banner() {
    cat << "EOF"

╦═╗╔═╗╦  ╦╔═╗╔╗╔╔═╗╔═╗╔╦╗ REVANCED ACTIONS BUILDER
╠╦╝║╣ ╚╗╔╝╠═╣║║║║  ║╣  ║║ BUILD REVANCED YOURSELF!
╩╚═╚═╝ ╚╝ ╩ ╩╝╚╝╚═╝╚═╝═╩╝ @elliottophellia   #VSPO
 
- ko-fi.com/elliottophellia
- saweria.co/elliottophellia
- trakteer.id/elliottophellia
- liberapay.com/elliottophellia

EOF
}

# Generic build function
build_app() {
    local pkg_name=$1
    local app_name=$2
    local version=$3

    log "BUILD" "[START] $(echo $app_name | tr '[:lower:]' '[:upper:]')"
    
    if [ -f "downloads/${pkg_name}.apk" ]; then
        java -jar revanced-cli.jar patch \
            -p revanced-patches.rvp \
            --keystore=keystore.keystore \
            --keystore-entry-alias=elliottophellia \
            --keystore-password=elliottophellia \
            --keystore-entry-password=elliottophellia \
            "downloads/${pkg_name}.apk" \
            -o "output/rei_$(echo ${app_name} | tr '[:upper:]' '[:lower:]')_v${version}.apk" > /dev/null 2>&1

        log "BUILD" "[GOOD] Successfully rebuild $(echo ${app_name} | tr '[:upper:]' '[:lower:]')"
    else
        log "BUILD" "[BAD] Cannot find $(echo ${app_name} | tr '[:upper:]' '[:lower:]') base package"
    fi
}

# Download function
download_file() {
    local url=$1
    local output=$2
    curl -s -L -H "authorization: Bearer $GHTOKEN" "$url" -o "$output"
    log "DOWNLOAD" "$(basename $url | tr '[:lower:]' '[:upper:]')"
}

# Initialize directories
init_directories() {
    mkdir -p output downloads
}

# Download utilities
download_utilities() {
    echo -e "\n╦ ╦╔╦╗╦╦  ╔═╗ Downloading Utilities"
    echo "║ ║ ║ ║║  ╚═╗ Used for Rebuilding"
    echo -e "╚═╝ ╩ ╩╩═╝╚═╝ ------------------->_\n"

    # Get download URLs
    local cli_url=$(curl -s -H "authorization: Bearer $GHTOKEN" "${GITHUB_API_BASE}/revanced-cli/releases/latest" | 
        jq -r '.assets[] | select(.name | test("revanced-cli-\\d+(\\.\\d+)*\\-all.jar$")) | .browser_download_url')
    local gms_url=$(curl -s -H "authorization: Bearer $GHTOKEN" "${GITHUB_API_BASE}/gmscore/releases/latest" | 
        jq -r '.assets[] | select(.name | test("app.revanced.android.gms-\\d+-signed.apk")) | .browser_download_url')
    local patches_url=$(curl -s -H "authorization: Bearer $GHTOKEN" "${GITHUB_API_BASE}/revanced-patches/releases/latest" | 
        jq -r '.assets[] | select(.name | test("\\d+(\\.\\d+)*\\.rvp$")) | .browser_download_url')

    # Download files
    download_file "$cli_url" "revanced-cli.jar"
    download_file "$gms_url" "output/rei_microg_latest.apk"
    download_file "$patches_url" "revanced-patches.rvp"
}

# Main execution
main() {
    print_banner
    init_directories
    download_utilities

    echo -e "\n╔═╗╔═╗╦╔═╔═╗ Downloading APKs"
    echo "╠═╣╠═╝╠╩╗╚═╗ from Internet"
    echo -e "╩ ╩╩  ╩ ╩╚═╝ ------------------->_\n"

    chmod +x ./download.sh
    ./download.sh

    echo -e "\n╔╦╗╔═╗╦╔═╔═╗ Rebuilding Base APKs"
    echo "║║║╠═╣╠╩╗║╣  With Revanced Patches"
    echo -e "╩ ╩╩ ╩╩ ╩╚═╝ ------------------->_\n"

    # Build apps based on configuration
    if [ "$BUILD_REVANCED" = "true" ]; then
        build_app "$PKGNAME_REVANCED" "$APPNAME_REVANCED" "$VERSION_REVANCED"
    else
        log "SKIP" "REVANCED"
    fi

    if [ "$BUILD_REVANCED_MUSIC" = "true" ]; then
        build_app "$PKGNAME_REVANCED_MUSIC" "$APPNAME_REVANCED_MUSIC" "$VERSION_REVANCED_MUSIC"
    else
        log "SKIP" "REVANCED_MUSIC"
    fi

    # Verify APKs
    for apk_file in output/*.apk; do
        verify_apk "$apk_file"
    done

    # Cleanup
    rm -rf downloads
    rm -rf temp_downloads
    echo -e "\nDone!\n"
}

# Execute main function
main
