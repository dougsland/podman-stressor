systemd tests

```bash
$ sudo CLEANUP=true \
       VERBOSE=false \
       NETWORK_NAME="${NETNAME}" \
       VOLUME_NAME="${VOLNAME}" \
       IMAGE_COMMAND="/sbin/init" \
       IMAGE_NAME="ubi8/ubi-init" \
       NUMBER_OF_CONTAINERS="1" \
       SYSTEMD_TIMEOUTSTOPSEC="INFINITY" \
       ./podman-stressor 
```

```bash
$ ./is-TimeoutStopSec_infinity_works
[ INFO ] Cleaning any file from previous tests...
[ INFO ] Executing test: systemd TimeoutStopSec=Infinity
[ PASS ] systemd TimeoutStopSec=inifiny is working as expected
[ INFO ]
[ INFO ] This test was executed in the following criteria:
[ INFO ]
[ INFO ] 2024-05-27 09:18:16 EDT
[ INFO ] OS: Fedora Linux
[ INFO ] VERSION: 39 (Workstation Edition)
[ INFO ]
```



```
$ sudo CLEANUP=false \
       VERBOSE=false \
       NETWORK_NAME="my_network" \
       VOLUME_NAME="my_volume" \
       IMAGE_COMMAND="sleep 3600" \
       IMAGE_NAME="quay.io/centos-sig-automotive/automotive-osbuild" \
       NUMBER_OF_CONTAINERS="1" \
       SERVICE_MUST_BE_DISABLED="podman" \
       ./podman-stressor
```

Output:
```bash
$ ./is-service-disabled
[ INFO ] Cleaning any file from previous tests...
[ INFO ] Executing test: service must be disabled in the distro: [podman]
[ INFO ] This test was executed in the following criteria:
[ INFO ]
[ INFO ] 2024-05-26 11:15:53 EDT
[ INFO ] OS: Fedora Linux
[ INFO ] VERSION: 39 (Workstation Edition)
[ INFO ]
[ PASS ] service podman is DISABLED
```

```
   sudo CLEANUP=false \
         VERBOSE=false \
         NETWORK_NAME="my_network" \
         VOLUME_NAME="my_volume" \
         IMAGE_COMMAND="sleep 3600" \
         IMAGE_NAME="quay.io/centos-sig-automotive/automotive-osbuild" \
         NUMBER_OF_CONTAINERS="1" \
         SERVICE_MUST_BE_ENABLED="bluechi-controller,bluechi-agent" \
         ./podman-stressor
```
Output:
```bash
$ ./is-service-enabled
[ INFO ] Cleaning any file from previous tests...
[ INFO ] Executing test: service must be enabled in the distro:
[ INFO ]
[ INFO ] - bluechi-controller
[ INFO ] - bluechi-agent
[ INFO ]
[ INFO ] This test was executed in the following criteria:
[ INFO ] 2024-05-26 11:11:12 EDT
[ INFO ] OS: Fedora Linux
[ INFO ] VERSION: 39 (Workstation Edition)
[ INFO ]
[ FAIL ] service bluechi-controller is disabled
[ FAIL ] service bluechi-agent is disabled
```
