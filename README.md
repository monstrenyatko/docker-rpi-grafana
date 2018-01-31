Grafana Docker image for Raspberry Pi
=====================================

[![Build Status](https://travis-ci.org/monstrenyatko/docker-rpi-grafana.svg?branch=master)](https://travis-ci.org/monstrenyatko/docker-rpi-grafana)


About
=====

[Grafana](https://grafana.com/) metric analytics & visualization suite in the `Docker` container.

Upstream Links
--------------
* Docker Registry @[monstrenyatko/rpi-grafana](https://hub.docker.com/r/monstrenyatko/rpi-grafana/)
* GitHub @[monstrenyatko/docker-rpi-grafana](https://github.com/monstrenyatko/docker-rpi-grafana)
* Official Docker Registry @[grafana](https://hub.docker.com/r/grafana/grafana/)


Quick Start
===========

* Pull prebuilt `Docker` image:

	```sh
		docker pull monstrenyatko/rpi-grafana
	```
* Start prebuilt image:

	```sh
		docker-compose up -d
	```
* Logs:

	```sh
		docker-compose logs
	```
* Stop/Restart:

	```sh
		docker-compose stop
		docker-compose start
	```
* Start with additional command-line parameters:

	```sh
		docker-compose run grafana grafana-app <parameters>
	```
* Configuration options:
	See [official Docker image](https://hub.docker.com/r/grafana/grafana/) about all available options.


Build own image
===============

```sh
	cd <path to sources>
	./build.sh <tag name>
```
