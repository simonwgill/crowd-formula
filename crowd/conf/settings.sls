{% set p  = salt['pillar.get']('crowd', {}) %}
{% set g  = salt['grains.get']('crowd', {}) %}


{%- set default_version      = '5.9.4' %}
{%- set default_prefix       = '/opt' %}
{%- set default_source_url   = 'https://downloads.atlassian.com/software/crowd/downloads' %}
{%- set default_log_root     = '/var/log/crowd' %}
{%- set default_crowd_user    = 'crowd' %}
{%- set default_db_server    = 'localhost' %}
{%- set default_db_name      = 'crowd' %}
{%- set default_db_username  = 'crowd' %}
{%- set default_db_password  = 'crowd' %}
{%- set default_jvm_Xms      = '384m' %}
{%- set default_jvm_Xmx      = '768m' %}
{%- set default_jvm_MaxPermSize = '384m' %}
{%- set default_webserver_fqdn = 'crowd.example.com' %}

{%- set version        = g.get('version', p.get('version', default_version)) %}
{%- set source_url     = g.get('source_url', p.get('source_url', default_source_url)) %}
{%- set log_root       = g.get('log_root', p.get('log_root', default_log_root)) %}
{%- set prefix         = g.get('prefix', p.get('prefix', default_prefix)) %}
{%- set crowd_user      = g.get('user', p.get('user', default_crowd_user)) %}
{%- set db_server      = g.get('db_server', p.get('db_server', default_db_server)) %}
{%- set db_name        = g.get('db_name', p.get('db_name', default_db_name)) %}
{%- set db_username    = g.get('db_username', p.get('db_username', default_db_username)) %}
{%- set db_password    = g.get('db_password', p.get('db_password', default_db_password)) %}
{%- set jvm_Xms        = g.get('jvm_Xms', p.get('jvm_Xms', default_jvm_Xms)) %}
{%- set jvm_Xmx        = g.get('jvm_Xmx', p.get('jvm_Xmx', default_jvm_Xmx)) %}
{%- set jvm_MaxPermSize = g.get('jvm_MaxPermSize', p.get('jvm_MaxPermSize', default_jvm_MaxPermSize)) %}
{%- set webserver_fqdn = g.get('webserver_fqdn', p.get('webserver_fqdn', default_webserver_fqdn)) %}

{%- set crowd_home      = salt['pillar.get']('users:%s:home' % crowd_user, '/home/crowd') %}

{%- set crowd = {} %}
{%- do crowd.update( { 'version'        : version,
                      'source_url'     : source_url,
                      'log_root'       : log_root,
                      'home'           : crowd_home,
                      'prefix'         : prefix,
                      'user'           : crowd_user,
                      'db_server'      : db_server,
                      'db_name'        : db_name,
                      'db_username'    : db_username,
                      'db_password'    : db_password,
                      'jvm_Xms'        : jvm_Xms,
                      'jvm_Xmx'        : jvm_Xmx,
                      'jvm_MaxPermSize': jvm_MaxPermSize,
                      'webserver_fqdn' : webserver_fqdn,
                  }) %}

