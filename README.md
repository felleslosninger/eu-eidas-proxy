# eidas-generic-proxy
Norwegian generic eIDAS-proxy build from eIDAS source.

See these documents in https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eIDAS-Node+version+2.7.1:
* eIDAS-Node National IdP and SP Integration Guide v2.7.pdf
* eIDAS-Node Installation Quick Start Guide v2.7.pdf
* eIDAS-Node Installation and Configuration Guide v2.7.1.pdf


### Run eidas-generic-proxy as docker-compose on your machine for local testing

Add the following to your /etc/hosts file:
```
# eIDAS local dev
127.0.0.1 eu-eidas-proxy
127.0.0.1 eidas-generic-proxy
```

Start docker containers:
```
docker-compose up --build 
```

### Run eidas-generic-proxy in test/production environment
Systest: eu-eidas-proxy.idporten.dev , but will be moved to proxy.eidasnode.dev soon.