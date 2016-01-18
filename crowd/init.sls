{%- from 'crowd/conf/settings.sls' import crowd with context %}

include:
  - sun-java
  - sun-java.env
#  - apache.vhosts.standard
#  - apache.mod_proxy_http

crowd:
  group:
    - present
  user:
    - present
    - groups:
      - crowd
    - require:
      - group: crowd

### APPLICATION INSTALL ###
unpack-crowd-tarball:
  archive.extracted:
    - name: {{ crowd.prefix }}
    - source: {{ crowd.source_url }}/atlassian-crowd-{{ crowd.version }}.tar.gz
    - source_hash: {{ salt['pillar.get']('crowd:source_hash', '') }}
    - archive_format: tar
    - user: crowd 
    - tar_options: z
    - if_missing: {{ crowd.prefix }}/atlassian-crowd-{{ crowd.version }}
    - runas: crowd
    - keep: True
    - require:
      - module: crowd-stop
      - file: crowd-init-script
    - listen_in:
      - module: crowd-restart

fix-crowd-filesystem-permissions:
  file.directory:
    - user: crowd
    - recurse:
      - user
    - names:
      - {{ crowd.prefix }}/atlassian-crowd-{{ crowd.version }}
      - {{ crowd.home }}
      - {{ crowd.log_root }}
    - watch:
      - archive: unpack-crowd-tarball

create-crowd-symlink:
  file.symlink:
    - name: {{ crowd.prefix }}/crowd
    - target: {{ crowd.prefix }}/atlassian-crowd-{{ crowd.version }}
    - user: crowd
    - watch:
      - archive: unpack-crowd-tarball

create-crowd-logs-symlink:
  file.symlink:
    - name: {{ crowd.prefix }}/crowd/logs
    - target: {{ crowd.log_root }}
    - user: crowd
    - backupname: {{ crowd.prefix }}/crowd/old_logs
    - watch:
      - archive: unpack-crowd-tarball

### SERVICE ###
crowd-service:
  service.running:
    - name: crowd
    - enable: True
    - require:
      - archive: unpack-crowd-tarball
      - file: crowd-init-script

# used to trigger restarts by other states
crowd-restart:
  module.wait:
    - name: service.restart
    - m_name: crowd

crowd-stop:
  module.wait:
    - name: service.stop
    - m_name: crowd  

crowd-init-script:
  file.managed:
    - name: '/etc/init.d/crowd'
    - source: salt://crowd/templates/crowd.init.tmpl
    - user: root
    - group: root
    - mode: 0755
    - template: jinja
    - context:
      crowd: {{ crowd|json }}

### FILES ###

{{ crowd.prefix }}/crowd/crowd-webapp/WEB-INF/classes/crowd-init.properties:
  file.managed:
    - source: salt://crowd/templates/crowd-init.properties.tmpl
    - user: {{ crowd.user }}
    - template: jinja
    - listen_in:
      - module: crowd-restart

{{ crowd.prefix }}/crowd/apache-tomcat/bin/setenv.sh:
  file.managed:
    - source: salt://crowd/templates/setenv.sh.tmpl
    - user: {{ crowd.user }}
    - template: jinja
    - mode: 0644
    - listen_in:
      - module: crowd-restart

# {{ crowd.prefix }}/crowd/conf/logging.properties:
#   file.managed:
#     - source: salt://crowd/templates/logging.properties.tmpl
#     - user: {{ crowd.user }}
#     - template: jinja
#     - watch_in:
#       - module: crowd-restart

