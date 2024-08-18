#!/usr/bin/env bash

source configs.txt
PATCHES="./patches.txt"

declare -a revanced_patches
declare -a revanced_music_patches
declare -a retwitch_patches
declare -a relightroom_patches
declare -a retwitter_patches
declare -a reinstagram_patches
declare -a retiktok_patches
declare -a repixiv_patches
declare -a revsco_patches
declare -a rereddit_patches
declare -a rebandcamp_patches

populate_revanced-patches() {
    while read -r revanced__patches; do
        revanced_patches+=("$1 $revanced__patches")
    done <<<"$2"
}

populate_revanced-music-patches() {
    while read -r revanced_music__patches; do
        revanced_music_patches+=("$1 $revanced_music__patches")
    done <<<"$2"
}

populate_retwitch-patches() {
    while read -r retwitch__patches; do
        retwitch_patches+=("$1 $retwitch__patches")
    done <<<"$2"
}

populate_relightroom-patches() {
    while read -r relightroom__patches; do
        relightroom_patches+=("$1 $relightroom__patches")
    done <<<"$2"
}

populate_retwitter-patches() {
    while read -r retwitter__patches; do
        retwitter_patches+=("$1 $retwitter__patches")
    done <<<"$2"
}

populate_reinstagram-patches() {
    while read -r reinstagram__patches; do
        reinstagram_patches+=("$1 $reinstagram__patches")
    done <<<"$2"
}

populate_retiktok-patches() {
    while read -r retiktok__patches; do
        retiktok_patches+=("$1 $retiktok__patches")
    done <<<"$2"
}

populate_repixiv-patches() {
    while read -r repixiv__patches; do
        repixiv_patches+=("$1 $repixiv__patches")
    done <<<"$2"
}

populate_revsco-patches() {
    while read -r revsco__patches; do
        revsco_patches+=("$1 $revsco__patches")
    done <<<"$2"
}

populate_rereddit-patches() {
    while read -r rereddit__patches; do
        rereddit_patches+=("$1 $rereddit__patches")
    done <<<"$2"
}

populate_rebandcamp-patches() {
    while read -r rebandcamp__patches; do
        rebandcamp_patches+=("$1 $rebandcamp__patches")
    done <<<"$2"
}

revanced_included_start="$(grep -n -m1 'ReVanced included patches' "$PATCHES" | cut -d':' -f1)"
revanced_excluded_start="$(grep -n -m1 'ReVanced excluded patches' "$PATCHES" | cut -d':' -f1)"
revanced_music_included_start="$(grep -n -m1 'ReVancedMusic included patches' "$PATCHES" | cut -d':' -f1)"
revanced_music_excluded_start="$(grep -n -m1 'ReVancedMusic excluded patches' "$PATCHES" | cut -d':' -f1)"
retwitch_included_start="$(grep -n -m1 'ReTwitch included patches' "$PATCHES" | cut -d':' -f1)"
retwitch_excluded_start="$(grep -n -m1 'ReTwitch excluded patches' "$PATCHES" | cut -d':' -f1)"
relightroom_included_start="$(grep -n -m1 'ReLightroom included patches' "$PATCHES" | cut -d':' -f1)"
relightroom_excluded_start="$(grep -n -m1 'ReLightroom excluded patches' "$PATCHES" | cut -d':' -f1)"
retwitter_included_start="$(grep -n -m1 'ReTwitter included patches' "$PATCHES" | cut -d':' -f1)"
retwitter_excluded_start="$(grep -n -m1 'ReTwitter excluded patches' "$PATCHES" | cut -d':' -f1)"
reinstagram_included_start="$(grep -n -m1 'ReInstagram included patches' "$PATCHES" | cut -d':' -f1)"
reinstagram_excluded_start="$(grep -n -m1 'ReInstagram excluded patches' "$PATCHES" | cut -d':' -f1)"
retiktok_included_start="$(grep -n -m1 'ReTikTok included patches' "$PATCHES" | cut -d':' -f1)"
retiktok_excluded_start="$(grep -n -m1 'ReTikTok excluded patches' "$PATCHES" | cut -d':' -f1)"
repixiv_included_start="$(grep -n -m1 'RePixiv included patches' "$PATCHES" | cut -d':' -f1)"
repixiv_excluded_start="$(grep -n -m1 'RePixiv excluded patches' "$PATCHES" | cut -d':' -f1)"
revsco_included_start="$(grep -n -m1 'ReVSCO included patches' "$PATCHES" | cut -d':' -f1)"
revsco_excluded_start="$(grep -n -m1 'ReVSCO excluded patches' "$PATCHES" | cut -d':' -f1)"
rereddit_included_start="$(grep -n -m1 'ReReddit included patches' "$PATCHES" | cut -d':' -f1)"
rereddit_excluded_start="$(grep -n -m1 'ReReddit excluded patches' "$PATCHES" | cut -d':' -f1)"
rebandcamp_included_start="$(grep -n -m1 'ReBandcamp included patches' "$PATCHES" | cut -d':' -f1)"
rebandcamp_excluded_start="$(grep -n -m1 'ReBandcamp excluded patches' "$PATCHES" | cut -d':' -f1)"

