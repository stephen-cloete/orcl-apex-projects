[![APEX Built with Love](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/7919f913/badges/apex-love-badge.svg)](https://github.com/Dani3lSun/apex-github-badges)

[<img src="https://rawgit.com/Dani3lSun/awesome-orclapex/master/apex-logo.svg" align="right" width="100">](https://apex.oracle.com)

# Oracle Application Express (APEX) Projects
Created by Stephen Cloete

# A Collection of my Oracle APEX Projects

## apex-blogger 
TODO

## apex-data-explorer
TODO

## apex-database-monitoring
TODO

## apex-dropzone-dataloader
TODO

## apex-file-manager
TODO

## apex-guest-house
TODO

## apex-health-monitor
TODO

## apex-inventory-control
TODO

## apex-mobile 
IONIC Cordova Application hosting Oracle APEX Application

## apex-mycv
My Personal CV https://apex.oracle.com/pls/apex/f?p=SC

## apex-ridesharing 
LOOP Ridesharing https://loop-ridesharing.co.za

# Oracle APEX Getting Started Guide

###  Getting Started with Oracle APEX on apex.oracle.com
simply go to https://apex.oracle.com/pls/apex/ and sign-up

### Getting Started with Oracle APEX on Digital Ocean Droplet

If you'd rather like to have your own custom development environment have a look at the instructions below that I've compiled and used.

## Oracle APEX on Digital Ocean Droplet

On Digital Ocean , I've setup the following technologies:

### **CentOS Linux 7**
CentOS is a community driven version of a very reliable RPM-based commercial linux distribution called RHEL (Red Hat Enterprise Linux). Each time a new version of RHEL comes out, they have to share their source code to public (due to licence limitations), and contributors of CentOS take this new version, re-brand, compile and distribute it for free (CentOS stands for Community enterprise Operating System). There's also another option - Oracle Linux, which developers do almost the same, but the CentOS community.

### **Oracle Database XE within Docker**
APEX engine lives inside the Oracle Database. It's available for free and can be installed into its Express Edition as well, which is a totally free option. Current version of the RDBMS is 18c. How due to the fact that this is only a limited free version of the RDBMS, it offers a lot of great features, which were usually included only with the Enterprise Edition of it.

### **Oracle APEX**
Low-code web development platform. Quoting the official website, it enables you to design, develop and deploy beautiful, responsive, database-driven applications using only your web browser. It is a free Oracle Database feature. APEX needs a web listener to function - and there're three options available at the moment:
1.	Embedded PL/SQL Gateway (EPG) - it is a built-in Oracle XDB feature. It is not recommended to be used in production environments, because it's not as fast and as reliable as other options. Though it surely could be used for development and testing purposes.
2.	mod_plsql with Oracle HTTP Server - this is an obsolete option which is not recommended to be used anymore.
3.	Oracle Rest Data Services (ORDS) - the option which is officially recommended for production use by Oracle and the one we will be observing here.

### **ORDS**
ORDS (Oracle Restful Services) is a Java EE-based web application which can run in standalone mode or could be deployed to an application server such as Oracle WebLogic, GlassFish or Apache Tomcat. When run in standalone mode, it leverages a built-in web server powered by Jetty. Besides being a listener for APEX, ORDS could be used to implement RESTful APIs the databases.

### **Apache Tomcat**
The Apache Tomcat software is an open source implementation of the Java Servlet, JavaServer Pages, Java Expression Language and Java WebSocket technologies. It is a really powerful and fast application server, which is totally free piece of software and is community driven. At the time it is the most commonly used application server for Java applications.
In our setup it is going to be used because of ability to be flexibly configured and for security reasons. It is also much more convenient to use Tomcat service instead of standalone mode of ORDS.

### **Apache httpd**
Apache httpd is a standard de-facto when it comes to HTTP server software. I think it is extra to tell more about it. We are going to use it because it gives us even more freedom in configuration and because Apache httpd is the fastest solution when it comes to static files such as pictures, style sheets and so on. In our setup it will serve APEX static files and will be reverse-proxying requests to ORDS deployed to Tomcat using the special AJP protocol, which eliminates HTTP-like overhead.


### Creating an Oracle APEX VM on CentOS

**Part 1 CentOS Linux 7**

* Step 1: Signup for an account via **https://www.digitalocean.com/**
* Step 2: Create Droplet by choosing an image being CentOS 7.5 x64 and I've gone for the $20/mo plan with 4GB Ram / 2 CPU's and 80GB Storage
* Step 3: Select a Datacenter Region and I recommend selecting Monitoring with the Additional Options which provides you with an graphical representation of your Droplet. 
* Step 4: provide a hostname and select Create

**Part 2 Configuration of CentOS Linux 7**

Login as ROOT and execute the following

```
yum update

yum install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64 mc net-tools.x86_64 htop iotop iftop unzip wget epel-release –y

yum install rlwrap -y
```

**Installation of Docker**

```
curl -fsSL https://get.docker.com/ | sh 
or yum install docker

systemctl start docker
systemctl status docker
systemctl enable docker 
```
**Part 3: Installation of Oracle 18c XE Database within Docker**

* Please follow Adrian Ping https://github.com/fuzziebrain/docker-oracle-xe

**Part 4: Installation of Oracle APEX within Docker**

* Please follow Adrian Ping https://github.com/fuzziebrain/docker-oracle-xe/blob/master/docs/apex-install.md

**Part 5: Installation of Oracle Restful Services**

Download ORDS from OTN

* 	```mkdir  /opt/oracle/ords```
* 	```mkdir /opt/oracle/ords/config```
* 	```cp ords-18.*.zip onto /opt/ords and unzip ords-18.*.zip ```
* 	```cd /opt/oracle/ords```
* 	```java -jar ords.war install```

```
Enter the location to store configuration data:/opt/ords/config
Enter the name of the database server [localhost]:localhost
Enter the database listen port [1521]:32118
Enter 1 to specify the database service name, or 2 to specify the database SID [1]:1
Enter the database service name:XEPDB1
Enter the database password for ORDS_PUBLIC_USER:
Confirm password:
Requires SYS AS SYSDBA to verify Oracle REST Data Services schema.

Enter the database password for SYS AS SYSDBA:
Confirm password:
Retrieving information.
Enter 1 if you want to use PL/SQL Gateway or 2 to skip this step.
If using Oracle Application Express or migrating from mod_plsql then you must enter 1 [1]:1
```

**Part 6: Installation of Apache Tomcat**
* Download Tomcat
```
wget http://mirror.za.web4africa.net/apache/tomcat/tomcat-9/v9.0.13/bin/apache-tomcat-9.0.13.tar.gz
```

* Create tomcat folder and Unzip
```
mkdir /opt/tomcat
cp apache-tomcat-9.0.13.tar.gz /opt/tomcat
sudo tar xvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1
```

* Add Tomcat User & Ownership Change

```sudo groupadd tomcat```

```sudo useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat```

```chown -R tomcat:tomcat /opt/tomcat/```


* Create the a systemd file with the following content
```vi /etc/systemd/system/tomcat.service```

```
# Systemd unit file for tomcat
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms1024M -Xmx2056M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
```
 
* Create Tomcat ADMIN User Account

You can create a new Tomcat user in order to be able to acess the Tomcat manager. Open the tomcat-users.xml file and add the following lines:

```vi  /opt/tomcat/conf/tomcat-users.xml```

```
<role rolename="admin-gui" />
<user username="admin" password="PASSWORD" roles="manager-gui,admin-gui"
</tomcat-users>
```

* Tomcat Manager is only accessible from a browser running on the same machine as Tomcat. If you want to remove this restriction, you’ll need to edit the Manager’s context.xml file, and comment out or remove the following line:

```vi /opt/tomcat/webapps/manager/META-INF/content.xml```

```
<Valve className="org.apache.catalina.valves.RemoteAddrValve"
allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
```

* Access Tomcat Server from a web browser

```sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp```

```firewall-cmd –-reload```

* ORDS.war and Apache Tomcat

```cp /opt/ords/ords.war /opt/tomcat/webapps/```

* i.war and Apache Tomcat
```
cp -a /<path to APEX Images/  /opt/tomcat/webapps/
cd /opt/tomcat/webapps/
mv images i
```

* Restart Tomcat
```
service tomcat reload
```
Oracle Application Express should be accessible via **http://HostName:8080/ords/**

**Part 7: Installation of Apache HTTP Server**
* Download Apache HTTP Server ``` yum install httpd```
* Copy APEX Images ```mkdir -p /var/www/apex/images``` 
* Copy Images into the Folder ``` cp -a /PATH TO APEX/apex/images/. /var/www/apex/images ```
* Navagate to HTTPD ```cd /etc/httpd/conf.d``` 
* Create a file called apex.conf ```vi apex.conf```
* Copy the following into the new file

```
# customized Apache configuration

# disable sensitive version info
ServerSignature Off
ServerTokens Prod

# standard alias for Apex image files
Alias /i/ " /var/www/apex/images/"

# forward dynamic (ORDS) requests to Tomcat
<VirtualHost *:80>
  ProxyRequests Off
  ProxyPreserveHost On
  <Proxy *>
    Order deny,allow
    Allow from all
  </Proxy>
  ProxyPass /ords ajp://localhost:8009/ords
  ProxyPassReverse /ords ajp://localhost:8009/ords
</VirtualHost>

# enable compression of static content
<IfModule mod_deflate.c>
   SetOutputFilter DEFLATE
   AddOutputFilterByType DEFLATE text/plain text/html text/xml text/css text/javascript
</IfModule>

# enable client caching of static content
<IfModule mod_expires.c>
  ExpiresActive On
  ExpiresByType image/gif "access plus 7 days"
  ExpiresByType image/jpeg "access plus 7 days"
  ExpiresByType image/png "access plus 7 days"
  ExpiresByType text/css "access plus 7 days"
  ExpiresByType text/javascript "access plus 7 days"
  ExpiresByType application/javascript "access plus 7 days"
  ExpiresByType application/x-javascript "access plus 7 days"
</IfModule>
```

* Allow Apache HTTP Server through the Firewall
```
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload
```

* Testing Apache HTTP Server
**http://HostName/ords**
