
```
How to uninstall Red Hat Ansible Controller(Ansible Automation Platform 2.x)?
https://access.redhat.com/solutions/6733721
```
```hosts.ini
[controller]
ec2-3-92-193-110.compute-1.amazonaws.com	 	3.92.193.110	

[prive_hub]
ec2-54-91-148-80.compute-1.amazonaws.com	 	54.91.148.80

[hop]
ec2-34-207-160-175.compute-1.amazonaws.com	 	34.207.160.175

[exec]
ec2-18-234-142-229.compute-1.amazonaws.com	 	18.234.142.229
ec2-3-86-140-200.compute-1.amazonaws.com	 	3.86.140.200
ec2-54-172-66-137.compute-1.amazonaws.com	 	54.172.66.137

[eda]
ec2-54-175-2-79.compute-1.amazonaws.com

```
```.ssh/id_rsa.pub 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCnk/R6WL/QM+i0YQQphIFMXCz5MG9puBtn3otzYGf86nkzRBmEYp6d4TxPZg/FhX2KDBpiejLsHD92rpR1U+6A1gmFMzMeb+Fowi7Y6h8r8xh3sRpXt2N/ahzOdv6CRy2wdE0vqMojxpB7ZV1HDQ9Rlnc7aM3v3BGcTvZpYipX32kpmrBlSu5Rqm8qZO/6apdaBwwqzCSDoXdn1jZQCfQfmHpf24Dy65R/rtj0BULoXXA5fdhGdcXcpGBs3FeUY0be1XnewTBwAZG35am11OGJKcUIYSiexJRttvL5v3/8Ko2f38Q1NDZgX8iioZrg1p2rQvklv7kIbpD/LfiOdk+SdaWBW/aTdHauUp3824RnHTRNlzpK8Pka1JrmekcjG8DIwuerihos9i7c9HubVDok8e2pstS8OCC5FHgtaIiT4xNEAAiMLEknChaL7xGVQetMKhPriYGYKV8CfZVTp8rUOzaNGdWYlDFwEKoJh0HhaxnwwwN4scILQQp+HRJeoeIirZlPpLVF8CKv5ufnWJTwLX7pXrI4GHHWjhtPVxQPTl2FwEVz/qm3nfuNIXJ+o1w+wKSIY6orvZ/j9fZCeclOrmPCxdHV+jiebevPrABcRZ5bHZ4WrRh83nLEcnMAALDEFqpj+zysfu6WeXiFEYTyMZlnj+eMC0Ybu5EmgP42BQ== root@ip-172-31-86-34.ec2.internal
```


```bash
# dnf install -y scap-security-guide openscap-scanner openscap ansible tmux

# ansible -b -m ping -i hosts.ini all
# ansible -b -m command -a "subscription-manager unregister" -i hosts.ini all
# ansible -b -m command -a "subscription-manager register --username=USERNAME_CHANGEME --password=PASSWORD_CHANGE_ME" -i hosts.ini all

# ansible -b -m command -a "yum clean all" -i hosts.ini all

# ansible -b -m command -a "subscription-manager config --rhsm.full_refresh_on_yum=1 --rhsm.manage_repos=1" -i hosts.ini all

# ansible -b -m command -a "subscription-manager attach --pool=2c942a3e84c901ff0184df9f93f45758" -i hosts.ini all
# ansible -b -m command -a "subscription-manager repos --disable=*" -i hosts.ini all
# ansible -b -m command -a "subscription-manager repos --enable=ansible-automation-platform-2.3-for-rhel-8-x86_64-rpms --enable=rhel-8-for-x86_64-baseos-rpms --enable=rhel-8-for-x86_64-appstream-rpms" -i hosts.ini all
# ansible -b -m command -a "dnf install -y --enablerepo=ansible-automation-platform-2.4-for-rhel-8-x86_64-rpms ansible-automation-platform-installer*" -i hosts.ini all


# RHEL8
# curl -o ansible-automation-platform-setup-bundle-2.4-1-x86_64.tar.gz 'https://access.cdn.redhat.com/content/origin/files/sha256/95/95f5bfc00f65be7785098bf196f21e76c3eca54f95b203ba8655c80676f665a7/ansible-automation-platform-setup-bundle-2.4-1-x86_64.tar.gz?user=006987baac62b7e3735e5ac27489d048&_auth_=1688590427_e56a0ea5b737a10167cffab318d062ae'
# curl -o ansible-automation-platform-setup-bundle-2.3-2.2.tar.gz      'https://access.cdn.redhat.com/content/origin/files/sha256/d6/d615652db2623dd18256d2f67940406c8d5e8d5fc17368a3c396f7c187fd45fe/ansible-automation-platform-setup-bundle-2.3-2.2.tar.gz?user=ae09fb9ff03f3b14862e9cf6ccb59baa&_auth_=1689034034_cd609fab72dd121150d34388b7f02940'

# mkdir ansible
# mv ansible-automation-platform-setup-bundle-2.3-2.2.tar.gz ansible/.
# cd ansible
# tar zxvf ansible-automation-platform-setup-bundle-2.3-2.2.tar.gz

# ansible -b -m command -a "dnf install -y insights-client rhc" -i hosts.ini all
# ansible -b -m command -a "rhc connect" -i hosts.ini all
# ansible -b -m command -a "insights-client --register" -i hosts.ini all
# ansible -b -m command -a "insights-client --checkin" -i hosts.ini all
```

