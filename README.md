# Base Box Creation

A ruby script used to help in creating a macOS virtual machine box. You can also use it to install a new update to the VM before creating the box.

## Setup

Running Base Box Creation requires setup of the following:
1. Installation of [rbenv](https://github.com/rbenv/rbenv).
2. Installation of [vagrant](https://developer.hashicorp.com/vagrant/docs/installation)
3. Installation of [parallels-desktop](https://www.parallels.com/products/desktop/) 
2. Configuration of `config.conf` file.

## Running
If you are unable to have install gems, you can simply run the manual program which will take you through all the steps of creating a base box manually.

    ruby manual_creation.rb

Otherwise, you can execute the script by running the following in the `base_box_creation` main directory. 

    ruby automate_creation.rb

### config.conf

Configuration file used by Automate Creation program. All the fields need to be filled in order for Automate Creation to create a VM, connect to it, update and install a package and package it into a base box. 

Create the `config.conf` file inside the `base_box_creation` directory containing all of the data below with their specific values in a vertical format. 

For example: 

```
vm_box = 'mac-1.0'
vm_box_url = '/Users/dsusilo/.chef/Base_Box_Creation/mac-1.0.box'
..
..
```

#### `vm_box`
The name of the VM vagrant box to be used to create the VM.

#### `vm_box_url`
The url or path to the VM box in order to add it to vagrant.

#### `vm_box_version`
Version of the VM box to be used. 

#### `linked_clone`
A flag to determine whether the VM created will be a full clone or not of the VM Box. 

#### `base_box_name`
The name of the base box to be created.

#### `update_name`
The name of the update to install unto the VM before it is packaged into a base box. 

### Dependencies

Install the following gems using `gem install`:
 * parseconfig
 * net-ssh
 * ed25519 (>= 1.2, < 2.0)
 * bcrypt_pbkdf (>= 1.0, < 2.0)