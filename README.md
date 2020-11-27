# My Home Network Setup

During the 2020-2021 COVID-19 pandemic I took some time to improve my own place now that I am spending much more time in it. One thing I found myself doing was this project to better document and maintain my home network, and have data to diagnose potential issues. This meant hooking up data tracking tools like Prometheus and Grafana. This also ties into a better backup solution than I've had in the past.

I want to be able to have answers to questions such as:

- When did the Internet go down, is it on our side, or the ISP's side?
- Is it just DNS specifically or is it completely down?
- What is our Power & Water consumption?
- Is the Freezer working correctly?
- What is our air quality like?

## Current Hardware

Our current ISP is [Wave-G](https://waveg.wavebroadband.com) where we have 1Gbit down & up. The fiber is terminated in our apartment building's electrical closet on each floor, it's then run to our unit via CAT-5e where it's terminated with a female ethernet port. From that we then have have CAT-5e going into our [Synology RT2600ac](https://www.synology.com/en-us/products/RT2600ac) router which acts as our Firewall, DHCP host, switch, and Wireless 5GHz WiFi access point. The RT2600ac feeds into a number of ethernet wall-ports which are all around our apartment. We use a [Netgear R7000](https://www.netgear.com/home/products/networking/wifi-routers/R7000.aspx) as a switch in our tiny livingroom/office.

We have a [Raspberry Pi 4 8GB](https://www.raspberrypi.org/products/raspberry-pi-4-model-b) as our primary server currently.

Our primary network is running on 192.168.0.1/24.

## Software

Both our Synology RT2600ac and Netgear R7000 currently run stock firmware.

The Raspberry Pi runs [Raspberry Pi OS Lite x64](https://www.raspberrypi.org/software/operating-systems/), you can find everything directly installed via the [install.sh](./raspberry-pi/install.sh) setup/update script. This largely consists of Docker.

We use docker-compose to run all of our [services](./raspberry-pi/services/). Everything inside docker runs on the 10.0.0.0/28 subnet. Each service can be accessed via `servicename.raspberrypi.local`.

Current services:

- [Pi-hole](https://pi-hole.net)
  We run Pi-hole as our primary DNS server for adblocking at the DNS level. This then passes through to 8.8.8.8, Google's DNS.
- [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy)
  We have nginx-proxy running as an ingress (in the kubernetes sense) to expose all of our services on port 80, on different domain names. Each service must state what port they expose by using the `VIRTUAL_HOST` and `VIRTUAL_PORT` environment variables. Pi-hole then needs to know about the host names for DNS purposes via the `extra_hosts` list.
- [Grafana](https://grafana.com)
  Grafana is our primary data visualizer, log viewer, and alerting tool. Our grafana is currently provisioned via [grafana/provisioning/](./raspberry-pi/services/grafana/provisioning/), all changes to dashboards and datasources must be submitted to that directory.
- [Portainer](https://www.portainer.io)
  We use Portainer to get an overview of our little cluster. I treat it similarly to [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/).
- [InfluxDB](https://www.influxdata.com)
  Time series Database, this is the datasource for Grafana.
- [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/)
  Telegraf collects and exposes metrics which then pushes into InfluxDB and we can view in Grafana. Telegraf's configuration is located in [telegraf/](./raspberry-pi/services/telegraf/).
- [Syncthing](https://syncthing.net)
  Syncthing is an open source Dropbox/One Drive style file syncronization service. We use this to continously backup our devices to the home server for onsite backup.
- [sql_influx](./raspberry-pi/services/sql_influx/)
  Just some garbage that scrapes Pi-hole metrics into InfluxDB.

## Diagrams

![Home Network Diagram](./diagrams/output/home_network.png)

We use the [Diagrams](https://diagrams.mingrammer.com) as Code library for Python to generate our home network diagrams. See [diagrams/README.md](./diagrams/README.md) for more information.

## Raspberry Pi Deployment

The services folder lives in `~/services` on the Raspberry Pi. We connect to it via SSH with `ssh pi@raspberrypi`.

There is currently no sane way of updating unfortunately. I have just copied things over manually, this needs serious improvement, such as [GitOps](https://medium.com/@bhargavshah2011/overview-of-gitops-31e206e19e4e).

Then run the following:

```bash
# Navigate to the services folder
$ cd services

# Updates and runs all services
$ run.sh
```

## Future Work

- Start rack mounting everything.
- Get a standalone firewall and switch.
- Migrate towards Kubernetes with [k3s](https://k3s.io/) and multiple raspberry pi's.
- Setup additional monitoring.
- Improved offsite backup.
- VPN support. (Wireguard?)
- Media streaming.
- Better deployment for services (prior to switching to k3s).
- Better documentation, diagrams, runbooks, etc.
- Improve security.

This repository will be kept up to date as I improve my home network.

## Inspiration

- [Alex Ellis - Five years of Raspberry Pi Clusters](https://alexellisuk.medium.com/five-years-of-raspberry-pi-clusters-77e56e547875)
- [Karan Sharma - Monitoring my home network](https://mrkaran.dev/posts/isp-monitoring/)
- [Scott Hanselman - Review: UniFi from Ubiquiti Networking is the ultimate prosumer home networking solution](https://www.hanselman.com/blog/review-unifi-from-ubiquiti-networking-is-the-ultimate-prosumer-home-networking-solution)
- [Nate and Xtina Smarthome](https://gitlab.com/nathang21/nate-and-xtina-home/-/tree/master)
- [Yaakov - A Ubiquiti Home Network](https://blog.yaakov.online/a-ubiquiti-home-network/)
