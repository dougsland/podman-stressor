selinux tests

```
sudo CLEANUP=false \
     VERBOSE=false \
     NETWORK_NAME="my_network" \
     VOLUME_NAME="my_volume" \
     IMAGE_COMMAND="sleep 3600" \
     IMAGE_NAME="quay.io/centos-sig-automotive/automotive-osbuild" \
     NUMBER_OF_CONTAINERS="1" \
     SELINUX_STATUS_MUST_BE="Disabled" \
     ./podman-stressor
```

Output:
```bash
$ ./is-selinux-status-disabled
[ INFO ] Cleaning any file from previous tests...
[ INFO ] Executing test: SELinux must be [DISABLED]
[ INFO ] This test was executed in the following criteria:
[ INFO ]
[ INFO ] 2024-05-26 11:28:59 EDT
[ INFO ] OS: Fedora Linux
[ INFO ] VERSION: 39 (Workstation Edition)
[ INFO ]
[ PASS ] SELinux status is DISABLED
```

```
sudo CLEANUP=false \
     VERBOSE=false \
     NETWORK_NAME="my_network" \
     VOLUME_NAME="my_volume" \
     IMAGE_COMMAND="sleep 3600" \
     IMAGE_NAME="quay.io/centos-sig-automotive/automotive-osbuild" \
     NUMBER_OF_CONTAINERS="1" \
     SELINUX_STATUS_MUST_BE="Enforcing" \
     ./podman-stressor
```
Output:
```bash
$ ./is-selinux-status-enforcing
[ INFO ] Cleaning any file from previous tests...
[ INFO ] Executing test: SELinux must be [ENFORCING]
[ INFO ] This test was executed in the following criteria:
[ INFO ]
[ INFO ] 2024-05-26 11:29:32 EDT
[ INFO ] OS: Fedora Linux
[ INFO ] VERSION: 39 (Workstation Edition)
[ INFO ]
[ FAIL ] SELinux is NOT in ENFORCING mode in container test_container_1.
[ FAIL ] The current status is: DISABLED
```
