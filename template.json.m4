changequote(<!,!>)
{
    "push": {
      "name": "",
      "vcs": true
    },
    "variables": {
        "ATLAS_USERNAME": "esyscmd(printf $ATLAS_USERNAME)",
        "ATLAS_NAME": "esyscmd(printf $ATLAS_NAME)",
        "B2D_VERSION": "esyscmd(printf $B2D_VERSION)",
        "B2D_ISO_FILE": "esyscmd(printf $B2D_ISO_FILE)",
        "B2D_ISO_CHECKSUM": "esyscmd(printf $B2D_ISO_CHECKSUM)"
    },
    "builders": [{
        "type": "virtualbox-iso",
        "vboxmanage": [
            ["modifyvm","{{.Name}}","--memory","1536"],
            ["modifyvm","{{.Name}}","--nictype1","virtio"]
        ],
        "disk_size": "120000",
        "iso_url": "{{user `B2D_ISO_FILE`}}",
        "iso_checksum_type": "md5",
        "iso_checksum": "{{user `B2D_ISO_CHECKSUM`}}",
        "boot_wait": "5s",
        "headless": "true",
        "guest_additions_mode": "attach",
        "guest_os_type": "Linux_64",
        "ssh_username": "docker",
        "ssh_password": "tcuser",
        "shutdown_command": "sudo poweroff"
    }],
    "provisioners": [
        {
            "type": "file",
            "source": "{{user `B2D_ISO_FILE`}}",
            "destination": "/tmp/boot2docker-vagrant.iso"
        },
        {
            "type": "shell",
            "execute_command": "{{ .Vars }} sudo -E -H -S sh '{{ .Path }}'",
            "environment_vars": [
              "B2D_ISO_URL={{user `B2D_ISO_URL`}}"
            ],
            "scripts": [
                "./scripts/build-custom-iso.sh",
                "./scripts/b2d-provision.sh"
            ]
        }
    ],
    "post-processors": [{
        "type": "vagrant",
        "vagrantfile_template": "vagrantfile.tpl",
        "output": "boot2docker_{{.Provider}}.box"
    },
    {
        "type": "atlas",
        "only": ["virtualbox-iso"],
        "artifact": "{{user `ATLAS_USERNAME`}}/{{user `ATLAS_NAME`}}",
        "artifact_type": "vagrant.box",
        "metadata": {
            "provider": "virtualbox",
            "version": "{{user `B2D_VERSION`}}"
        }
    }]
}
