docker_build('sites-liveview', '.', 
    target='dev',
    build_args={'MIX_ENV': 'dev'}
)

# use dev config
k8s_yaml(kustomize('./kustomize/dev'))

# port forward to localhost:4000
k8s_resource('dev-sites', port_forwards=4000)