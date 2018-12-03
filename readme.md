# Oracle Application Express (APEX) Projects
Created by Stephen Cloete

# A Collection of Oracle APEX Projects

## apex-blogger 

## apex-data-explorer

## apex-database-monitoring

## apex-dropzone-dataloader

## apex-file-manager

## apex-guest-house

## apex-health-monitor

## apex-inventory-control

## apex-mobile 
IONIC Cordova Application hosting Oracle APEX

## apex-mycv
My Personal CV https://apex.oracle.com/pls/apex/f?p=SC

## apex-ridesharing 
LOOP Ridesharing https://loop-ridesharing.co.za

## Documentation

# Getting Started with Oracle APEX on Digital Ocean Droplet

Getting Started is as simple as going to https://apex.oracle.com/pls/apex/ and signing up however if you'd like your own custom development environment have a look at the instructions below with special thanks to the original authors.


Oracle APEX on Digital Ocean Droplet

On Digital Ocean , I've setup the following technologies:

```
CentOS Linux 7
CentOS is a community driven version of a very reliable RPM-based commercial linux distribution called RHEL (Red Hat Enterprise Linux). Each time a new version of RHEL comes out, they have to share their source code to public (due to licence limitations), and contributors of CentOS take this new version, re-brand, compile and distribute it for free (CentOS stands for Community enterprise Operating System). There's also another option - Oracle Linux, which developers do almost the same, but the CentOS community.
```

```
Oracle Database XE within Docker
APEX engine lives inside the Oracle Database. It's available for free and can be installed into its Express Edition as well, which is a totally free option. Current version of the RDBMS is 18c. How due to the fact that this is only a limited free version of the RDBMS, it offers a lot of great features, which were usually included only with the Enterprise Edition of it.
```

```
Oracle APEX
Low-code web development platform. Quoting the official website, it enables you to design, develop and deploy beautiful, responsive, database-driven applications using only your web browser. It is a free Oracle Database feature. APEX needs a web listener to function - and there're three options available at the moment:
1.	Embedded PL/SQL Gateway (EPG) - it is a built-in Oracle XDB feature. It is not recommended to be used in production environments, because it's not as fast and as reliable as other options. Though it surely could be used for development and testing purposes.
2.	mod_plsql with Oracle HTTP Server - this is an obsolete option which is not recommended to be used anymore.
3.	Oracle Rest Data Services (ORDS) - the option which is officially recommended for production use by Oracle and the one we will be observing here.
```

```
ORDS
ORDS is a Java EE-based web application which can run in standalone mode or could be deployed to an application server such as Oracle WebLogic, GlassFish or Apache Tomcat. When run in standalone mode, it leverages a built-in web server powered by Jetty.
Besides being a listener for APEX, ORDS could be used to implement RESTful APIsfor your databases. And by saying databases I mean relational databases, document stores and even Oracle NoSQL Database.
```

```
Apache Tomcat
The Apache Tomcat software is an open source implementation of the Java Servlet, JavaServer Pages, Java Expression Language and Java WebSocket technologies. It is a really powerful and fast application server, which is totally free piece of software and is community driven. At the time it is the most commonly used application server for Java applications.
In our setup it is going to be used because of ability to be flexibly configured and for security reasons. It is also much more convenient to use Tomcat service instead of standalone mode of ORDS.
```

```
Apache httpd
Apache httpd is a standard de-facto when it comes to HTTP server software. I think it is extra to tell more about it. We are going to use it because it gives us even more freedom in configuration and because Apache httpd is the fastest solution when it comes to static files such as pictures, style sheets and so on. In our setup it will serve APEX static files and will be reverse-proxying requests to ORDS deployed to Tomcat using the special AJP protocol, which eliminates HTTP-like overhead.
```

Creating an Oracle APEX 18.2 VM on CentOS 7
Part 1 CentOS Linux 7

Step 1: Signup for an account via https://www.digitalocean.com/
Step 2: Create Droplet by choosing an image being CentOS 7.5 x64 and I've gone for the $20/mo plan with 4GB Ram / 2CPU's and 80GB Storage
Setp 3: Select a Datacenter Region and I recommend selecting Monitoring with the Additional Options which provides you with an graphical representation of your Droplet. 
Step 4: provide a hostname and select Create

Part 2 Configuration of CentOS Linux 7

Step 1: Login as ROOT and excute the following
```
yum update

yum install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64 mc net-tools.x86_64 htop iotop iftop unzip wget epel-release –y

yum install rlwrap -y
```

Step 2: Installation of Docker
```
curl -fsSL https://get.docker.com/ | sh 
or yum install docker

systemctl start docker
systemctl status docker
systemctl enable docker 
```