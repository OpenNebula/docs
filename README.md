OpenNebula Documentation
========================

This is the official repository of OpenNebula's Documentation. This
documentation is live at:
[http://docs.opennebula.org](http://docs.opennebula.org).

You are encouraged to fork this repo and send us pull requests!

To create issues to report changes and requests, please use the [OpenNebula main repository](https://github.com/OpenNebula/one), with label Documentation.

Building
--------

Install dependencies: ``pip install sphinx sphinx_rtd_theme sphinx-prompt pyyaml``.

Build the documentation by running ``make html``.
[More information](http://sphinx-doc.org/).

Translations
------------

### Bootstrap a new language

    $ make gettext
    $ sphinx-intl update -c source/conf.py -p build/locale -l <lang>

### Translate

Translate your po files under ``./locale/<lang>/LC_MESSAGES/``.

### Publish the translation

    $ sphinx-intl build -c source/conf.py
    $ make -e SPHINXOPTS="-D language='<lang>'" html

### More Info

Follow [this guide](http://sphinx-doc.org/intl.html) for more information.
