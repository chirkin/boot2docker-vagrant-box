# boot2docker-py Vagrant Box

## Introduction

Forked from [dduportal/boot2docker-vagrant-box](https://github.com/dduportal/boot2docker-vagrant-box), thanks Damien!
Some features were taken from
[AlbanMontaigu/boot2docker-vagrant-box](https://github.com/AlbanMontaigu/boot2docker-vagrant-box), thanks Alban!

This fork have only Virtualbox provider. But additionally contains python package. And ready to be configured with Ansible.

This repository contains the scripts necessary to create a Vagrant compatible [boot2docker](https://github.com/boot2docker/boot2docker) box.

## Usage

The box is available on [Hashicrop's Atlas](https://atlas.hashicorp.com/chirkin/boxes/boot2docker-py).

## Network considerations

By default, we use a NAT interfaces, which have its ports 2375 and 2376 (Docker IANA ports) forwarded to the loopback (localhost) of your physical host.

## Building the Box

If you want to recreate the box, rather than using the binary, then you can use the scripts and Packer template within this repository to do so in seconds.

To build the box, first install the following prerequisites:

  * [Make as workflow engine](http://www.gnu.org/software/make/)
  * [Packer as vagrant basebox builder](http://www.packer.io) (at least version 0.7.5)
  * [VirtualBox](http://www.virtualbox.org) (at least version 4.3.28)
  * [curl for downloading things](http://curl.haxx.se)
  * [bats for testing](https://github.com/sstephenson/bats)

Then run this command to build the box for VirtualBox provider:

```
make virtualbox
```
