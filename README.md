# Servers Load Notifier
Shell scripts which send email alert if CPU/Memory usage continuously goes above a certain amount.


##USAGE

These scripts are kind of System Activity Reporter [SAR] on Linux.
By these scripts user can get email alert on cpu/memory overload and also get detailed information for overloaded processes

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
OPTION_ALERT_ON_CPU_LOAD_IF_EXCEEDS=75  #integer!

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