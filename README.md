# ibmcloud-nuke

The goal of this project is to delete all resources in your IBM Cloud account, _with great conviction and impunity_. 😠 (To save you from charges) 💰

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
main.sh [-d] [-c <path-to-config-file>]
```

* `-d`: Add this flag to make the command have a dry-run. No resources will be deleted.
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
   ./main.sh -d
   ```

   Delete all resources (will skip over any resorces found in `.ibmcloud-nuke`):

   ```bash
   ./main.sh
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
