# podman-stressor
Just a modular collection of podman calls to simulate "a BAD day for podman" ;-)

Let's start with an example below:  

*"Create a Podman network named my_network, a volume named my_volume, and 20 containers using the alpine image with the image command sleep 3600. Once created, remove everything, as this setup is just for testing the environment!"*

```
./podman-stressor \
  --network "my_network" \
  --volume "my_volume" \
  --number-of-containers 20 \
  --image-name "alpine" \
  --image-command "sleep 3600" \
```

```
Options:
  --verbose, -v, --v                 Enable verbose mode
  --network <network>                Specify the network
  --volume <volume>                  Specify the volume
  --number-of-containers <num>       Specify the number of containers
  --image-name <image_name>          Specify the image name
  --image-command <image_command>    Specify the image command
  --cleanup                          Enable cleanup mode
  --list-current-state               Enable list current state mode
```

**Second Example**:

*"Create a Podman network named my_network, a volume named my_volume, and 100 containers using the alpine image with the image command sleep 3600. List current network, storage and verbose mode. Once created, remove everything, as this setup is just for testing the environment!"*

```
./podman-stressor \
  --network "my_network" \
  --volume "my_volume" \
  --number-of-containers 100 \
  --image-name "alpine" \
  --image-command "sleep 3600" \
  --list-current-state \
  --verbose \
  --cleanup
```

**Still interested to continue reading about?**

See the output for a PASS test (no verbose mode or list-current-state):
```
[ PASS ] volume my_volume created.
[ PASS ] network my_network created.
[ PASS ] All containers requested are running successfully.
[ PASS ] Total number of containers created in parallel: 2
[ PASS ] Time taken: 1 seconds.

[ PASS ] All tests passed.
```

Checking if really worked:
```
$podman-stressor$ podman ps
CONTAINER ID  IMAGE                            COMMAND     CREATED        STATUS        PORTS       NAMES
e7c04505c83d  docker.io/library/alpine:latest  sleep 3600  2 seconds ago  Up 2 seconds              test_container_1
abb513b64cd5  docker.io/library/alpine:latest  sleep 3600  2 seconds ago  Up 2 seconds              test_container_2
```

Checking volume and network created:
```
$ podman volume ls | grep my_volume
local       my_volume

$ podman network ls | grep my_network
1a33f12e7eee  my_network  bridge
```

Output for a FAIL test:
```
./podman-stressor \
  --network "my_network" \
  --volume "my_volume" \
  --number-of-containers 2 \
  --image-name "alpine" \
  --image-command "sleep 3600"
Error: volume with name my_volume already exists: volume already exists
[ FAIL ] unable to create volume my_volume.
```

Let's get an output from a more verbose mode (--verbose plus --list-current-state):

```
$ ./podman-stressor \
    --network "my_network" \
    --volume "my_volume" \
    --number-of-containers 2 \
    --image-name "alpine" \
    --image-command "sleep 3600" \
    --list-current-state \
    --verbose \
    --cleanup


[ INFO ] =======================================================
[ INFO ] VERBOSE MODE IS ON
[ INFO ] =======================================================
[ INFO ] --network is my_network
[ INFO ] --volume is my_volume
[ INFO ] --number-of-containers is 2
[ INFO ] --image-name is alpine
[ INFO ] --image-command is sleep 3600
[ INFO ] --list-current-state is set

[ INFO ] Listing current podman env state NO CHANGES FROM SCRIPT

[ INFO ] ===============================================
[ INFO ]              Listing current podman processes
[ INFO ] ===============================================
[ INFO ] CONTAINER ID  IMAGE       COMMAND     CREATED     STATUS      PORTS       NAMES
[ INFO ] ===============================================

[ INFO ] ===============================================
[ INFO ]              Listing current podman volume
[ INFO ] ===============================================
[ INFO ] DRIVER      VOLUME NAME
[ INFO ] local       test
[ INFO ] local       super
[ INFO ] local       dogz
[ INFO ] local       medogz
[ INFO ] ===============================================

[ INFO ] ===============================================
[ INFO ]              Listing current podman network
[ INFO ] ===============================================
[ INFO ] NETWORK ID    NAME        DRIVER
[ INFO ] 41af11b0f3d5  netcow      bridge
[ INFO ] 2f259bab93aa  podman      bridge
[ INFO ] ===============================================
[ INFO ] creating volume my_volume
[ PASS ] volume my_volume created.
[ INFO ] creating network my_network
[ PASS ] network my_network created.
[ INFO ] creating container test_container_1
[ INFO ] creating container test_container_2
[ PASS ] All containers requested are running successfully.
[ PASS ] Total number of containers created in parallel: 2
[ PASS ] Time taken: 0 seconds.

[ INFO ] ===============================================
[ INFO ]              Listing current podman processes
[ INFO ] ===============================================
[ INFO ] CONTAINER ID  IMAGE                            COMMAND     CREATED                 STATUS                 PORTS       NAMES
[ INFO ] 1012e9a1e865  docker.io/library/alpine:latest  sleep 3600  Less than a second ago  Up Less than a second              test_container_2
[ INFO ] 1ee043d0a2ed  docker.io/library/alpine:latest  sleep 3600  Less than a second ago  Up Less than a second              test_container_1
[ INFO ] ===============================================

[ INFO ] ===============================================
[ INFO ]              Listing current podman volume
[ INFO ] ===============================================
[ INFO ] DRIVER      VOLUME NAME
[ INFO ] local       my_volume
[ INFO ] local       test
[ INFO ] local       super
[ INFO ] local       dogz
[ INFO ] local       medogz
[ INFO ] ===============================================

[ INFO ] ===============================================
[ INFO ]              Listing current podman network
[ INFO ] ===============================================
[ INFO ] NETWORK ID    NAME        DRIVER
[ INFO ] 2a2543c7b7d9  my_network  bridge
[ INFO ] 41af11b0f3d5  netcow      bridge
[ INFO ] 2f259bab93aa  podman      bridge
[ INFO ] ===============================================

[ PASS ] All tests passed.
```