```inventory
# Automation Controller Nodes
# There are two valid node_types that can be assigned for this group.
# A node_type=control implies that the node will only be able to run
# project and inventory updates, but not regular jobs.
# A node_type=hybrid will have the ability to run everything.
# If you do not define the node_type, it defaults to hybrid.
#
# control.example node_type=control
# hybrid.example  node_type=hybrid
# hybrid2.example <- this will default to hybrid
[automationcontroller]
ec2-3-92-193-110.compute-1.amazonaws.com node_type=hybrid ansible_connection=local

[automationcontroller:vars]
peers=execution_nodes


# Execution Nodes
# There are two valid node_types that can be assigned for this group.
# A node_type=hop implies that the node will forward jobs to an execution node.
# A node_type=execution implies that the node will be able to run jobs.
# If you do not define the node_type, it defaults to execution.
#
# hop.example        node_type=hop
# execution.example  node_type=execution
# execution2.example <- this will default to execution
[execution_nodes]
ec2-54-91-148-80.compute-1.amazonaws.com   node_type=hop

ec2-18-234-142-229.compute-1.amazonaws.com node_type=execution
ec2-3-86-140-200.compute-1.amazonaws.com   node_type=execution
ec2-54-172-66-137.compute-1.amazonaws.com  node_type=execution

[automationhub]
ec2-54-91-148-80.compute-1.amazonaws.com

[automationcatalog]

[database]
ec2-3-92-193-110.compute-1.amazonaws.com


# Single Sign-On
# If sso_redirect_host is set, that will be used for application to connect to
# SSO for authentication. This must be reachable from client machines.
#
# ssohost.example sso_redirect_host=<host/ip>
[sso]

[all:vars]
admin_password='R3dH4t@123!'

pg_host='ec2-3-92-193-110.compute-1.amazonaws.com'
pg_port=5432

pg_database='awx'
pg_username='awx'
pg_password='R3dH4t@123!'
pg_sslmode='prefer'  # set to 'verify-full' for client-side enforced SSL

# Execution Environment Configuration
#

# Credentials for container registry to pull execution environment images from,
# registry_username and registry_password are required for registry.redhat.io
#
# When deployed with Automation Hub:
# - The installer will push execution environment images to Automation Hub and
#   configure Automation Controller to pull images from the Hub registry.
# - To make Hub to be the only registry to pull execution environment images from,
#   set 'ee_from_hub_only' to True. This is set to True by default when bundle
#   installer is used.

registry_url='registry.redhat.io'
registry_username='REGISTRY_USERNAME_CHANGE_ME'
registry_password='REGISTRY_PASSWORD_CHANGE_ME'
# ee_from_hub_only =


# Receptor Configuration
#
receptor_listener_port=27199

# Automation Hub Configuration
#

automationhub_admin_password='R3dH4t@123!'

automationhub_pg_host='ec2-3-92-193-110.compute-1.amazonaws.com'
automationhub_pg_port=5432

automationhub_pg_database='automationhub'
automationhub_pg_username='automationhub'
automationhub_pg_password='R3dH4t@123!'
automationhub_pg_sslmode='prefer'

# Set to True to overwrite existing admin password.
#
# automationhub_force_change_admin_password = False

# The main automation hub URL that clients will connect to (e.g. https://<load balancer host>).
# If not specified, the first node in the [automationhub] group will be used when needed.
#
# automationhub_main_url = ''

# By default when one uploads collections to Automation Hub
# an admin needs to approve it before it is made available
# to the users. If one wants to disable the content approval
# flow, the following setting should be set to False.
#
# automationhub_require_content_approval = True

# At import time collections can go through a series of checks.
# Behaviour is driven by galaxy-importer.cfg configuration.
# Example are ansible-doc, ansible-lint, flake8, ...
#
# The following parameter allow one to drive this configuration.
# This variable is expected to be a dictionary.
#
# automationhub_importer_settings = None

# The default install will deploy a TLS enabled Automation Hub.
# If for some reason this is not the behavior wanted one can
# disable TLS enabled deployment.
#
# automationhub_disable_https = False

# The default install will deploy a TLS enabled Automation Hub.
# Unless specified otherwise the HSTS web-security policy mechanism
# will be enabled. This setting allows one to disable it if need be.
#
# automationhub_disable_hsts = False

# The default install will not create a signing service. If set to true
# a signing service will be created.

# automationhub_create_default_collection_signing_service = False
# automationhub_create_default_container_signing_service = False

# If a signing service is enabled, one must provide a signing script and a key.
# Note: these MUST be absolute paths.

# automationhub_collection_signing_service_key = /absolute/path/to/key/to/sign
# automationhub_collection_signing_service_script =  /absolute/path/to/script/that/signs

# automationhub_container_signing_service_key = /absolute/path/to/key/to/sign
# automationhub_container_signing_service_script =  /absolute/path/to/script/that/signs

# If a collection signing service is enabled, collections won't be signed automatically by default.
# The following parameter will have them signed by default.
#
# automationhub_auto_sign_collections = False

# If upgrading from Ansible Automation Platform 2.0 or earlier, you must either:
# - provide an existing Automation Hub token as 'automationhub_api_token' or
# - set 'generate_automationhub_token' to True to generate a new token
# Generating a new token will invalidate the existing token.
#
# automationhub_api_token=''
# generate_automationhub_token=

# Automation Hub LDAP configuration
#
# For Automation Hub to connect to LDAP directly the following variables
# need to be configured. The list of all possible configuration can be found here:
# https://django-auth-ldap.readthedocs.io/en/latest/reference.html#settings
# Extra parameters will need to be passed through an ansible ldap_extra_settings dictionary.
#
# automationhub_authentication_backend = "ldap"
#
# automationhub_ldap_server_uri = "ldap://ldap:10389"
# automationhub_ldap_bind_dn = "cn=admin,dc=ansible,dc=com"
# automationhub_ldap_bind_password = "GoodNewsEveryone"
# automationhub_ldap_user_search_base_dn = "ou=people,dc=ansible,dc=com"
# automationhub_ldap_group_search_base_dn = "ou=people,dc=ansible,dc=com"

# By default, bundle installer seeds certified and validated collections into
# Automation Hub. Set to False to disable the seeding.
#
# automationhub_seed_collections = True


# Automation Services Catalog Configuration
#

automationcatalog_pg_host='ec2-3-92-193-110.compute-1.amazonaws.com'
automationcatalog_pg_port=5432

automationcatalog_pg_database='automationservicescatalog'
automationcatalog_pg_username='automationservicescatalog'
automationcatalog_pg_password='R3dH4t@123!'

# For an alternative front end url needed for SSO configuration with Automation
# Services Catalog, provide the URL.

# automationcatalog_main_url=''

# Automation Services Catalog requires either Controller to be installed
# with Automation Controller or a URL to an active and routable Controller
# server must be provided with the below variable.

# automation_controller_main_url=''

# Automation Services Catalog requires SSO and SSO admin credentials for
# authentication. SSO admin credentials are also required for set Catalog specific
# roles needed for the application. If SSO is not provided in inventory for
# configuration, then the SSO host needs to be defined with the below.

# sso_host=''

# Automation Services Catalog will generate a token, but a specific OAuth token
# can be provided with the following. Note that the variable
# "automation_controller_main_url" must be assigned a routable address from
# the Automation Service Catalog host.

# automationcatalog_controller_token=''

# Automation Controller credentials can also be provided to generate a token
# for a working Controller environment. Note that the variable
# "automation_controller_main_url" must be assigned a routable address from
# the Automation Service Catalog host. Generating a token will also create
# an application in Automation Controller for stateful management of the token.

# automationcatalog_controller_username=''
# automationcatalog_controller_password=''
automationcatalog_controller_username='admin'
automationcatalog_controller_password='R3dH4t@123!'

# The default install will enable analytics collection for Services Catalog.
# Set to False to disable.

# automationcatalog_enable_analytics_collection = True
automationcatalog_enable_analytics_collection = True

# The default install will use RHSM certificate to send Services Catalog analytics
# collection data. To use username and password instead, provide the
# console.redhat.com credentials.

# insights_username=''
# insights_password=''
insights_username='INSIGHTS_USERNAME_CHANGE_ME'
insights_password='INSIGHTS_PASSWORD_CHANGE_ME'

# If connection to Automation Controller requires SSL validation to be off,
# provide the variable below. By default, the value is true.
#
# automationcatalog_controller_verify_ssl=False

# The default install will deploy a TLS enabled Automation Hub.
# If for some reason this is not the behavior wanted one can
# disable TLS enabled deployment.
#
# automationcatalog_disable_https = False

# The default install will deploy a TLS enabled Automation Hub.
# Unless specified otherwise the HSTS web-security policy mechanism
# will be enabled. This setting allows one to disable it if need be.
#
# automationcatalog_disable_hsts = False

# SSL-related variables

# If set, this will install a custom CA certificate to the system trust store.
# custom_ca_cert=/path/to/ca.crt

# Certificate and key to install in nginx for the web UI and API
# web_server_ssl_cert=/path/to/tower.cert
# web_server_ssl_key=/path/to/tower.key

# Certificate and key to install in Automation Hub node
# automationhub_ssl_cert=/path/to/automationhub.cert
# automationhub_ssl_key=/path/to/automationhub.key

# Server-side SSL settings for PostgreSQL (when we are installing it).
# postgres_use_ssl=False
# postgres_ssl_cert=/path/to/pgsql.crt
# postgres_ssl_key=/path/to/pgsql.key

# Keystore file to install in SSO node
# sso_custom_keystore_file='/path/to/sso.jks'

# The default install will deploy SSO with sso_use_https=True
# Keystore password is required for https enabled SSO
sso_keystore_password='R3dH4t@123!'

# Single-Sign-On configuration
sso_console_admin_password='R3dH4t@123!'

# The default install will register node to the Red Hat Insights Service
# if the node is registered with Subscription Manager. Set to False to disable.
# enable_insights_collection = True
enable_insights_collection = True
#EOF
```

