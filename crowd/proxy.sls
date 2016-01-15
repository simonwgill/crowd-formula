{%- from 'crowd/conf/settings.sls' import crowd with context %}

crowd-vhost:
  file.managed:
    - name: /etc/httpd/sites-available/crowd.conf
    - source: salt://crowd/templates/crowd-vhost.tmpl
    - template: jinja
    - require:
      - file: sites-available

enable-crowd-site:
  file.symlink:
    - name: /etc/httpd/sites-enabled/crowd.conf
    - target: /etc/httpd/sites-available/crowd.conf
    - listen_in:
      - module: apache-reload
    - require:
      - file: crowd-vhost
