# Changelog

## 0.0.7

* Switched to do a dry-run by default. The user will now have to use `-n` to actually delete resources.

## 0.0.6

* Add support to preserve resources in a config file. By default the script will read from `.ibmcloud-nuke`.
* Override the config file path by using `-c`.

## 0.0.5

* Add a `-d` flag for dry runs
* Delete Satellite locations
* Delete VPCs

## 0.0.4

* Delete API keys

## 0.0.3

* Delete cloud function namespaces

## 0.0.2

* Fixed error when service name included a space

## 0.0.1

* Initial release
