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

# Function to list volumes
list_processes() {
    echo
    # Print header
    echo -e "[ ${BLUE}INFO${NC} ] ==============================================="
    echo -e "[ ${BLUE}INFO${NC} ]              ${GREEN}Listing current podman processes${NC}"
    echo -e "[ ${BLUE}INFO${NC} ] ==============================================="

    # Execute podman ps and check for errors
    if ! output=$(podman ps 2>&1); then
        echo -e "[ ${RED}ERROR${NC} ] Failed to execute 'podman ps':"
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
        echo "Usage: $0 <list>"
        exit 1
    fi

    local action=$1

    case $action in
        list)
            list_processes
            ;;
        *)
            echo "Unknown action: $action"
            exit 1
            ;;
    esac
}

main "$@"
