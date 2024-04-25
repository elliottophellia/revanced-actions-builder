```
╦═╗╔═╗╦  ╦╔═╗╔╗╔╔═╗╔═╗╔╦╗ REVANCED ACTIONS BUILDER
╠╦╝║╣ ╚╗╔╝╠═╣║║║║  ║╣  ║║ BUILD REVANCED YOURSELF!
╩╚═╚═╝ ╚╝ ╩ ╩╝╚╝╚═╝╚═╝═╩╝ @elliottophellia #VSPO

- ko-fi.com/elliottophellia
- saweria.co/elliottophellia
- trakteer.id/elliottophellia
- liberapay.com/elliottophellia
```

Build ReVanced using GitHub Actions.<br/>
**NO APKs WILL BE UPLOADED IN THIS REPOSITORY UNDER ANY CIRCUMSTANCES TO AVOID DMCA.**

## Usage

1. Fork this repository
2. Create your own a certificate and save it to `KEYSTORE`
4. Create `KEYSTORE_CN` and `KEYSTORE_PASSWORD` secret with your certificate details
5. Create `ACTIONS_DEPLOY_ACCESS_TOKEN` secret with your GitHub Personal Access Token
6. Go to Actions
7. Run `Build APK with Rei Patches` workflow

or

1. Fork this repository
2. Contact me on telegram [@elliottophellia](https://t.me/elliottophellia)
3. Kindly ask for `KEYSTORE_CN` and `KEYSTORE_PASSWORD`
4. Put `KEYSTORE_CN` and `KEYSTORE_PASSWORD` in your secrets
5. Create `ACTIONS_DEPLOY_ACCESS_TOKEN` secret with your GitHub Personal Access Token
6. Go to Actions
7. Run `Build APK with Rei Patches` workflow

## Configurations

```config
#
# REVANCED BUILD APK CONFIG
#
# READ THIS FIRST | READ THIS FIRST | READ THIS FIRST | READ THIS FIRST
#
# Latest version of GMSCore/MicroG is alredy included so you don't really have to build it again
# Youtube Music, Twitch, TikTok, and VSCO is not supported by APKPure
# Twitter (X) is not supported by UpToDown
# Mix is used to fix those two issues
# PKGNAME and VERSION variables are might be different for each Mirror
#

APP_MIRROR="mix"

BUILD_REMICROG="false"
BUILD_REVANCED="true"
BUILD_REVANCED_MUSIC="true"
BUILD_RETWITCH="true"
BUILD_RELIGHTROOM="true"
BUILD_RETWITTER="true"
BUILD_REINSTAGRAM="true"
BUILD_RETIKTOK="true"
BUILD_REPIXIV="true"
BUILD_REVSCO="true"
BUILD_REREDDIT="true"

APPNAME_REMICROG="microg-for-ogyt"
APPNAME_REVANCED="youtube"
APPNAME_REVANCED_MUSIC="youtube-music"
APPNAME_RETWITCH="twitch"
APPNAME_RELIGHTROOM="adobe-lightroom-mobile"
APPNAME_RETWITTER="twitter"
APPNAME_REINSTAGRAM="instagram"
APPNAME_RETIKTOK="tiktok"
APPNAME_REPIXIV="pixiv"
APPNAME_REVSCO="vsco-cam"
APPNAME_REREDDIT="reddit-official-app"

PKGNAME_REMICROG="com.mgoogle.android.gms"
PKGNAME_REVANCED="com.google.android.youtube"
PKGNAME_REVANCED_MUSIC="com.google.android.apps.youtube.music"
PKGNAME_RETWITCH="tv.twitch.android.app"
PKGNAME_RELIGHTROOM="com.adobe.lrmobile"
PKGNAME_RETWITTER="com.twitter.android"
PKGNAME_REINSTAGRAM="com.instagram.android"
PKGNAME_RETIKTOK="com.ss.android.ugc.trill"
PKGNAME_REPIXIV="jp.pxv.android"
PKGNAME_REVSCO="com.vsco.cam"
PKGNAME_REREDDIT="com.reddit.frontpage"

VERSION_REMICROG="0.3.1.4.240913"
VERSION_REVANCED="19.11.43"
VERSION_REVANCED_MUSIC="6.45.54"
VERSION_RETWITCH="16.9.1"
VERSION_RELIGHTROOM="9.2.0"
VERSION_RETWITTER="10.35.0-release.0"
VERSION_REINSTAGRAM="326.0.0.42.90"
VERSION_RETIKTOK="32.5.3"
VERSION_REPIXIV="6.104.1"
VERSION_REVSCO="345"
VERSION_REREDDIT="2024.15.0"
```

## License

```
Revanced-Actions-Builder  Copyright (C)  2024 Reidho Satria
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions; read LICENSE for details.
```

## Credits

- [revanced-build-template](https://github.com/n0k0m3/revanced-build-template) by [n0k0m3](https://github.com/n0k0m3)
- [revanced-patches](https://github.com/revanced/revanced-patches) by [revanced](https://github.com/revanced)
- [revanced-integrations](https://github.com/revanced/revanced-integrations) by [revanced](https://github.com/revanced)
- [revanced-cli](https://github.com/revanced/revanced-cli) by [revanced](https://github.com/revanced)
- [revanced-gmscore](https://github.com/revanced/gmscore) by [revanced](https://github.com/revanced)
