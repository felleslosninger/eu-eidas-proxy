# eIDAS-proxy Configuration

Folder `config` contains the configuration files for the eIDAS-proxy.

## URLs
Placeholders to change:
* `EIDAS-PROXY-URL` - URL of this application (eidas-proxy) used in eidas.xml
* `IDPORTEN-PROXY-URL` - URL to eidas-idporten-proxy (SpecificProxyService) used in eidas.xml
* `DEMOLAND-CA-URL` - URL of the CA of the DEMOLAND country whitelisted in metadata/ folder. Also add foreign countries EidasNodeConnector to this list.
* `NO-EU-EIDAS-CONNECTOR-URL` - URL of Norway NO country whitelisted in metadata/ folder. Also add foreign countries EidasNodeConnector to this list.

NB: might be changed to reflect correct context-paths and api.

These must be altered in dockerfile or in config outside of K8 container.

## Keystores
TODO: replace with our versions, should use HMS in test/production.