revanced_included_patches="$(tail -n +$revanced_included_start $PATCHES | head -n "$((revanced_excluded_start - revanced_included_start))" | grep '^[^#[:blank:]]')"
revanced_excluded_patches="$(tail -n +$revanced_excluded_start $PATCHES | grep '^[^#[:blank:]]')"
revanced_music_included_patches="$(tail -n +$revanced_music_included_start $PATCHES | head -n "$((revanced_music_excluded_start - revanced_music_included_start))" | grep '^[^#[:blank:]]')"
revanced_music_excluded_patches="$(tail -n +$revanced_music_excluded_start $PATCHES | grep '^[^#[:blank:]]')"
retwitch_included_patches="$(tail -n +$retwitch_included_start $PATCHES | head -n "$((retwitch_excluded_start - retwitch_included_start))" | grep '^[^#[:blank:]]')"
retwitch_excluded_patches="$(tail -n +$retwitch_excluded_start $PATCHES | grep '^[^#[:blank:]]')"
relightroom_included_patches="$(tail -n +$relightroom_included_start $PATCHES | head -n "$((relightroom_excluded_start - relightroom_included_start))" | grep '^[^#[:blank:]]')"
relightroom_excluded_patches="$(tail -n +$relightroom_excluded_start $PATCHES | grep '^[^#[:blank:]]')"
retwitter_included_patches="$(tail -n +$retwitter_included_start $PATCHES | head -n "$((retwitter_excluded_start - retwitter_included_start))" | grep '^[^#[:blank:]]')"
retwitter_excluded_patches="$(tail -n +$retwitter_excluded_start $PATCHES | grep '^[^#[:blank:]]')"
reinstagram_included_patches="$(tail -n +$reinstagram_included_start $PATCHES | head -n "$((reinstagram_excluded_start - reinstagram_included_start))" | grep '^[^#[:blank:]]')"
reinstagram_excluded_patches="$(tail -n +$reinstagram_excluded_start $PATCHES | grep '^[^#[:blank:]]')"
retiktok_included_patches="$(tail -n +$retiktok_included_start $PATCHES | head -n "$((retiktok_excluded_start - retiktok_included_start))" | grep '^[^#[:blank:]]')"
retiktok_excluded_patches="$(tail -n +$retiktok_excluded_start $PATCHES | grep '^[^#[:blank:]]')"
repixiv_included_patches="$(tail -n +$repixiv_included_start $PATCHES | head -n "$((repixiv_excluded_start - repixiv_included_start))" | grep '^[^#[:blank:]]')"
repixiv_excluded_patches="$(tail -n +$repixiv_excluded_start $PATCHES | grep '^[^#[:blank:]]')"
revsco_included_patches="$(tail -n +$revsco_included_start $PATCHES | head -n "$((revsco_excluded_start - revsco_included_start))" | grep '^[^#[:blank:]]')"
revsco_excluded_patches="$(tail -n +$revsco_excluded_start $PATCHES | grep '^[^#[:blank:]]')"
rereddit_included_patches="$(tail -n +$rereddit_included_start $PATCHES | head -n "$((rereddit_excluded_start - rereddit_included_start))" | grep '^[^#[:blank:]]')"
rereddit_excluded_patches="$(tail -n +$rereddit_excluded_start $PATCHES | grep '^[^#[:blank:]]')"
rebandcamp_included_patches="$(tail -n +$rebandcamp_included_start $PATCHES | head -n "$((rebandcamp_excluded_start - rebandcamp_included_start))" | grep '^[^#[:blank:]]')"
rebandcamp_excluded_patches="$(tail -n +$rebandcamp_excluded_start $PATCHES | grep '^[^#[:blank:]]')"

