#!/bin/bash

# This script is **destructive** and will delete a lot of IBM
# Cloud resources. Use with caution!

# In order to use this script you must have installed the IBM
# Cloud CLI. If you need to do that run the following:
# curl -fsSL https://clis.cloud.ibm.com/install/linux | sh

# Once installed, this script uses several plugins, to
# install them run the following commands:
# ibmcloud plugin install -f code-engine
# ibmcloud plugin install -f container-registry
# ibmcloud plugin install -f container-service
# ibmcloud plugin install -f cloud-functions
# ibmcloud plugin install -f infrastructure-service
# ibmcloud plugin install -f schematics
# ibmcloud plugin install -f sdk-gen

# Lastly, you must be authenticated and have targetted
# a resource group. To do so, run the following:

# ibmcloud login
# ibmcloud target -g <resource-group>


usage() { echo "Usage: $0 [-n] [-c <config-file>]" 1>&2; exit 1; }

NO_DRY_RUN=''
CONFIG_FILE=''
while getopts "nc:" o; do
    case "${o}" in
        n)
            n=${OPTARG}
            NO_DRY_RUN=1
            ;;
        c)
            c=${OPTARG}
            CONFIG_FILE=$c
            ;;
        *)
            usage
            ;;
    esac
done

if [ "$CONFIG_FILE" ]; then
    echo "Attempting to use config file at location: $CONFIG_FILE"
    # Ensure config file exists
    if ! test -f ${CONFIG_FILE};
    then
        echo "specified config file ${CONFIG_FILE} not found"
        exit 1
    fi
else
    CONFIG_FILE='.ibmcloud-nuke'
    echo "Attempting to use config file at default location: $CONFIG_FILE"
fi

if [ "${NO_DRY_RUN}" ]; then
    echo "The (-n) flag was found. Will begin to delete all resources."
    NO_DRY_RUN=1
else
    echo "No (-n) flag found. Will NOT delete any resources."
    NO_DRY_RUN=0
fi

echo "================================="
echo "NO_DRY_RUN = ${NO_DRY_RUN}"
echo "CONFIG_FILE = ${CONFIG_FILE}"
echo "================================="

# Usage: get_or_create_user <name_or_id>
function check_config_file() {
    if test -f ${CONFIG_FILE} && grep -Fxq "${1}" ${CONFIG_FILE}
    then
        echo "skipping ${name} as it exists in ${CONFIG_FILE}"
        continue
    fi
}

# clusters
echo "================================="
echo "Clusters: "
echo "================================="
ibmcloud ks clusters -q | tail -n+2 | while read -r name rest_of_cmd ; do
    echo "${name}"
    check_config_file "${name}"

    if [ "${NO_DRY_RUN}" == 1 ]; then
        ibmcloud ks cluster rm -f -c ${name}
    fi

done

# namespaces
echo "================================="
echo "Container Registry (namespaces): "
echo "================================="
ibmcloud cr namespaces | tail -n+4 | while read -r name rest_of_cmd ; do
    echo "${name}"
    check_config_file "${name}"

    if [ "${NO_DRY_RUN}" == 1 ]; then
        ibmcloud cr namespace-rm -f ${name}
    fi
done

# apps
echo "================================="
echo "Applications: "
echo "================================="
ibmcloud dev list | tail -n+8 | while read -r name rest_of_cmd ; do
    echo "${name}"
    check_config_file "${name}"

    if [ "${NO_DRY_RUN}" == 1 ]; then
        ibmcloud dev delete -f ${name}
    fi
done

# services - use awk here as the service name can include spaces
echo "================================="
echo "Services: "
echo "================================="
ibmcloud resource service-instances | tail -n+4 | awk -F '  +' '{print $1}' | while read -r name; do
    echo "${name}"
    check_config_file "${name}"

    if [ "${NO_DRY_RUN}" == 1 ]; then
        ibmcloud resource service-instance-delete -f --recursive "${name}"
    fi
done

# baremetal
echo "================================="
echo "Classic Baremetal: "
echo "================================="
ibmcloud sl hardware list | grep -v 'kube-' | tail -n+2 | while read -r id rest_of_cmd ; do
    echo "${id}"
    check_config_file "${id}"

    if [ "${NO_DRY_RUN}" == 1 ]; then
        ibmcloud sl hardware cancel -f ${id}
    fi
done

# VMs
echo "================================="
echo "Classic VMs: "
echo "================================="
ibmcloud sl vs list | grep -v 'kube-' | tail -n+2 | while read -r id rest_of_cmd ; do
    echo "${id}"
    check_config_file "${id}"

    if [ "${NO_DRY_RUN}" == 1 ]; then
        ibmcloud sl vs cancel -f ${id}
    fi
done

# code engine
echo "================================="
echo "Code Engine (Projects):"
echo "================================="
ibmcloud ce project list | tail -n+5 | while read -r name rest_of_cmd ; do
    echo "${name}"
    check_config_file "${name}"

    if [ "${NO_DRY_RUN}" == 1 ]; then
        ibmcloud ce project delete -f --name ${name}
    fi
done

# functions - use awk because namespaces can have spaces
echo "================================="
echo "Cloud Functions (namespaces): "
echo "================================="
ibmcloud fn namespace list | tail -n+3 | awk -F '  +' '{print $1}' | while read -r name; do
    echo "${name}"
    check_config_file "${name}"

    if [ "${NO_DRY_RUN}" == 1 ]; then
        ibmcloud fn namespace delete "${name}"
    fi
done

# satellite locations (cannot contain a space)
echo "================================="
echo "Satellite locations: "
echo "================================="
ibmcloud sat location ls | tail -n+4 | while read -r name rest_of_cmd; do
    echo "${name}"
    check_config_file "${name}"

    if [ "${NO_DRY_RUN}" == 1 ]; then
        ibmcloud sat location rm --location "${name}" -f
    fi
done

# Virtual Private Clouds (VPCs) (cannot contain a space)
echo "================================="
echo "Virtual Private Clouds: "
echo "================================="
ibmcloud is vpcs | tail -n+3 | while read -r id rest_of_cmd; do
    echo "${id}"
    check_config_file "${id}"

    if [ "${NO_DRY_RUN}" == 1 ]; then
        ibmcloud is vpcd "${id}" -f
    fi
done

# api keys - skip the keys that say "Do not delete"
echo "================================="
echo "API Keys: "
echo "================================="
ibmcloud iam api-keys | tail -n+4 | grep -v 'Do not delete' | while read -r name rest_of_cmd; do
    echo "${name}"
    check_config_file "${name}"

    if [ "${NO_DRY_RUN}" == 1 ]; then
        ibmcloud iam api-key-delete ${name}
    fi
done
