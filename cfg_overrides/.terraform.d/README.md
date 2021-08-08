Put all your overrides here, the content will be copied into `/cfg_defaults`

Data in this folder will be copied to `/home/vagrant/.terraform.d/`

Sample credentials.tfrc.json
```
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR_TERRAFORM_CLOUD_TOKEN"
    }
  }
}
```