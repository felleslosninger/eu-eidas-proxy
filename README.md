# eidas-proxy
Norwegian generic eIDAS-proxy build from eIDAS source.

See these documents in https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eIDAS-Node+version+2.7.1:
* eIDAS-Node National IdP and SP Integration Guide v2.7.pdf
* eIDAS-Node Installation Quick Start Guide v2.7.pdf
* eIDAS-Node Installation and Configuration Guide v2.7.1.pdf


### Run eidas-proxy as docker-compose on your machine for local testing

Add the following to your /etc/hosts file:
```
# eIDAS local dev
127.0.0.1 eidas-proxy
```

Start docker containers:
```
docker-compose up --build 
```

Test by checking if metadata-endepoint is responding: eidas-proxy:8082/ServiceMetadata
```

### Run eidas-proxy in test/production environment
Systest: proxy.eidasnode.dev/ServiceMetadata
Test: proxy.test.eidasnode.no/ServiceMetadata
Prod: proxy.eidasnode.no/ServiceMetadata