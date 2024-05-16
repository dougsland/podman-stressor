#!/bin/bash -e
# shellcheck disable=SC1091,SC2155,SC2086
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
source ./constants

# Function to create a container
create_container() {
    local container_name=$1
    local image_name=$2
    local command_to_run=$3
    local volume_name=$4
    local network_name=$5
    local verbose=$6

    local start_time=$(date +%s%3N) # Log start time in milliseconds

    podman run -d --replace \
        --name "$container_name" \
        --volume "$volume_name:/data" \
        --network "$network_name" \
        "$image_name" \
	$command_to_run &> /dev/null

    local end_time=$(date +%s%3N) # Log end time in milliseconds
}

# Function to stop and remove a container
stop_and_remove_container() {
    local container_name=$1

    if [[ "$verbose" -eq 1 ]]; then
        echo -e "[ ${BLUE}INFO${NC} ] stopping and removing container ${container_name}"
    fi
    # Attempt to stop the container gracefully with a custom timeout
    podman stop --timeout 20 "$container_name" &> /dev/null
    # Forcefully remove the container if it still exists
    if ! podman rm "$container_name" &> /dev/null; then
	echo -e "[ ${RED}FAIL${NC} ] to remove container $container_name."
        exit 255
    fi
}

# Function to create containers in parallel using background processes
create_containers_in_parallel() {
    local num_containers=$1
    local image_name=$2
    local command_to_run=$3
    local volume_name=$4
    local network_name=$5
    local verbose=$6

    # Create containers in the background and capture their PIDs and names
    declare -A pid_to_container

    for i in $(seq 1 $num_containers); do
        container_name="test_container_$i"
	    
	if [[ "$verbose" -eq 1 ]]; then
            echo -e "[ ${BLUE}INFO${NC} ] creating container ${container_name}"
        fi

	create_container "$container_name" \
            "$image_name" \
            "$command_to_run" \
            "$volume_name" \
            "$network_name" \
	    "$verbose" &
	 pid_to_container[$!]=$container_name
    done

    # Wait for all background processes to finish and check their exit statuses
    wait_fail=0

    for pid in "${!pid_to_container[@]}"; do
        if ! wait $pid; then
            echo -e "[ ${RED}FAIL${NC} ] Failed to run container ${pid_to_container[$pid]} with PID $pid."
            wait_fail=1
        fi
    done

    if [ $wait_fail -ne 0 ]; then
        exit 255
    else
        echo -e "[ ${GREEN}PASS${NC} ] All containers requested are running successfully."
    fi
}

# Function to stop and remove all created containers in parallel
cleanup_containers_in_parallel() {
    local num_containers=$1
    for i in $(seq 1 $num_containers); do
        stop_and_remove_container "test_container_$i" &
    done

    # Wait for all background processes to finish
    wait
}

# Main function to run the script
main() {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <create|remove> <additional_parameters>"
        exit 1
    fi

    local action=$1

    case $action in
        create)
            if [ $# -ne 7 ]; then
                echo "Usage: $0 create <num_containers> <image_name> <command_to_run> <volume_name> <network_name> <verbose>"
                exit 1
            fi
            local num_containers=$2
            local image_name=$3
            local command_to_run=$4
            local volume_name=$5
            local network_name=$6
	    local verbose=$7

            local start_time=$(date +%s)
	
	    create_containers_in_parallel \
                "$num_containers" \
                "$image_name" \
                "$command_to_run" \
                "$volume_name" \
                "$network_name" \
	        "$verbose"

            local end_time=$(date +%s)
            local elapsed_time=$((end_time - start_time))
            echo -e "[ ${GREEN}PASS${NC} ] Total number of containers created in parallel: $num_containers"
            echo -e "[ ${GREEN}PASS${NC} ] Time taken: $elapsed_time seconds."
            ;;
        remove)
            if [ $# -ne 3 ]; then
                echo "Usage: $0 remove <num_containers> <verbose>"
                exit 1
            fi
            local num_containers="$2"
	    local verbose="$3"
            cleanup_containers_in_parallel "$num_containers" "$verbose"
            ;;
        *)
            echo "Unknown action: $action"
            exit 1
            ;;
    esac
}

main "$@"
