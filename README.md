# ibmcloud-nuke

The goal of this project is to delete all resources in your IBM Cloud account, _with great conviction and impunity_. 😠 (To save you from charges) 💰

The project itself is just a shell script that is required be run by an authenticated IBM Cloud user. The shell script will find and delete the following resources:

* Kubernetes and OpenShift clusters
* Container Registry namespaces
* Applications (Cloud Foundry or Stater Kits)
* Services (like Cloudant, Watson Discovery, etc)
* Baremetal servers
* Virtual servers
* Code Engine projects (and their underlying jobs)

## TODO

1. Support for a list of exemptions. Ideally this would be in the form of a config file that has a bunch of ids/names that will be saved from deletion.

2. A global `dry-run` flag that instead of deleting artifacts it prints which ones will be deleted.

3. The project still needs support for deleting the following types of resources

   * Cloud Functions namespaces/actions/triggers
   * Schematics
   * Satellite locations
   * Developer Tools (toolchains)
   * VMware solutions
