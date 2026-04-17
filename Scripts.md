# Scripts for Termux on Android

> NOTE! Always use absolute paths, as cronie/boot scripts don't load the shell

## Backup

> Assumes all backups like in `$HOME/storage/shared/Backups`
>
> Can pick backup folder per service (i.e. `Backups/Calendar`); typically follow app name

`backup.sh` does what it says -- backs up a folder.

Also uses these packages (install with `obtanium`):

- `termux:api`
- `termux:boot`

API access is used to alert on failed backups.
This is only a major concern on multiple failures in a row.
The script does not re-run multiple times, so should only error and notify once daily.

Install `cronie` for crontab services

```sh
pkg update && pkg install cronie -y
```

Setup a boot entry in `$HOME/.termux/boot/start-services`

```sh
mkdir $HOME/.termux/boot
```

`crontab -e`

```txt
#!/data/data/com.termmux/files/usr/bin/sh
termux-wakae-lock
/data/data/com.termmux/files/usr/etc/profile.d/start-services
```

```sh
chmod +x $HOME/.termux/boot/start-services
```

Then a cronjob (via `crontab -e`)

> This one run at 02:30 daily

```txt
30 2 * * * /data/data/com.termux/files/home/backup.sh >/data/data/com.termux/files/home/logs/backup.log
```

Ensure the logs directory has been created

```sh
mkdir $HOME/logs
```