[[ ! -z "$revanced_included_patches" ]] && populate_revanced-patches "-i" "$revanced_included_patches"
[[ ! -z "$revanced_excluded_patches" ]] && populate_revanced-patches "-e" "$revanced_excluded_patches"
[[ ! -z "$revanced_music_included_patches" ]] && populate_revanced-music-patches "-i" "$revanced_music_included_patches"
[[ ! -z "$revanced_music_excluded_patches" ]] && populate_revanced-music-patches "-e" "$revanced_music_excluded_patches"
[[ ! -z "$retwitch_included_patches" ]] && populate_retwitch-patches "-i" "$retwitch_included_patches"
[[ ! -z "$retwitch_excluded_patches" ]] && populate_retwitch-patches "-e" "$retwitch_excluded_patches"
[[ ! -z "$relightroom_included_patches" ]] && populate_relightroom-patches "-i" "$relightroom_included_patches"
[[ ! -z "$relightroom_excluded_patches" ]] && populate_relightroom-patches "-e" "$relightroom_excluded_patches"
[[ ! -z "$retwitter_included_patches" ]] && populate_retwitter-patches "-i" "$retwitter_included_patches"
[[ ! -z "$retwitter_excluded_patches" ]] && populate_retwitter-patches "-e" "$retwitter_excluded_patches"
[[ ! -z "$reinstagram_included_patches" ]] && populate_reinstagram-patches "-i" "$reinstagram_included_patches"
[[ ! -z "$reinstagram_excluded_patches" ]] && populate_reinstagram-patches "-e" "$reinstagram_excluded_patches"
[[ ! -z "$retiktok_included_patches" ]] && populate_retiktok-patches "-i" "$retiktok_included_patches"
[[ ! -z "$retiktok_excluded_patches" ]] && populate_retiktok-patches "-e" "$retiktok_excluded_patches"
[[ ! -z "$repixiv_included_patches" ]] && populate_repixiv-patches "-i" "$repixiv_included_patches"
[[ ! -z "$repixiv_excluded_patches" ]] && populate_repixiv-patches "-e" "$repixiv_excluded_patches"
[[ ! -z "$revsco_included_patches" ]] && populate_revsco-patches "-i" "$revsco_included_patches"
[[ ! -z "$revsco_excluded_patches" ]] && populate_revsco-patches "-e" "$revsco_excluded_patches"
[[ ! -z "$rereddit_included_patches" ]] && populate_rereddit-patches "-i" "$rereddit_included_patches"
[[ ! -z "$rereddit_excluded_patches" ]] && populate_rereddit-patches "-e" "$rereddit_excluded_patches"
[[ ! -z "$rebandcamp_included_patches" ]] && populate_rebandcamp-patches "-i" "$rebandcamp_included_patches"
[[ ! -z "$rebandcamp_excluded_patches" ]] && populate_rebandcamp-patches "-e" "$rebandcamp_excluded_patches"

