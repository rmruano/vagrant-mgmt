# vagrant-mgmt 

Virtual machine for devops management

- Provision the vm with: `vagrant up` 
- SSH into the vm with: `vagrant ssh`

## Before provisioning (inside the HOST):

- Put your public and private keys into `.ssh/`
- Create your `.aws/config` and `.aws/credentials` files. About configuration & credentials: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
````
[default]
region=aws-region
output=json
````
````
[default]
aws_access_key_id=MY_AWS_ACCESS_KEY
aws_secret_access_key=MY_AWS_SECRET
````
- (optional) Create your terraform cloud `credentias.tfrc.json` file and put it in the `.terraform.d` directory
````
{
  "credentials": {
    "app.terraform.io": {
      "token": "----token----"
    }
  }
}
````
- (optional) Put any aditional authorized keys in /config/authorized_keys
- (optional) Put your .gitconfig file in /config/.gitconfig
````
[user]
	name = myname
	email = myemail@host.com
[core]
	autocrlf = true
````
- (optional) Add your git credentials to /config/.git-credentials in the format:
````
https://user:password-or-token@host.com
````
About git credentials: https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage

## After provisioning (inside the VM):

- The VM mounts the parent folder as `/devops`
- (optional) If no terraform credentials were provided use `terraform login` and paste your token to create it
- Theia-IDE is available at http://localhost:8000 settings, plugins and extensions are stored in /devops/.theia