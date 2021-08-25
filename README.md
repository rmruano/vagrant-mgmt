# vagrant-mgmt 

Virtual machine for devops management

- Provision the vm with: `vagrant up` 
- You can provide a custom DEVOPS_FOLDER path:
	Windows: `set DEVOPS_FOLDER=../ && vagrant up`
	Linux: `DEVOPS_FOLDER=../; vagrant up`
- SSH into the vm with: `vagrant ssh`

## How to provision the VM with your custom overrides

- `cfg_defaults` & `cfg_overrides` folders are merged before copying the contents into `/home/vagrant`
- `cfg_defaults` should not be touched at all and only used as reference, it has sample configurations.
- `cfg_overrides` should contain your sensitive data. All files there are gitignored to prevent leaks. Use the sample files in `cfg_defaults` and customize them accordingly into `cfg_overrides`. 
- `devops_sync` folder is synchronized with the VM and is available at `/devops` ([more info](devops_sync/README.md))

## Synched folder
Due poor performance of VirtualBox synched folder on Windows systems, this VM will access the shared folder through NFS
- On Windows systems install the NFS plugin: `vagrant plugin install vagrant-winnfsd`

## Before provisioning checklist (inside the HOST):

- Chdir into `cfg_overrides` to create your custom files (you can use the sample files in `cfg_defaults`)
- Put the public and private keys you require into `.ssh/`
- If you need to authorize other keys into your VM, add the public keys to `cfg_overrides/home/authorized_keys`.
- Create your `.aws/config` and `.aws/credentials` files, for convenience, you can optionally put here an id_rsa/id_rsa.pub key pair that you can use when creating instances. If the key pair doesn't exist it will be automatically created for you.
- Create your terraform cloud `.terraform.d/credentias.tfrc.json`.
- Put your `.gitconfig` and `.git-credentials` file in `/config/.gitconfig`
- Put in `home` any other files you may need to be copied to `/home/vagrant/` 
- If you provide a `devops_sync/bootstrap.sh` file, it will be executed automatically ([more info](devops_sync/README.md)) Use it to provision your devops projects and customize the VM as required.

## After provisioning (inside the VM):

- The VM mounts the parent folder as `/devops` and keeps it synchronized, be careful, these are the files form your host machine. ([more info](devops_sync/README.md))
- Theia-IDE is available at http://localhost:8000 settings, plugins and extensions are stored in `/devops/.theia`
- `tfswitch` allows you to change between terraform versions, it will create a symlink to the chosen terraform version on `/home/vagrant/bin`, that path is automatically added to the vagrant user path env var.