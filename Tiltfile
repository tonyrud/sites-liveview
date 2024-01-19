docker_build('sites-liveview', '.', 
    target='dev',
    build_args={'MIX_ENV': 'dev'},
    dockerfile='Dockerfile.multi'
)

k8s_yaml(kustomize('./kustomize/dev'))

k8s_resource('dev-sites', port_forwards=4000)