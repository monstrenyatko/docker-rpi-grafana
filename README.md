# Grafana for Docker on Raspberry Pi

#### Upstream Links

* Docker Registry @[monstrenyatko/rpi-grafana](https://hub.docker.com/r/monstrenyatko/rpi-grafana/)
* GitHub @[monstrenyatko/docker-rpi-grafana](https://github.com/monstrenyatko/docker-rpi-grafana)

## About

Rework of the official [image](https://hub.docker.com/r/grafana/grafana/) to make it
compatible with Raspberry Pi.

## Build the container

* Execute build script:
```sh
	./build.sh
```

## Run

* Create `Data` storage:
```sh
	GRAFANA_DATA="grafana-data"
	docker volume create --name $GRAFANA_DATA
```
* Create `Configuration` storage:
```sh
	GRAFANA_CFG="grafana-config"
	docker volume create --name $GRAFANA_CFG
```
* Copy `Configuration` to the storage:
```sh
	docker run -v $GRAFANA_CFG:/mnt --rm -v $(pwd):/src hypriot/armhf-busybox \
		cp /src/grafana.ini /mnt/grafana.ini
```
* Edit `Configuration` (OPTIONAL):
```sh
	docker run -v $GRAFANA_CFG:/mnt --rm -it hypriot/armhf-busybox \
		vi /mnt/grafana.ini
```
* Start prebuilt image:
```sh
	docker-compose up -d --no-build
```
* Stop/Restart:
```sh
	docker stop grafana
	docker start grafana
```