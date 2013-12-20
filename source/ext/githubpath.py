def setup(app):
    app.add_config_value('github_branch', 'master', 'html')
    app.add_config_value('github_repo', 'https://github.com/OpenNebula/docs', 'html')

    app.connect('html-page-context', create_github_source)

def create_github_source(app, docname, templatename, ctx, doctree):
    branch      = app.builder.env.config['github_branch']
    github_repo = app.builder.env.config['github_repo']

    url = "%s/blob/%s/source/%s.rst" % (github_repo, branch, docname)

    ctx['github_source'] = url
