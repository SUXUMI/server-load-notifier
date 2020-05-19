# Servers Load Notifier
Shell scripts which sends email alert if CPU/Disk Space usage continuously goes above a certain amount.

**monitor_cpu.sh** - monitor cpu usage
>These script is a kind of System Activity Reporter [SAR] on Linux.<br>
Using these script user gets email alert on **cpu overload** and get detailed information for overloaded processes<br>Calculation is based on the very top loaded process load value

**monitor_disk_space.sh** - monitor disk space usage
>Using these script user gets email alert on **disk space usage** overload and report file system disk space usage.

## USAGE
Put the script file in an appropriate folder and run the installation command. Then it will be created a cronjob for that file, which will monitor the server load.

#### Requirements
```shell
Required one of the following to have on the server: python OR bc OR php
It is used for calculation floating point values 
```

#### Configuration
```shell
// Where to send the warning mail
OPTION_ALERT_EMAIL="your@personal.email"

// If the high CPU load exceeds this value, then will be sent an email alert
OPTION_ALERT_ON_CPU_LOAD_IF_EXCEEDS=75  #decimal

// How many times check the top loaded process
OPTION_CHECK_n_TIMES=5                  #integer

// Delay between checks
OPTION_CHECK_DELAY=6                    #decimal

// Arbitrary precision calculator
OPTION_CALC_DECIMALS_VIA="python"       #possible values: {python,php,bc}

// Crontab schedule
OPTION_CRONTAB_SCHEDULE="*/5 * * * *"
```

#### Installation
```shell
// will be created a cron job for this file
monitor_cpu.sh install

// will be created a cron job for this file
monitor_disk_space.sh install
```

#### Uninstallation
```shell
// will be removed the cron job created after installation
monitor_cpu.sh uninstall

// will be removed the cron job created after installation
monitor_disk_space.sh uninstall
```

#### Email sample

##### in case of monitor_cpu.sh
```shell
USER    PID     %CPU    %MEM    TIME    COMMAND
apache  9298    12.8    0.1     0:01    /usr/sbin/httpd+
apache  9460    9.7     0.1     0:00    /usr/sbin/httpd+
mysql   18667   5.6     0.4     1841:19 mysqld
apache  9288    9.3     0.1     0:04    /usr/sbin/httpd+
```

##### in case of monitor_disk_space.sh
```shell
Filesystem  Size  Used  Avail  Use%  Mounted on
/dev/md5         16G  3.0G   12G  21% /usr+
/dev/md1        488M  104M  359M  23% /boot+
```
