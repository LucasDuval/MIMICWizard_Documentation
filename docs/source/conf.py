# Configuration file for the Sphinx documentation builder.

# -- Project information

project = 'MIMIC Wizard'
copyright = 'GNU GPLv3'
author = 'Lucas DUVAL'

language = 'en'
release = '0.6'
version = '0.6.0'

# -- General configuration

extensions = [
    'sphinx.ext.duration',
    'sphinx.ext.doctest',
    'sphinx.ext.autodoc',
    'sphinx.ext.intersphinx',
]


intersphinx_disabled_domains = ['std']

master_doc = 'contents'
source_suffix = '.rst'

templates_path = ['_templates']
html_static_path = ['assets']
html_css_files = ['custom.css']

html_sidebars = {
   '**': ['globaltoc.html', 'sourcelink.html', 'searchbox.html'],
}

# -- Options for HTML output

html_theme = 'sphinx_rtd_theme'

# -- Options for EPUB output
epub_show_urls = 'footnote'

numfig = True