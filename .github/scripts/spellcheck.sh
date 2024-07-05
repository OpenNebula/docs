#!/bin/bash

python -m venv venv

source venv/bin/activate

pip install sphinx sphinx_rtd_theme sphinx-prompt sphinx_substitution_extensions pyyaml sphinxcontrib-spelling pyenchant

make spelling SPHINXOPTS="-D spelling_word_list_filename=source/ext/spellchecking/wordlists/opennebula.txt" > spellcheck.log 2>&1

if [ -z "$(ls -A build/spellcheck)" ]; then
  echo "Spellcheck passed!"
else
  echo "Spellcheck failed. Log follows:"
  cat spellcheck.log
  exit 1
fi
