## Self-signed SSL certificates handling
##### Warning: No files are ignored. Make sure you don't commit sensitive files here.

A demo rootCA SSL cert is provided to generate custom SSL certs.
- You must install the root certificate `rootCA.pem` or `rootCA.crt` as a `Trusted Root Certification Authority`
- To install the root certificate use `certmgr` for windows or `keychain` for mac. 
- Usually import is automatically started on your OS by double-clicking the `rootCA.crt` file and selecting the `Trusted Root Certification Authorities` store. 

### Demo rootCA certificate valid for 10 years
##### rootCA.key passphrase: `rootCA`

You can generate your own and put it inside `/cfg_overrides/ssl/`
```
openssl genrsa -des3 -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 -out rootCA.pem
openssl x509 -outform der -in rootCA.pem -out rootCA.crt
```

### How to generate SSL certificates for your domains

Run `/home/vagrant/ssl/issue-cert-tool.sh` to automatically generate certificates for your local development domains, generated certificates will be stored at `/home/vagrant/ssl/certificates/`

*Remember to use the right root.ca.key passphrase*

Nice tutorial:
[https://www.freecodecamp.org/news/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec/](https://www.freecodecamp.org/news/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec/)

