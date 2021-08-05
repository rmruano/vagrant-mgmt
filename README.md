# vagrant-mgmt 

Virtual machine for devops management

- Provision the vm with: `vagrant up` 
- SSH into the vm with: `vagrant ssh`

Before provisioning:

- Put your public and private keys into `.ssh/`
- Create your `.aws/config` and `.aws/credentials` files. Howto: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

After provisioning:

- The VM mounts the parent folder as `/devops`
- Remember to paste your user token by running `terraform login`