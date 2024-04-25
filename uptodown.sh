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
         -H 'sec-ch-ua: "Brave";v="123", "Not:A-Brand";v="8", "Chromium";v="123' -H "sec-ch-ua-mobile: ?0" \
         -H 'sec-ch-ua-platform: "Windows"' \
         -s \
         -L \
         -o "$1" "$2"
}

getSupportedVersionUpToDown() {
    jq -r --arg pkg_name "$1" '.. | objects | select(.name == "\($pkg_name)" and .versions != null) | .versions[-1]' | uniq
}

getDownloadURLUpToDown() {

    name="$1" 
    package="$2"
    url="https://$name.en.uptodown.com/android"
    id="$(getRequestUpToDown - 2>/dev/null $url | pup 'h1[id=detail-app-name] attr{code}')"

    if [ -n "$3" ]; then
        version="$3"
    else
        version=$(getRequestUpToDown - 2>/dev/null $revancedApi | getSupportedVersionUpToDown "$package")
    fi

    if [ -n "$4" ]; then
        pages="$4"
    else
        pages="1"
    fi

    if [ -z "$pages" ]; then
        pages="1" 
    fi

    url="https://$name.en.uptodown.com/android/apps/$id/versions/$pages"

    if [ -z "$version" ]; then
        version=$(getRequestUpToDown - 2>/dev/null $url | jq -r '.data[0].version')
    fi

    url=$(getRequestUpToDown - 2>/dev/null $url | jq -r '.data[] | select(.version == "'$version'") | .versionURL' \
                                                | sed 's#/download/#/post-download/#g;q')

    url="https://dw.uptodown.com/dwn/$(getRequestUpToDown - "$url" | pup -p --charset utf-8 'div[class="post-download"]' attr{data-url})"
    getRequestUpToDown $package.apk $url
}

downloadAndMoveApk() {
    local appName="$1"
    local pkgName="$2"
    local version="${3:-}"
    local pages="${4:-1}"

    getDownloadURLUpToDown "$appName" "$pkgName" "$version" "$pages"
    wait
    mv "${pkgName}.apk" "downloads/${pkgName}.apk"
    sleep 30s
}

declare -A apps=(
    [REMICROG]="$BUILD_REMICROG $APPNAME_REMICROG $PKGNAME_REMICROG $VERSION_REMICROG"
    [REVANCED]="$BUILD_REVANCED $APPNAME_REVANCED $PKGNAME_REVANCED $VERSION_REVANCED"
    [REVANCED_MUSIC]="$BUILD_REVANCED_MUSIC $APPNAME_REVANCED_MUSIC $PKGNAME_REVANCED_MUSIC $VERSION_REVANCED_MUSIC"
    [RETWITCH]="$BUILD_RETWITCH $APPNAME_RETWITCH $PKGNAME_RETWITCH $VERSION_RETWITCH"
    [RELIGHTROOM]="$BUILD_RELIGHTROOM $APPNAME_RELIGHTROOM $PKGNAME_RELIGHTROOM $VERSION_RELIGHTROOM"
    #[RETWITTER]="$BUILD_RETWITTER $APPNAME_RETWITTER $PKGNAME_RETWITTER $VERSION_RETWITTER"
    [REINSTAGRAM]="$BUILD_REINSTAGRAM $APPNAME_REINSTAGRAM $PKGNAME_REINSTAGRAM $VERSION_REINSTAGRAM"
    [RETIKTOK]="$BUILD_RETIKTOK $APPNAME_RETIKTOK $PKGNAME_RETIKTOK $VERSION_RETIKTOK 3"
    [REPIXIV]="$BUILD_REPIXIV $APPNAME_REPIXIV $PKGNAME_REPIXIV $VERSION_REPIXIV"
    [REVSCO]="$BUILD_REVSCO $APPNAME_REVSCO $PKGNAME_REVSCO $VERSION_REVSCO"
    [REREDDIT]="$BUILD_REREDDIT $APPNAME_REREDDIT $PKGNAME_REREDDIT $VERSION_REREDDIT"
)

if [ ! -d "$appFolder" ]; then
    mkdir -p "$appFolder"
fi

for app in "${!apps[@]}"; do
    IFS=' ' read -r buildFlag appName pkgName version pages <<< "${apps[$app]}"
    if [ "$buildFlag" = "true" ]; then
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') DOWNLOAD: $pkgName $version"
        downloadAndMoveApk "$appName" "$pkgName" "$version" "$pages"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') SKIP: $pkgName $version"
    fi
done