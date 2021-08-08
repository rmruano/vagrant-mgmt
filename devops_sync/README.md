## Devops synchronized folder 

This folder is synchronized as `/devops` within the VM to serve as main path to perform the devops work. 

- It will be the base work path for the Theia IDE (available on http://localhost:8000)
- It should contain the projects, the scripts & the data that should be maintained between VM reprovisions.
- Everything on it is .gitignored on the vagrant-mgmt repo but you can clone git repos and work with them as usual.
- Provision the content according your organization requirements. 
- Be careful with deletions, data is synchronized with your host and will be lost if you delete it in your VM.
- If a `bootstrap.sh` file is found, it will be run automatically at the VM provisioning stage (as `vagrant` user)

Sample bootstrap.sh:
````
#!/bin/bash
cd /devops
if [ ! -e .bootstrap_ok ]; then	
    git clone https://github.com/rmruano/terraform-samples
    touch .bootstrap_ok
fi
````