```setup.sh
# tmux capture-pane -pS - > ansible-install-v1.log
# ./setup.sh
```

```inventory
# cat inventory | egrep -v "^#|^$"
[automationcontroller]
ec2-3-92-193-110.compute-1.amazonaws.com node_type=hybrid ansible_connection=local

[automationcontroller:vars]
peers=execution_nodes

[execution_nodes]
ec2-54-91-148-80.compute-1.amazonaws.com   node_type=hop

ec2-18-234-142-229.compute-1.amazonaws.com node_type=execution
ec2-3-86-140-200.compute-1.amazonaws.com   node_type=execution
ec2-54-172-66-137.compute-1.amazonaws.com  node_type=execution

[automationhub]
ec2-54-91-148-80.compute-1.amazonaws.com

[automationcatalog]

[database]
ec2-3-92-193-110.compute-1.amazonaws.com

[sso]

[all:vars]
admin_password='R3dH4t@123!'
pg_host='ec2-3-92-193-110.compute-1.amazonaws.com'
pg_port=5432
pg_database='awx'
pg_username='awx'
pg_password='R3dH4t@123!'
pg_sslmode='prefer'  # set to 'verify-full' for client-side enforced SSL

registry_url='registry.redhat.io'
registry_username='REGISTRY_USERNAME_CHANGE_ME'
registry_password='REGISTRY_PASSWORD_CHANGE_ME'

receptor_listener_port=27199
automationhub_admin_password='R3dH4t@123!'

automationhub_pg_host='ec2-3-92-193-110.compute-1.amazonaws.com'
automationhub_pg_port=5432
automationhub_pg_database='automationhub'
automationhub_pg_username='automationhub'
automationhub_pg_password='R3dH4t@123!'
automationhub_pg_sslmode='prefer'

automationcatalog_pg_host='ec2-3-92-193-110.compute-1.amazonaws.com'
automationcatalog_pg_port=5432
automationcatalog_pg_database='automationservicescatalog'
automationcatalog_pg_username='automationservicescatalog'
automationcatalog_pg_password='R3dH4t@123!'

automationcatalog_controller_username='admin'
automationcatalog_controller_password='R3dH4t@123!'

automationcatalog_enable_analytics_collection = True

insights_username='INSIGHTS_USERNAME_CHANGE_ME'
insights_password='INSIGHTS_PASSWORD_CHANGE_ME'

sso_keystore_password='R3dH4t@123!'
sso_console_admin_password='R3dH4t@123!'

enable_insights_collection = True

```
