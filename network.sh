#!/bin/bash -e
# shellcheck disable=SC1091
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

# Function to create a network
create_network() {
    local network_name=$1
    local verbose=$2

    if [[ "$verbose" -eq 1 ]]; then
        echo -e "[ ${BLUE}INFO${NC} ] creating network ${network_name}"
    fi

    if ! podman network create "$network_name" 1> /dev/null; then
        echo -e "[ ${RED}FAIL${NC} ] unable to create network $network_name."
	exit 255
    fi
    echo -e "[ ${GREEN}PASS${NC} ] network ${network_name} created."
}

# Function to remove a network
remove_network() {
    local network_name=$1
    local verbose=$2

    if [[ "$verbose" -eq 1 ]]; then
        echo -e "[ ${BLUE}INFO${NC} ] removing network ${network_name}"
    fi

    if ! podman network rm "$network_name" 1> /dev/null; then
        echo -e "[ ${RED}FAIL${NC} ] unable to remove network $network_name."
	exit 255
    fi
    echo -e "[ ${GREEN}PASS${NC} ] network ${network_name} removed."
}

# Function to list networks
list_networks() {
    echo
    # Print header
    echo -e "[ ${BLUE}INFO${NC} ] ==============================================="
    echo -e "[ ${BLUE}INFO${NC} ]              ${GREEN}Listing current podman network${NC}"
    echo -e "[ ${BLUE}INFO${NC} ] ==============================================="

    # Execute podman network ls and check for errors
    if ! output=$(podman network ls 2>&1); then
        echo -e "[ ${RED}ERROR${NC} ] Failed to execute 'podman network ls':"
        echo -e "[ ${RED}ERROR${NC} ] $output"
        echo -e "[ ${BLUE}INFO${NC} ] ==============================================="
        exit 1
    fi

    # Print the output line by line with the formatted header
    echo "$output" | while IFS= read -r line; do
        echo -e "[ ${BLUE}INFO${NC} ] $line"
    done

    # Print footer
    echo -e "[ ${BLUE}INFO${NC} ] ==============================================="
}

# Main function to run the script
main() {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <create|remove|list> [network_name]"
        exit 1
    fi

    local action=$1

    case $action in
        create)
            if [ $# -ne 3 ]; then
                echo "Usage: $0 create <network_name>"
                exit 1
            fi
            create_network "$2" "$3"
            ;;
        remove)
            if [ $# -ne 3 ]; then
                echo "Usage: $0 remove <network_name>"
                exit 1
            fi
            remove_network "$2" "$3"
            ;;
        list)
            list_networks
            ;;
        *)
            echo "Unknown action: $action"
            exit 1
            ;;
    esac

}

# main
main "$@"
