# Install Glances, InfluxDB and Grafana to Monitor CentOS
### Sources: 

https://computingforgeeks.com/install-grafana-and-influxdb-on-centos-7/

https://www.tecmint.com/install-glances-influxdb-grafana-to-monitor-centos-7/

## About
Glances is a free open source, modern, cross-platform, real-time top and
htop-like monitoring tool with advanced features. It can run in different
modes: as a standalone, in client/server mode and in web server mode.
InfluxDB is an open source and scalable time series database for metrics,
events, and real-time analytics.

Grafana is an open source, feature rich, powerful, elegant and highly extensible,
cross-platform tool for monitoring and metric analytics, with
beautiful and customizable dashboards. It is a de facto software for data
analytics.

### Instalation

***Step 1*** Install Glances in CentOS 7

start by installing latest stable version of glances ```yum install python-pip python-devel``` and then run 
```pip install glances```

Check the versions by running ```glances -V```

Glances v3.0.2 with psutil v5.4.8

***Step 2*** Now you need to start glances via systemd so that it runs as a service.
Create a new unit by creating a file called glances.service in
/etc/systemd/system/. ```vim /etc/systemd/system/glances.service```

Copy and paste the following configuration in the file glances.service. The
--config specifies the config file, --export influxdb option tells
glances to export stats to an InfluxDB server.

```
[Unit]
Description=Glances
After=network.target influxd.service

[Service]
ExecStart=/usr/bin/glances -C /root/.config/glances/glances.conf --quiet --export influxdb
Restart=on-failure
RestartSec=30s
TimeoutSec=30s

[Install]
WantedBy=multi-user.target
```
Save the file and close it.

***Step 3.*** Next, you need to download the glances configuration file provided by the
developer using wget command as shown:

```mkdir ~/.config/glances/```

```cd /root/.config/glances/```

```wget https://raw.githubusercontent.com/nicolargo/glances/master/conf/glances.conf```

***Step 4.*** In order to export Glances stats to an InfluxDB database, you need the
Python InfluxdDB lib, which you can install it using pip command.

```sudo pip install influxdb```

***Step 5.*** Install InfluxDB in CentOS 7 by adding the InfluxDB Yum repository to install latest
vesrion of InfluxDB package as shown.

Within 
```cd /etc/yum.repos.d/```

Create a File Called ```influxdb.repo``` and copy/paste the below information

```
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key 
```

Run 
```sudo yum makecache fast```
```sudo yum -y install influxdb```

Add the Ports to the firewall
```sudo firewall-cmd --add-port=8086/tcp --permanent```
```sudo firewall-cmd --reload```

And start influxdb
```
systemctl start influxdb
systemctl status influxdb
systemctl enable influxdb
```

***Step 6.*** Next, you need to create a database in InfluxDB for storing data from
glances. The influx command which is included in the InfluxDB packages is
the simplest way to interact with the database. So execute influx to start
the CLI and automatically connect to the local InfluxDB instance.
Run ```influx``` and this should say:
```
Connected to http://localhost:8086 version 1.6.2
InfluxDB shell version: 1.6.2
```

```CREATE DATABASE glances```

```SHOW DATABASES```

***To ensure the Database was created. ***

```
name: databases
name
----
_internal
glances
>
To exit the InfluxQL shell, type exit and hit Enter.
```

***Then reload systemd manager configuration, start the glances service,
view its status, and enable it to auto-start at boot time.***

```
systemctl daemon-reload
systemctl start glances.service
systemctl status glances.service
systemctl enable glances.service
```

***Step 7.*** Now, install Grafana from its official YUM repository, start by adding the
following configuration to /etc/yum.repos.d/grafana.repo repository file.

```[grafana]
name=grafana
baseurl=https://packagecloud.io/grafana/stable/el/7/$basearch
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packagecloud.io/gpg.key https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
```
Run 
```sudo yum makecache fast```

```sudo yum -y install grafana```

***Step 8.*** Once you have installed Grafana, reload systemd manager
configuration, start the grafana server, check if the service is up and running
by viewing its status and enable it to auto-start at boot time.

``` 
systemctl daemon-reload
systemctl start grafana-server
systemctl status grafana-server
systemctl enable grafana-server
 ```
 
***Step 9.*** open port 3000 which Grafana server listens on, in your firewall
using the firewall-cmd.
```
 firewall-cmd --add-port=3000/tcp --permanent
 firewall-cmd --reload
 ```
 
***Step 10.*** At this point, you can use the following URL to access Grafana web
interface, which will redirect to the login page, use the default credentials to
login.
URL: http://SERVER_IP:3000
Username: admin
Password: admin

***Step 11.*** Next, click on Create your first data source, which should be an
InfluxDB database. Under Settings, enter a suitable name e.g Glances
Import, then use the following values for the other two important variables

(HTTP URL and InfluxDB Database) as shown in the screenshot.
HTTP URL: http://localhost:8086
InfluxDB Details - Database: glances
Then click on Save & Test to connect to the data source. You should
receive a feedback indicating “Data source is working”.

 Now you need to import the Glances dashboard. Click on the plus (+)
and go to Import

Step 13. You will need either the Glances Dashboard URL or ID or upload its
.JSON file which you can find from Grafana.com. In this case, we will use
the Glances Dashboard created by the developer of Glances, its URL is
https://grafana.com/dashboards/2387 or ID is 2387.

Step 14. Once the Grafana dashboard has been loaded, under options, find
glances and choose an InluxDB data source (Glances Import) which you
created earlier on, then click on Import.

Step 15. After successfully importing the Glances dashboard, you should be able
to watch graphs showing metrics from your server as provided by glances
via influxdb.
 
