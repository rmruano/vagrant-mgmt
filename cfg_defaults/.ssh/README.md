Do not include your sensitive data here. Put it in `/cfg_overrides`. Both folders will be merged automatically.

Data in this folder will be copied to /home/vagrant/.ssh

*Do not put an `authorized_keys` file here, otherwise they will be overwritten by the file and you won't have access to the VM.

If you need to add custom authorized_keys, put them in a `/cfg_overrides/home/authorized_keys` file. The content will be added to the existing one.