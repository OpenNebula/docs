OpenNebula Documentation
========================

![Make Html](https://github.com/OpenNebula/docs/actions/workflows/make_html.yml/badge.svg)

This is the official repository of OpenNebula's Documentation. This
documentation is live at:
[http://docs.opennebula.org](http://docs.opennebula.org).

You are encouraged to fork this repo and send us pull requests!

To create issues to report changes and requests, please use the [OpenNebula main repository](https://github.com/OpenNebula/one), with label Documentation.

Building
--------

`Graphviz <https://graphviz.org/>` is needed to compile the documentation.

Also the following Python dependencies:

``pip install sphinx sphinx_rtd_theme sphinx-prompt sphinx_substitution_extensions pyyaml``.

Build the documentation by running ``make html``.
[More information](http://sphinx-doc.org/).

Spell checking
-------------

`sphinxcontrib.spelling <https://sphinxcontrib-spelling.readthedocs.io/en/latest/index.html` is needed to run the spell checker.

Also, the following Python dependencies:
``pip install sphinxcontrib-spelling pyenchant``

And the `python3-enchant package`:
``sudo apt install python3-enchant``

If the spellchecker job fails for your branch, you can check the job log which will display the file + word that didn't pass the spell checker along with some suggestions.
Either you will have to correct the typo and push it again, or if it's a false positive, you can update the custom wordlist used at `source/ext/spellchecking/wordlists/opennebula.txt`

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
