from sphinxcontrib.spelling.filters import Filter

class ContractionFilter(Filter):
    """Ignore contractions like isn't, wasn't, etc."""
    ignore = set([
        "isn't", "wasn't", "can't", "won't", "doesn't",
        "didn't", "aren't", "weren't", "hasn't", "haven't",
    ])

    def _skip(self, word):
        return word.lower() in self.ignore
