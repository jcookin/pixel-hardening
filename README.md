# Pixel 9 Pro Hardening

## Disable google packages

A script to disable common google services that aren't needed. Audit this list periodically.

> Note: Major versions tend to change package names, correct after next AndroidOS upgrade (e.g. 16 -> 17)

```sh
./pixel-hardening.sh
```

## OTA Updates

Google's OTA updates re-enable some packages automatically.

Check the full enabled package list with

```sh
adb shell pm list packages -e | grep com.google | sort
```

## Show disabled packages

> Enabled packages uses the `-e` flag instead

```sh
adb shell pm list packages -d | grep com.google | sort
```

## Re-enable a packge to fix a broken feature

```sh
adb shell pm enable --user 0 com.package.name
```
