# cda
*A simple iOS command line tool to search for installed apps and list container folders (bundle, data, group).*

This tool facilitates the process of locating installation paths of iOS apps installed on a device. During app assessments, e.g., `cda`can be used to quickly identify an app's bundle (app binary, _Info.plist_, etc.) or user data (_Documents_, _Library_, etc.) folders for further investigation.

##### Features:

  * Wildcard search locally installed apps.
  * Display team and bundle identifier.
  * Display app installation paths (including group containers).
  * Easy copy-paste representation for further investigation.

##### Requirements:

  * Jailbroken iOS device running iOS version 9 or 10.
  * _Optional:_ [Theos](https://github.com/theos/theos) when building from source.

## Installation

##### Option 1: Build from source:

```
$ make
$ make package
$ make package install
```

##### Option 2: Install pre-built package (see _releases_):

```
$ dpkg -i com.nesolabs.cda.deb
```

## Usage

##### Basic search syntax:

```
iPhone:~ root# cda
Syntax: cda searchTerm
```

##### Search apps from the app store:

```
iPhone:~ root# cda system
[1] SystemGuard (99KNG6QLLS.com.rbtdigital.SystemGuardFree)
Bundle: /private/var/containers/Bundle/Application/D054F8DC-95A4-4489-BBBD-68F3E457A575
Data: /private/var/mobile/Containers/Data/Application/2A2FEE52-B59D-42F1-A810-333364E12525

[2] s2 System (M7Q6VVFR4E.com.nivin.S2)
Bundle: /private/var/containers/Bundle/Application/B0779B6D-D9C2-42A5-8900-A55504A6FC5D
Data: /private/var/mobile/Containers/Data/Application/F91D1AC1-F3EF-47CC-A730-5017BA008309
Group: /private/var/mobile/Containers/Shared/AppGroup/09F783EF-AE1C-4FD5-A5DD-EB3028DE0BD3 (group.com.nivin.S2)
```

Please note that `cda` also displays all available _app groups_. App groups are used for data sharing between an app and its contained app extensions. Therefore, app group contents should always be included when reviewing the file system for stored data that that is potentially sensitive.

##### Search system apps:

```
iPhone:~ root# cda store
[1] iTunes (com.apple.ios.StoreKitUIService)
Bundle: /Applications/StoreKitUIService.app
Data: /private/var/mobile/Containers/Data/Application/191AA863-7518-4C11-967B-1AB189628F75

[2] App Store (com.apple.AppStore)
Bundle: /Applications/AppStore.app
Data: /private/var/mobile/Containers/Data/Application/FB0E98E0-4B60-4DCE-BA2D-2784775086EB

[3] StoreDemoViewService (com.apple.StoreDemoViewService)
Bundle: /Applications/StoreDemoViewService.app

[4] iTunes Store (com.apple.MobileStore)
Bundle: /Applications/MobileStore.app
Data: /private/var/mobile/Containers/Data/Application/09C505F7-8BCE-44EC-9C33-34E8A98BC3D6
```
