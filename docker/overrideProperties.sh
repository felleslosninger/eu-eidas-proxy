#!/bin/bash
# ${ENVIRONMENT} must be configured in idporten-cd in container.env

# copy eidas.xml
ENV_SOURCE=/etc/config/profiles/${ENVIRONMENT}/
DEFAULT_CONFIG=/etc/config/
if [ -d "$ENV_SOURCE" ]; then
    echo "Copy files for environment ${ENVIRONMENT} from $ENV_SOURCE" && ls -lt "$ENV_SOURCE"
    cp -r "$ENV_SOURCE"** "$DEFAULT_CONFIG"
fi
