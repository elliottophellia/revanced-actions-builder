#!/usr/bin/env bash

# TECHNICALLY WORK BUT THERE IS BUNCH UNSUPPORTED APKs

# Configs
source configs.txt

# Download Folder
appFolder="downloads"

# Revanced API
revancedApi="https://api.revanced.app/v2/patches/latest"

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

getSupportedVersionAPKPure() {
    jq -r --arg pkg_name "$1" '.. | objects | select(.name == "\($pkg_name)" and .versions != null) | .versions[-1]' | uniq
}

getDownloadURLAPKPure() {

    package="$1"
    version="$2"

    if [ -n "$version" ]; then
        version="$version"
    else
        version=$(getRequestAPKPure - 2>/dev/null $revancedApi | getSupportedVersionAPKPure "$pkgName")
    fi

    if [ -z "$version" ]; then
        version=$(getRequestAPKPure - 2>/dev/null "https://apkpure.com/search?q=$package" | pup 'div[data-dt-app='"$package"'] attr{data-dt-version}')
    fi

    code=$(getRequestAPKPure - 2>/dev/null "https://apkpure.com/search?q=$package" | pup 'div[data-dt-app='"$package"']' | pup 'a.first-info attr{href}')"/versions"
    code=$(getRequestAPKPure - 2>/dev/null "$code" | pup 'a[data-dt-version='"$version"'] attr{data-dt-versioncode}')
    url="https://d.apkpure.com/b/APK/$package?versionCode=$code"

    getRequestAPKPure "${pkgName}.apk" "$url"
}

if [ ! -d "$appFolder" ]; then
    mkdir -p "$appFolder"
fi

downloadAndMoveApk() {
    local pkgName="$1"
    local version="${2:-}"

    getDownloadURLAPKPure "$pkgName" "$version"
    wait
    mv "${pkgName}.apk" "downloads/${pkgName}.apk"
    sleep 30s
}

declare -A apps=(
    #[REMICROG]="$BUILD_REMICROG $PKGNAME_REMICROG $VERSION_REMICROG"
    #[REVANCED]="$BUILD_REVANCED $PKGNAME_REVANCED $VERSION_REVANCED"
    #[REVANCED_MUSIC]="$BUILD_REVANCED_MUSIC $PKGNAME_REVANCED_MUSIC $VERSION_REVANCED_MUSIC"
    #[RETWITCH]="$BUILD_RETWITCH $PKGNAME_RETWITCH $VERSION_RETWITCH"
    #[RELIGHTROOM]="$BUILD_RELIGHTROOM $PKGNAME_RELIGHTROOM $VERSION_RELIGHTROOM"
    [RETWITTER]="$BUILD_RETWITTER $PKGNAME_RETWITTER $VERSION_RETWITTER"
    #[REINSTAGRAM]="$BUILD_REINSTAGRAM $PKGNAME_REINSTAGRAM $VERSION_REINSTAGRAM"
    #[RETIKTOK]="$BUILD_RETIKTOK $PKGNAME_RETIKTOK $VERSION_RETIKTOK"
    #[REPIXIV]="$BUILD_REPIXIV $PKGNAME_REPIXIV $VERSION_REPIXIV"
    #[REVSCO]="$BUILD_REVSCO $PKGNAME_REVSCO $VERSION_REVSCO"
    #[REREDDIT]="$BUILD_REREDDIT $PKGNAME_REREDDIT $VERSION_REREDDIT"
)

for app in "${!apps[@]}"; do
    IFS=' ' read -r buildFlag pkgName version <<< "${apps[$app]}"
    if [ "$buildFlag" = "true" ]; then
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') DOWNLOAD: $pkgName $version"
        downloadAndMoveApk "$pkgName" "$version"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') SKIP: $pkgName $version"
    fi
done