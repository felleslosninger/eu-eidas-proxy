#!/bin/bash
# ${ENVIRONMENT} must be configured in idporten-cd in container.env

# copy eidas.xml
ENV_SOURCE=/etc/config/profiles/${ENVIRONMENT}/eidas.xml
OVERRIDE_FILE=/etc/config/eidas.xml
if [ -f "$ENV_SOURCE" ]; then
    if [ -f "$OVERRIDE_FILE" ]; then
        rm -rf "$OVERRIDE_FILE"
    fi
    mv "$ENV_SOURCE" "$OVERRIDE_FILE"
fi

# copy whitelist metadata file
ENV_SOURCE=/etc/config/profiles/${ENVIRONMENT}/metadata/MetadataFetcher_Service.properties
OVERRIDE_FILE=/etc/config/metadata/MetadataFetcher_Service.properties
if [ -f "$ENV_SOURCE" ]; then
    if [ -f "$OVERRIDE_FILE" ]; then
        rm -rf "$OVERRIDE_FILE"
    fi
    mv "$ENV_SOURCE" "$OVERRIDE_FILE"
fi
