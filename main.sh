# echo "Install IBM Cloud CLI"
# curl -fsSL https://clis.cloud.ibm.com/install/linux | sh

# ibmcloud plugin install -f code-engine
# ibmcloud plugin install -f container-registry
# ibmcloud plugin install -f container-service
# ibmcloud plugin install -f cloud-functions
# ibmcloud plugin install -f infrastructure-service
# ibmcloud plugin install -f schematics
# ibmcloud plugin install -f sdk-gen

# ibmcloud target -g default

# clusters
echo "Deleting clusters: "
ibmcloud ks clusters -q | tail -n+2 | while read -r name rest_of_cmd ; do
    echo "${name}"
    # if not dry run
        # ibmcloud ks cluster rm -f -c ${name}
done

# namespaces
echo "Deleting namespaces: "
ibmcloud cr namespaces | tail -n+4 | while read -r name rest_of_cmd ; do
    echo "${name}"
    # if not dry run
        # ibmcloud cr namespace-rm -f ${name}
done

# apps
echo "Deleting applications: "
ibmcloud dev list | tail -n+8 | while read -r name rest_of_cmd ; do
    echo "${name}"
    # if not dry run
        # ibmcloud dev delete -f ${name}
done

# services - use awk here as the service name can include spaces
echo "Deleting services: "
ibmcloud resource service-instances | tail -n+4 | awk -F '  +' '{print $1}' | while read -r name; do
    echo "${name}"
    # if not dry run
        # ibmcloud resource service-instance-delete -f --recursive "${name}"
done

# baremetal
echo "Deleting Classic baremetal: "
ibmcloud sl hardware list | grep -v 'kube-' | tail -n+2 | while read -r id rest_of_cmd ; do
    echo "${id}"
    # if not dry run
        # ibmcloud sl hardware cancel -f ${id}
done

# VMs
echo "Deleting Classic VMs: "
ibmcloud sl vs list | grep -v 'kube-' | tail -n+2 | while read -r id rest_of_cmd ; do
    echo "${id}"
    # if not dry run
        # ibmcloud sl vs cancel -f ${id}
done

# code engine
echo "Deleting code engine projects: "
ibmcloud ce project list | tail -n+5 | while read -r name rest_of_cmd ; do
    echo "${name}"
    # if not dry run
        # ibmcloud ce project delete -f --name ${name}
done

# functions - use awk because namespaces can have spaces
echo "Deleting functions: "
ibmcloud fn namespace list | tail -n+3 | awk -F '  +' '{print $1}' | while read -r name; do
    echo "${name}"
    # if not dry run
        # ibmcloud fn namespace delete "${name}"
done
