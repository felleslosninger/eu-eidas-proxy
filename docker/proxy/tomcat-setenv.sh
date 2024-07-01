
# Bouncycastle java security provider
export JAVA_OPTS="$JAVA_OPTS -Djava.security.properties=/opt/java/openjdk/conf/security/java_bc.security"
export JAVA_OPTS="$JAVA_OPTS --module-path /usr/local/lib/bcprov-jdk18on-1.78.jar"
export JAVA_OPTS="$JAVA_OPTS --add-modules org.bouncycastle.provider"

# Luna java security provider for HSM
## also needs #security.provider.14=com.safenetinc.luna.provider.LunaProvider in java_bc_security
#export JAVA_OPTS="$JAVA_OPTS --module-path /var/usrlocal/luna/jsp/LunaProvider.jar"
#export JAVA_OPTS="$JAVA_OPTS --add-modules Luna"

# eidas config
export EIDAS_PROXY_CONFIG_REPOSITORY="/etc/config/eidas-proxy/"
export CLASSPATH=$CLASSPATH:$EIDAS_PROXY_CONFIG_REPOSITORY
# Auditlogs config: -DLOG_HOME="<myDirectoryName>"
export LOG_HOME="/usr/local/tomcat/eidas/logs"

#HSM
export PATH="/var/usrlocal/luna/bin/64:$PATH"
