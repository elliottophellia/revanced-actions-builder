#!/usr/bin/env bash

# Configs
source configs.txt

# Download Folder
appFolder="downloads"

# Revanced API
revancedApi="https://api.revanced.app/v2/patches/latest"

getRequestUpToDown() {
    curl -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" \
         -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8" \
         -H "Sec-Fetch-Dest: document" \
         -H "Sec-Fetch-Mode: navigate" \
         -H "Sec-Fetch-Site: none" \
         -H "Sec-Fetch-User: ?1" \
         -H "Sec-GPC: 1" \
         -H "Upgrade-Insecure-Requests: 1" \
         -H 'sec-ch-ua: "Brave";v="123", "Not:A-Brand";v="8", "Chromium";v="123"' \
         -H "sec-ch-ua-mobile: ?0" \
         -H 'sec-ch-ua-platform: "Windows"' \
         -s \
         -L \
         -o "$1" "$2"
}

getRequestAPKPure() {
    curl -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) FlashBrowser/1.0.0 Chrome/83.0.4103.122 Electron/9.4.4 Safari/537.36" \
         -H "Accept: */*" \
         -H "Accept-Encoding: gzip, deflate" \
         -H "Accept-Language: en-US;q=0.5" \
         -H "Referer: https://apkpure.com/" \
         --compressed \
         -s \
         -L \
         -o "$1" "$2"
}

getSupportedVersion() {
    jq -r --arg pkg_name "$1" '.. | objects | select(.name == "\($pkg_name)" and .versions != null) | .versions[-1]' | uniq
}

getDownloadURLUpToDown() {
    local name="$1" 
    local package="$2"
    local version="$3"
    local url="https://$name.en.uptodown.com/android"
    local id="$(getRequestUpToDown - "$url" | pup 'h1[id=detail-app-name] attr{code}')"

    if [ -z "$version" ]; then
        version=$(getRequestUpToDown - "$revancedApi" | getSupportedVersion "$package")
    fi

    if [ -z "$version" ]; then
        echo "Error: Unable to determine version for $package" >&2
        return 1
    fi

    local page=1
    local max_pages=10
    local version_url=""

    while [ -z "$version_url" ] && [ $page -le $max_pages ]; do
        url="https://$name.en.uptodown.com/android/apps/$id/versions/$page"
        version_url=$(getRequestUpToDown - "$url" | jq -r --arg version "$version" '.data[] | select(.version == $version) | .versionURL')

        if [ -z "$version_url" ]; then
            ((page++))
            sleep 5
        fi
    done

    if [ -z "$version_url" ]; then
        echo "Error: Version $version not found for $name" >&2
        return 1
    fi

    url="https://dw.uptodown.com/dwn/$(getRequestUpToDown - "$version_url" | pup 'button#detail-download-button attr{data-url}')"
    getRequestUpToDown "$package.apk" "$url"
    
    if [ $? -ne 0 ] || [ ! -s "$package.apk" ]; then
        echo "Error: Failed to download $package.apk" >&2
        return 1
    fi
}

getDownloadURLAPKPure() {
    local package="$1"
    local version="$2"

    if [ -z "$version" ]; then
        version=$(getRequestAPKPure - "$revancedApi" | getSupportedVersion "$package")
    fi

    if [ -z "$version" ]; then
        version=$(getRequestAPKPure - "https://apkpure.com/search?q=$package" | pup 'div[data-dt-app='"$package"'] attr{data-dt-version}')
    fi

    local code=$(getRequestAPKPure - "https://apkpure.com/search?q=$package" | pup 'div[data-dt-app='"$package"']' | pup 'a.first-info attr{href}')"/versions"
    code=$(getRequestAPKPure - "$code" | pup 'a[data-dt-version='"$version"'] attr{data-dt-versioncode}')
    local url="https://d.apkpure.com/b/APK/$package?versionCode=$code"

    getRequestAPKPure "${package}.apk" "$url"

    if [ $? -ne 0 ] || [ ! -s "${package}.apk" ]; then
        echo "Error: Failed to download ${package}.apk" >&2
        return 1
    fi
}

downloadAndMoveApk() {
    local source="$1"
    local appName="$2"
    local pkgName="$3"
    local version="${4:-}"

    echo "$(date -u '+%Y-%m-%d %H:%M:%S') DOWNLOAD: $pkgName $version from $source"

    if [ "$source" = "uptodown" ]; then
        getDownloadURLUpToDown "$appName" "$pkgName" "$version" 2>&1 | tee /tmp/download_log.txt
    elif [ "$source" = "apkpure" ]; then
        getDownloadURLAPKPure "$pkgName" "$version" 2>&1 | tee /tmp/download_log.txt
    else
        echo "Error: Unknown source $source" >&2
        return 1
    fi

    if [ -s "${pkgName}.apk" ]; then
        mv "${pkgName}.apk" "downloads/${pkgName}.apk"
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') SUCCESS: Downloaded $pkgName $version from $source"
        return 0
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') ERROR: APK file is empty or download failed for $pkgName $version from $source"
        cat /tmp/download_log.txt >&2
        return 1
    fi
}

if [ ! -d "$appFolder" ]; then
    mkdir -p "$appFolder"
fi

declare -A apps=(
    [REVANCED]="uptodown $BUILD_REVANCED $APPNAME_REVANCED $PKGNAME_REVANCED $VERSION_REVANCED"
    [REVANCED_MUSIC]="apkpure $BUILD_REVANCED_MUSIC $APPNAME_REVANCED_MUSIC $PKGNAME_REVANCED_MUSIC $VERSION_REVANCED_MUSIC"
    [RETWITCH]="uptodown $BUILD_RETWITCH $APPNAME_RETWITCH $PKGNAME_RETWITCH $VERSION_RETWITCH"
    [RELIGHTROOM]="uptodown $BUILD_RELIGHTROOM $APPNAME_RELIGHTROOM $PKGNAME_RELIGHTROOM $VERSION_RELIGHTROOM"
    [RETWITTER]="apkpure $BUILD_RETWITTER $APPNAME_RETWITTER $PKGNAME_RETWITTER $VERSION_RETWITTER"
    [REINSTAGRAM]="apkpure $BUILD_REINSTAGRAM $APPNAME_REINSTAGRAM $PKGNAME_REINSTAGRAM $VERSION_REINSTAGRAM"
    [RETIKTOK]="uptodown $BUILD_RETIKTOK $APPNAME_RETIKTOK $PKGNAME_RETIKTOK $VERSION_RETIKTOK"
    [REPIXIV]="uptodown $BUILD_REPIXIV $APPNAME_REPIXIV $PKGNAME_REPIXIV $VERSION_REPIXIV"
    [REVSCO]="uptodown $BUILD_REVSCO $APPNAME_REVSCO $PKGNAME_REVSCO $VERSION_REVSCO"
    [REREDDIT]="uptodown $BUILD_REREDDIT $APPNAME_REREDDIT $PKGNAME_REREDDIT $VERSION_REREDDIT"
    [REBANDCAMP]="uptodown $BUILD_REBANDCAMP $APPNAME_REBANDCAMP $PKGNAME_REBANDCAMP $VERSION_REBANDCAMP"
)

for app in "${!apps[@]}"; do
    IFS=' ' read -r source buildFlag appName pkgName version <<< "${apps[$app]}"
    if [ "$buildFlag" = "true" ]; then
        downloadAndMoveApk "$source" "$appName" "$pkgName" "$version"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') SKIP: $pkgName $version"
    fi
    sleep 20s
done

# Check if apksigner is installed and in your PATH
if ! command -v apksigner &> /dev/null
then
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') WARNING: apksigner is not found. Skipping verification."
else
    # Iterate through all .apk files in the downloads folder
    for apk_file in downloads/*.apk; do
        # Run apksigner verify and capture the output and errors
        output=$(apksigner verify "$apk_file" 2>&1)

        # Check if the word "Malformed" is present in the output
        if [[ $output == *"Malformed APK"* ]]; then
            echo "$(date -u '+%Y-%m-%d %H:%M:%S') VERIFICATION: [BAD] $apk_file is not passing the verification!"
            rm -f "$apk_file"
        else
            echo "$(date -u '+%Y-%m-%d %H:%M:%S') VERIFICATION: [GOOD] $apk_file is passing the verification!"
        fi
    done
fi