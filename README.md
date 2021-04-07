# ibmcloud-nuke

Remove all resources from an IBM Cloud account.

## Caution!

Be aware that *IBM Cloud Nuke* is a very destructive tool, be very careful while using it. Otherwise you might delete production data. **Do NOT run this application on an IBM Cloud account where you cannot afford to lose all resources.**

Some safety precautions have been put in place.

1. By default *IBM Cloud Nuke* only lists all nukeable resources. You need to add `-n` flag to actually delete resources.
1. A config file can be used to specify names and IDs of resources to skip over.

The project itself is just a shell script that is required be run by an authenticated IBM Cloud user. The shell script will find and delete the following resources:

* Kubernetes and OpenShift clusters
* Container Registry namespaces
* Applications (Cloud Foundry or Stater Kits)
* Services (like Cloudant, Watson services, Object Storage (and their underlying buckets), etc)
* Classic Baremetal servers
* Classic Virtual servers
* Code Engine projects (and their underlying jobs)
* Cloud Functions Namespaces (and their underlying actions)
* API keys (excluding ones requires for managing Kubernetes clusters)
* Satellite locations
* Gen2 VPCs

## CLI options

```bash
main.sh [-n] [-c <path-to-config-file>]
```

* `-n`: Specify "no dry run". Resources will be deleted.
* `-c`: Specify a config file for IDs/names of resources to be saved from deletion. The tool will automatically look for a file called `ibmcloud-nuke` in the local directory.

## Using the CLI

1. Clone the repo.

   ```bash
   git clone
   ```

1. Log into IBM Cloud.

   ```bash
   ibmcloud login
   ```

1. Run the CLI.

   Perform a dry run:

   ```bash
   ./main.sh
   ```

   Delete all resources (will skip over any resorces found in `.ibmcloud-nuke`):

   ```bash
   ./main.sh -n
   ```

   Delete all resources but skip resources list in `myfile.txt`:

   ```bash
   ./main.sh -c myfile.txt
   ```

## TODO

1. The project needs support for deleting the following types of resources:

   * [Schematics Workspaces](https://cloud.ibm.com/docs/schematics?topic=schematics-schematics-cli-reference#schematics-workspace-delete)
   * [Developer Tools (toolchains)](https://cloud.ibm.com/docs/cli?topic=cli-idt-cli#toolchains)
   * [Reclamations](https://cloud.ibm.com/docs/account?topic=account-resource-reclamation)
   * VMware solutions
