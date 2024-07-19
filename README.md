# My own Homelab configurations

Kubernetes homelab configurations for running open source alternatives to popular cloud software and taking ownership of data!

The homelab runs on a k3s Raspberry Pi cluster.

## Networking

The lab runs on the local network of my apartment. The IP range for this network is `192.168.10.0/24`, allowing for 252 addresses taking the router and broadcast addresses into account. The planned homelab will feature four nodes mounted on a rack, although I would like some leeway for expansion and debugging. I deemed 16 addresses enough for my purposes and settled for /28 as the subnet mask. The subnet starts at 160 (10100000), making the full CIDR `192.168.10.160/28`. The table below displays the units and their associated static IP address.

| Unit     | IP             |
| -------- | -------------- |
| Leader   | 192.168.10.161 | 
| Worker 1 | 192.168.10.162 |
| Worker 2 | 192.168.10.163 |
| Worker 3 | 192.168.10.164 |

> [!Warning]
> Out of the workers above, only the leader exists at the moment. The workers will be purchased after the prototype is deemed successful.

## Storage

Storage is handled by [Longhorn](https://longhorn.io/), which handles distributed storage disks through a layer of abstraction. This enables me to plug any storage medium into any Raspberry Pi, and treat it as native storage from all connected nodes in the cluster. The table below displays the storage units for the cluster, alongside capacity and type.

| Unit     | Storage Medium | Capacity |
| -------- | -------------- | -------- |
| Leader   | SD Card        | 512 GB   |
|          | SSD            | 2 TB     |
| Worker 1 |                |          |
| Worker 2 |                |          |
| Worker 3 |                |          |
| -------- | -------------- | -------- |
| Total    |                | 2.5 TB   |
