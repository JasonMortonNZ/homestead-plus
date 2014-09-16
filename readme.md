# Homestead Plus

Homestead Plus - builds upon the base Laravel Homestead setup, by adding additional features such as:

* Provisioning MySQL and PostgreSQL database schemas.
* Updating composer and global npm packages (bower, gulp etc)
* Allowing for custom commands to be run on 'vagrant up' such as 'sudo apt-get update && sudo apt-get dist-upgrade'
* Allows to customing of machine hostname
* Customisation of port forwarding numbers

The reason for creating this repository is the need for extra customisation over and above what Laravel Homestead currently offers.

# Installation

The installation process is almost identical to the Laravel homestead setup.

**Note:** You must have both VirtualBox and Vagrant installed.

1. Make sure you have the `laravel/homestead` box installed. You can do this by running the following command from your terminal/console: `vagrant box add laravel/homestead`.

2. Clone this repository: `git@github.com:JasonMortonNZ/homestead-plus.git homestead-plus`

3. Create an SSH key if you don't already have one: `ssh-keygen -t rsa -C "your@email.com"`

4. Customise the `Homestead.yaml` file to your liking and they run `vagrant up`

**Note: Don't forget to add each new site in your `Homestead.yaml` file to your hosts file.

E.g.:

** *nix & OSX** - edit your `/etc/hosts` file and add `127.0.0.1  project.app`
** Windows** - edit your `C:\Windows\System32\drivers\etc\hosts` file and add `127.0.0.1  project.app`

# Customisation

## Hostname

To change the hostname of the virtual machine simply edit the `hostname` setting in the `Homestead.yaml` file.

## Ports

To customise which ports you wish to forward to simply update the values for each entry under the `ports` setting in the `Homestead.yaml` file as necessary.

## Keys

This keys setting allows you to specify custom SSH keys you wish to import to the virtual machine during provisioning.

## Folders & Sites

Here you can map local folders to folders on the virtual machine, and then assigned each folder to a site. Check out the Homestead docs for an in depth explaination on how to do this: [Homestead docs](http://laravel.com/docs/homestead#installation-and-setup)

## Variables

You can add custom environment variables to your virtual machine by adding them to the `variables` setting in the `Homestead.yaml` file.

## Databases

To provision database schema's for either MySQL or PostgreSQL, simply add the schema name to the correct category under `databases` setting in the `Homestead.yaml`file.

## Commands

To have custom commands executed during the provisioning phase, simple add a new entry for each custom command under the `commands` setting in the `Homestead.yaml` file.

# Issues - how to help?

If you find any bugs, issues errors or believe we could add further useful functionality. Let us know via the github [issues page](https://github.com/JasonMortonNZ/homestead-plus/issues) for this project here - [https://github.com/JasonMortonNZ/homestead-plus/issues](https://github.com/JasonMortonNZ/homestead-plus/issues).

# Contributors

- Jason Morton : [Github](https://github.com/JasonMortonNZ) | [Twitter @JasonMortonNZ](https://twitter.com/jasonmortonnz)

# License

Homestead Plus - is open-sourced software licensed under the MIT license.

# Credits

This is a based on the official laravel home stead repository found [here](https://github.com/laravel/homestead).

The official Laravel local development environment. Info [is located here](http://laravel.com/docs/homestead?version=4.2).
