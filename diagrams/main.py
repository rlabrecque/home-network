#!/usr/bin/env python3

from diagrams import Cluster, Diagram, Edge
from diagrams.onprem.analytics import Spark
from diagrams.onprem.compute import Server
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.logging import Loki
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.onprem.network import Nginx
from diagrams.onprem.queue import Kafka
from diagrams.onprem.network import Internet
from diagrams.generic.network import Router, Switch
from diagrams.generic.os import LinuxGeneral
from diagrams.onprem.compute import Server, Nomad
from diagrams.onprem.container import Docker
from diagrams.onprem.client import Client, User, Users
from diagrams.gcp.network import DNS
from diagrams.programming.language import Python

def main():
    with Diagram("Home Network", show=False, filename="output/home_network", outformat="png"):
        internet = Internet("internet")

        with Cluster("192.168.0.1/24"):
            router = Router("Synology RT2600ac") # SynologyRouter
            switch = Switch("Netgear R7000")
            raspberrypi = Server("Raspberry Pi 4 8GB") # raspberrypi
            raspberrypi_docker = Docker("Docker")

            devices = Client("Devices")

            internet >> router
            internet << router

            router >> raspberrypi
            router >> switch

            router >> devices
            switch >> devices

            with Cluster("10.0.0.0/28"):
                service_nginx_proxy = Nginx("nginx-proxy")
                service_grafana = Grafana("Grafana")
                service_pi_hole = DNS("Pi-hole")
                service_portainer = LinuxGeneral("Portainer")
                service_telegraf = LinuxGeneral("Telegraf")
                service_prometheus = Prometheus("Prometheus")
                service_loki = Loki("Loki")
                service_promtail = Loki("Promtail")

                raspberrypi >> raspberrypi_docker

                raspberrypi_docker >> service_nginx_proxy

                service_nginx_proxy >> service_grafana
                service_nginx_proxy >> service_pi_hole
                service_nginx_proxy >> service_portainer
                service_nginx_proxy >> service_telegraf
                service_nginx_proxy >> service_prometheus
                service_nginx_proxy >> service_loki
                service_nginx_proxy >> service_promtail

                service_prometheus >> Edge(label="collect metrics", color="firebrick", style="dashed") >> service_telegraf

                service_promtail >> Edge(label="push logs", color="firebrick", style="dashed") >> service_loki

                service_grafana >> Edge(label="query", color="firebrick", style="dashed") >> service_prometheus
                service_grafana >> Edge(label="query", color="firebrick", style="dashed") >> service_loki

if __name__ == "__main__":
    main()