function build_revanced() {
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [START] $(echo $APPNAME_REVANCED | tr [':lower:]' [':upper:'])"
    if [ -f "downloads/$PKGNAME_REVANCED.apk" ]; then
        java -jar revanced-cli.jar patch -m revanced-integrations.apk -b revanced-patches.jar --keystore=keystore.keystore --keystore-entry-alias=elliottophellia --keystore-password=elliottophellia --keystore-entry-password=elliottophellia \
            ${revanced_patches[@]} \
            downloads/$PKGNAME_REVANCED.apk -o "output/rei_$(echo $APPNAME_REVANCED | tr [':upper:]' [':lower:'])_v$VERSION_REVANCED.apk" > /dev/null 2>&1

        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [GOOD] Successfully rebuild $(echo $APPNAME_REVANCED | tr [':upper:]' [':lower:'])"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [BAD] Cannot find $(echo $APPNAME_REVANCED | tr [':upper:]' [':lower:']) base package"
    fi
}

function build_revanced_music() {
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [START] $(echo $APPNAME_REVANCED_MUSIC | tr [':lower:]' [':upper:'])"
    if [ -f "downloads/$PKGNAME_REVANCED_MUSIC.apk" ]; then
        java -jar revanced-cli.jar patch -m revanced-integrations.apk -b revanced-patches.jar --keystore=keystore.keystore --keystore-entry-alias=elliottophellia --keystore-password=elliottophellia --keystore-entry-password=elliottophellia \
            ${revanced_music_patches[@]} \
            downloads/$PKGNAME_REVANCED_MUSIC.apk -o "output/rei_$(echo $APPNAME_REVANCED_MUSIC | tr [':upper:]' [':lower:'])_v$VERSION_REVANCED_MUSIC.apk" > /dev/null 2>&1

        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [GOOD] Successfully rebuild $(echo $APPNAME_REVANCED_MUSIC | tr [':upper:]' [':lower:'])"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [BAD] Cannot find $(echo $APPNAME_REVANCED_MUSIC | tr [':upper:]' [':lower:']) base package"
    fi
}

function build_retwitch() {
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [START] $(echo $APPNAME_RETWITCH | tr [':lower:]' [':upper:'])"
    if [ -f "downloads/$PKGNAME_RETWITCH.apk" ]; then
        java -jar revanced-cli.jar patch -m revanced-integrations.apk -b revanced-patches.jar --keystore=keystore.keystore --keystore-entry-alias=elliottophellia --keystore-password=elliottophellia --keystore-entry-password=elliottophellia \
            ${retwitch_patches[@]} \
            downloads/$PKGNAME_RETWITCH.apk -o "output/rei_$(echo $APPNAME_RETWITCH | tr [':upper:]' [':lower:'])_v$VERSION_RETWITCH.apk" > /dev/null 2>&1

        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [GOOD] Successfully rebuild $(echo $APPNAME_RETWITCH | tr [':upper:]' [':lower:'])"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [BAD] Cannot find $(echo $APPNAME_RETWITCH | tr [':upper:]' [':lower:']) base package"
    fi
}

function build_relightroom() {
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [START] $(echo $APPNAME_RELIGHTROOM | tr [':lower:]' [':upper:'])"
    if [ -f "downloads/$PKGNAME_RELIGHTROOM.apk" ]; then
        java -jar revanced-cli.jar patch -m revanced-integrations.apk -b revanced-patches.jar --keystore=keystore.keystore --keystore-entry-alias=elliottophellia --keystore-password=elliottophellia --keystore-entry-password=elliottophellia \
            ${relightroom_patches[@]} \
            downloads/$PKGNAME_RELIGHTROOM.apk -o "output/rei_$(echo $APPNAME_RELIGHTROOM | tr [':upper:]' [':lower:'])_v$VERSION_RELIGHTROOM.apk" > /dev/null 2>&1

        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [GOOD] Successfully rebuild $(echo $APPNAME_RELIGHTROOM | tr [':upper:]' [':lower:'])"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [BAD] Cannot find $(echo $APPNAME_RELIGHTROOM | tr [':upper:]' [':lower:']) base package"
    fi
}

function build_retwitter() {
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [START] $(echo $APPNAME_RETWITTER | tr [':lower:]' [':upper:'])"
    if [ -f "downloads/$PKGNAME_RETWITTER.apk" ]; then
        java -jar revanced-cli.jar patch -m revanced-integrations.apk -b revanced-patches.jar --keystore=keystore.keystore --keystore-entry-alias=elliottophellia --keystore-password=elliottophellia --keystore-entry-password=elliottophellia \
            ${retwitter_patches[@]} \
            downloads/$PKGNAME_RETWITTER.apk -o "output/rei_$(echo $APPNAME_RETWITTER | tr [':upper:]' [':lower:'])_v$VERSION_RETWITTER.apk" > /dev/null 2>&1

        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [GOOD] Successfully rebuild $(echo $APPNAME_RETWITTER | tr [':upper:]' [':lower:'])"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [BAD] Cannot find $(echo $APPNAME_RETWITTER | tr [':upper:]' [':lower:']) base package"
    fi
}

function build_reinstagram() {
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [START] $(echo $APPNAME_REINSTAGRAM | tr [':lower:]' [':upper:'])"
    if [ -f "downloads/$PKGNAME_REINSTAGRAM.apk" ]; then
        java -jar revanced-cli.jar patch -m revanced-integrations.apk -b revanced-patches.jar --keystore=keystore.keystore --keystore-entry-alias=elliottophellia --keystore-password=elliottophellia --keystore-entry-password=elliottophellia \
            ${reinstagram_patches[@]} \
            downloads/$PKGNAME_REINSTAGRAM.apk -o "output/rei_$(echo $APPNAME_REINSTAGRAM | tr [':upper:]' [':lower:'])_v$VERSION_REINSTAGRAM.apk" > /dev/null 2>&1

        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [GOOD] Successfully rebuild $(echo $APPNAME_REINSTAGRAM | tr [':upper:]' [':lower:'])"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [BAD] Cannot find $(echo $APPNAME_REINSTAGRAM | tr [':upper:]' [':lower:']) base package"
    fi
}

function build_retiktok() {
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [START] $(echo $APPNAME_RETIKTOK | tr [':lower:]' [':upper:'])"
    if [ -f "downloads/$PKGNAME_RETIKTOK.apk" ]; then
        java -jar revanced-cli.jar patch -m revanced-integrations.apk -b revanced-patches.jar --keystore=keystore.keystore --keystore-entry-alias=elliottophellia --keystore-password=elliottophellia --keystore-entry-password=elliottophellia \
            ${retiktok_patches[@]} \
            downloads/$PKGNAME_RETIKTOK.apk -o "output/rei_$(echo $APPNAME_RETIKTOK | tr [':upper:]' [':lower:'])_v$VERSION_RETIKTOK.apk" > /dev/null 2>&1

        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [GOOD] Successfully rebuild $(echo $APPNAME_RETIKTOK | tr [':upper:]' [':lower:'])"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [BAD] Cannot find $(echo $APPNAME_RETIKTOK | tr [':upper:]' [':lower:']) base package"
    fi
}

function build_repixiv() {
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [START] $(echo $APPNAME_REPIXIV | tr [':lower:]' [':upper:'])"
    if [ -f "downloads/$PKGNAME_REPIXIV.apk" ]; then
        java -jar revanced-cli.jar patch -m revanced-integrations.apk -b revanced-patches.jar --keystore=keystore.keystore --keystore-entry-alias=elliottophellia --keystore-password=elliottophellia --keystore-entry-password=elliottophellia \
            ${repixiv_patches[@]} \
            downloads/$PKGNAME_REPIXIV.apk -o "output/rei_$(echo $APPNAME_REPIXIV | tr [':upper:]' [':lower:'])_v$VERSION_REPIXIV.apk" > /dev/null 2>&1

        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [GOOD] Successfully rebuild $(echo $APPNAME_REPIXIV | tr [':upper:]' [':lower:'])"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [BAD] Cannot find $(echo $APPNAME_REPIXIV | tr [':upper:]' [':lower:']) base package"
    fi
}

function build_revsco() {
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [START] $(echo $APPNAME_REVSCO | tr [':lower:]' [':upper:'])"
    if [ -f "downloads/$PKGNAME_REVSCO.apk" ]; then
        java -jar revanced-cli.jar patch -m revanced-integrations.apk -b revanced-patches.jar --keystore=keystore.keystore --keystore-entry-alias=elliottophellia --keystore-password=elliottophellia --keystore-entry-password=elliottophellia \
            ${revsco_patches[@]} \
            downloads/$PKGNAME_REVSCO.apk -o "output/rei_$(echo $APPNAME_REVSCO | tr [':upper:]' [':lower:'])_v$VERSION_REVSCO.apk" > /dev/null 2>&1

        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [GOOD] Successfully rebuild $(echo $APPNAME_REVSCO | tr [':upper:]' [':lower:'])"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [BAD] Cannot find $(echo $APPNAME_REVSCO | tr [':upper:]' [':lower:']) base package"
    fi
}

function build_rereddit() {
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [START] $(echo $APPNAME_REREDDIT | tr [':lower:]' [':upper:'])"
    if [ -f "downloads/$PKGNAME_REREDDIT.apk" ]; then
        java -jar revanced-cli.jar patch -m revanced-integrations.apk -b revanced-patches.jar --keystore=keystore.keystore --keystore-entry-alias=elliottophellia --keystore-password=elliottophellia --keystore-entry-password=elliottophellia \
            ${rereddit_patches[@]} \
            downloads/$PKGNAME_REREDDIT.apk -o "output/rei_$(echo $APPNAME_REREDDIT | tr [':upper:]' [':lower:'])_v$VERSION_REREDDIT.apk" > /dev/null 2>&1

        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [GOOD] Successfully rebuild $(echo $APPNAME_REREDDIT | tr [':upper:]' [':lower:'])"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [BAD] Cannot find $(echo $APPNAME_REREDDIT | tr [':upper:]' [':lower:']) base package"
    fi
}

function build_rebandcamp() {
    echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [START] $(echo $APPNAME_REBANDCAMP | tr [':lower:]' [':upper:'])"
    if [ -f "downloads/$PKGNAME_REBANDCAMP.apk" ]; then
        java -jar revanced-cli.jar patch -m revanced-integrations.apk -b revanced-patches.jar --keystore=keystore.keystore --keystore-entry-alias=elliottophellia --keystore-password=elliottophellia --keystore-entry-password=elliottophellia \
            ${rebandcamp_patches[@]} \
            downloads/$PKGNAME_REBANDCAMP.apk -o "output/rei_$(echo $APPNAME_REBANDCAMP | tr [':upper:]' [':lower:'])_v$VERSION_REBANDCAMP.apk" > /dev/null 2>&1

        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [GOOD] Successfully rebuild $(echo $APPNAME_REBANDCAMP | tr [':upper:]' [':lower:'])"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') BUILD: [BAD] Cannot find $(echo $APPNAME_REBANDCAMP | tr [':upper:]' [':lower:']) base package"
    fi
}

echo "

╦═╗╔═╗╦  ╦╔═╗╔╗╔╔═╗╔═╗╔╦╗ REVANCED ACTIONS BUILDER
╠╦╝║╣ ╚╗╔╝╠═╣║║║║  ║╣  ║║ BUILD REVANCED YOURSELF!
╩╚═╚═╝ ╚╝ ╩ ╩╝╚╝╚═╝╚═╝═╩╝ @elliottophellia   #VSPO
 
- ko-fi.com/elliottophellia
- saweria.co/elliottophellia
- trakteer.id/elliottophellia
- liberapay.com/elliottophellia

"

mkdir -p output
mkdir -p downloads

echo "

╦ ╦╔╦╗╦╦  ╔═╗ Downloading Utilities
║ ║ ║ ║║  ╚═╗ Used for Rebuilding
╚═╝ ╩ ╩╩═╝╚═╝ ------------------->_

"

REVANCEDCLI="https://api.github.com/repos/revanced/revanced-cli/releases/latest"
REVANCEDGMSCORE="https://api.github.com/repos/revanced/gmscore/releases/latest"
REVANCEDPATCHES="https://api.github.com/repos/revanced/revanced-patches/releases/latest"
REVANCEDINTEGRATIONS="https://api.github.com/repos/revanced/revanced-integrations/releases/latest"

DL_REVANCEDCLI=$(curl -s -H "authorization: Bearer $GHTOKEN" $REVANCEDCLI | jq -r '.assets[] | select(.name | test("revanced-cli-\\d+(\\.\\d+)*\\-all.jar$")) | .browser_download_url')
DL_REVANCEDGMSCORE=$(curl -s -H "authorization: Bearer $GHTOKEN" $REVANCEDGMSCORE | jq -r '.assets[] | select(.name | test("app.revanced.android.gms-\\d+-signed.apk")) | .browser_download_url')
DL_REVANCEDPATCHES=$(curl -s -H "authorization: Bearer $GHTOKEN" $REVANCEDPATCHES | jq -r '.assets[] | select(.name | test("revanced-patches-\\d+(\\.\\d+)*\\.jar$")) | .browser_download_url')
DL_REVANCEDINTEGRATIONS=$(curl -s -H "authorization: Bearer $GHTOKEN" $REVANCEDINTEGRATIONS | jq -r '.assets[] | select(.name | test("revanced-integrations-\\d+(\\.\\d+)*\\.apk$")) | .browser_download_url')

echo -e "\n$(date -u '+%Y-%m-%d %H:%M:%S') DOWNLOAD: $(basename $DL_REVANCEDCLI | tr '[:lower:]' '[:upper:]')\n" && curl -s -L -H "authorization: Bearer $GHTOKEN" "$DL_REVANCEDCLI" -o revanced-cli.jar &
wait
echo -e "\n$(date -u '+%Y-%m-%d %H:%M:%S') DOWNLOAD: $(basename $DL_REVANCEDGMSCORE | tr '[:lower:]' '[:upper:]')\n" && curl -s -L -H "authorization: Bearer $GHTOKEN" "$DL_REVANCEDGMSCORE" -o output/rei_microg_latest.apk &
wait
echo -e "\n$(date -u '+%Y-%m-%d %H:%M:%S') DOWNLOAD: $(basename $DL_REVANCEDPATCHES | tr '[:lower:]' '[:upper:]')\n" && curl -s -L -H "authorization: Bearer $GHTOKEN" "$DL_REVANCEDPATCHES" -o revanced-patches.jar &
wait
echo -e "\n$(date -u '+%Y-%m-%d %H:%M:%S') DOWNLOAD: $(basename $DL_REVANCEDINTEGRATIONS | tr '[:lower:]' '[:upper:]')\n" && curl -s -L -H "authorization: Bearer $GHTOKEN" "$DL_REVANCEDINTEGRATIONS" -o revanced-integrations.apk &
wait

echo "

╔═╗╔═╗╦╔═╔═╗ Downloading APKs
╠═╣╠═╝╠╩╗╚═╗ from Internet
╩ ╩╩  ╩ ╩╚═╝ ------------------->_

"

chmod +x ./download.sh
./download.sh

echo "

╔╦╗╔═╗╦╔═╔═╗ Rebuilding Base APKs
║║║╠═╣╠╩╗║╣  With Revanced Patches
╩ ╩╩ ╩╩ ╩╚═╝ ------------------->_

"

declare -A build_apps=(
    [REVANCED]="$BUILD_REVANCED"
    [REVANCED_MUSIC]="$BUILD_REVANCED_MUSIC"
    [RETWITCH]="$BUILD_RETWITCH"
    [RELIGHTROOM]="$BUILD_RELIGHTROOM"
    [RETWITTER]="$BUILD_RETWITTER"
    [REINSTAGRAM]="$BUILD_REINSTAGRAM"
    [RETIKTOK]="$BUILD_RETIKTOK"
    [REPIXIV]="$BUILD_REPIXIV"
    [REVSCO]="$BUILD_REVSCO"
    [REREDDIT]="$BUILD_REREDDIT"
    [REBANDCAMP]="$BUILD_REBANDCAMP"
)

for app in "${!build_apps[@]}"; do
    build_var="${build_apps[$app]}"
    if [ "$build_var" = "true" ]; then
        build="build_$(echo $app | tr '[:upper:]' '[:lower:]')"
        eval $build
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') SKIP: $app"
    fi
done
wait

rm -rf downloads

echo "
Done!
"
