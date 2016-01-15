======
crowd
======

Formulas to set up and configure Atlassian Crowd and CrowdID

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``crowd``
----------

Installs the crowd standalone tarball and starts the service.  Configures
~crowd/dbconfig.xml, but assumes database creation handled by another forumla
(e.g. postgres-formula).  

``crowd.proxy``
------------------

Enables a basic Apache proxy for crowd. This currently requires https://github.com/simonwgill/apacheproxy-formula
