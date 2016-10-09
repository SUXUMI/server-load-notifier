# Servers Load Notifier
Shell scripts which sends email alert if certain usage data continuously goes above a certain amount.

**monitor_cpu.sh** - monitor cpu usage
>These script is kind of System Activity Reporter [SAR] on Linux.<br>
Using these script user gets email alert on **cpu overload** overload and get detailed information for overloaded processes<br>Calculation is based on the very top loaded process load value

**monitor_disk_space.sh** - monitor disk space usage
>Using these script user gets email alert on **disk space usage** overload and report file system disk space usage.

##USAGE
Put the script file in an appropriate folder and run the installation command. Than will be created a cronjob for that file, which will monitor the server load.

##### Requirements
```shell
Required one of the following to have on the server: python OR bc OR php
It is used for floating point values calculation
```

##### Configuration
```shell

// Where to send the warning mail
OPTION_ALERT_EMAIL="your@personal.email"

// If the high CPU load exceeds this value, then will be sent an email alert
OPTION_ALERT_ON_CPU_LOAD_IF_EXCEEDS=75  #integer

// How many times check the top loaded process
OPTION_CHECK_n_TIMES=5                  #integer

// Delay between checks
OPTION_CHECK_DELAY=6                    #decimal

// Arbitrary precision calculator
OPTION_CALC_DECIMALS_VIA="python"       #possible values: {python,php,bc}

// Crontab schedule
OPTION_CRONTAB_SCHEDULE="*/5 * * * *"
```

##### Installation
```shell
// will be created a cron job
monitor_cpu.sh install
```

##### De-installation
```shell
// will be removed the cron job created after installation
monitor_cpu.sh uninstall
```

##### Email sample
```shell
USER    PID     %CPU    %MEM    TIME    COMMAND
apache  9298    12.8    0.1     0:01    /usr/sbin/httpd+
apache  9460    9.7     0.1     0:00    /usr/sbin/httpd+
mysql   18667   5.6     0.4     1841:19 mysqld
apache  9288    9.3     0.1     0:04    /usr/sbin/httpd+
```
