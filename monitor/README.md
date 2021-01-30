# Monitor

Monitoring platform for VM Instances in a Cloud, using the SNMP protocol and the InfluxDB and Grafana technologies.

![Alt Text](../docs/monitor.gif)

## Getting Started

### Setting dependencies

First, we add the following line to the end of the `/usr/share/snmp/snmp.conf` file (If it does not exist, create it):

```
MIBS + ALL
```
Thus, we ensure the use of the SNMP protocol by the scripts that will be used.
Then, we installed InfluxDB, which will be responsible for storing the data 
generated and collected.

```
wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
source /etc/lsb-release
echo "deb https://repos.influxdata.com/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo apt-get update && sudo apt-get install influxdb
```

Finally, we install grafana, which is responsible for consuming data from InfluxDB and presenting it through customizable dashboards.

```
sudo apt-get install -y apt-transport-https software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

sudo apt-get update && sudo apt-get install grafana
```

### Setting InfluxDB

Firt, we must start the services responsible for InfluxDB:

```
sudo service influxdb start

# Optional: we can execute the following 
# commands to start services at boot.
sudo service influxdb enable
```

By accessing InfluxDB as an `admin` user, we will create a user `grafana` and the `sysAdmin` database, which will be populated with the collected data.

```
influx -user admin
CREATE USER grafana WITH PASSWORD 'password' WITH ALL PRIVILEGES
CREATE DATABASE sysAdmin
exit
```

### Setting Grafana

Firt, we must start the services responsible for InfluxDB:

```
sudo service grafana-server start

# Optional: we can execute the following
# commands to start services at boot.
sudo service grafana-server enable
```

Through the URL "hostname: 3000", we are able to access the grafana dashboard via browser. On our first login, we use the username and password "admin" (change the password later!).

To connect Grafana to InfluxDB, we need to add InfluxDB as a Data Source in `Settings > Data Source > InfluxDB`. 

Also, import `Dashboard Main.json` and `Dashboard Secondary.json`.

### Setting monitor.sh

Run the `monitor.sh` script, which is responsible for collecting data and populating InfluxDB, with the following command:

```
sudo sh monitor.sh
```
















