#!/bin/bash

pip install sphinx sphinx_rtd_theme sphinx-prompt sphinx_substitution_extensions pyyaml sphinxcontrib-spelling pyenchant

make spelling > spellcheck.log 2>&1

if grep -q "WARNING: Found" spellcheck.log; then
  echo "Spellcheck failed. Check the following:"
  grep "Spell check: " spellcheck.log
  exit 1
else
  echo "Spellcheck passed!"
fi
