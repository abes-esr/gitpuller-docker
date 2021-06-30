# gitpuller-docker

A docker container in charge of continuously git pull a folder.

Why?

- to keep up to date a PHP source code in a web server
- to keep up to date a static web site in a web server


## Usage

```
# clone a git repository (change it to your git repo!)
git clone https://github.com/facebook/docusaurus.git my-gitclonned-folder/

# run the gitpuller container
docker run -d \
  -v $(pwd)/my-gitclonned-folder/:/folder-to-git-pull/ \
  abesesr/gitpuller-docker:1.0.0
```

## Parameters

- `/folder-to-git-pull/` : this is the internal folder where git pull will be executed continuously, this is a mandatory parameter, you have to mount the wanted git clonned folder on it as a volume
- SSH keys needed for git pull, see example here: https://github.com/abes-esr/gitpuller-docker/blob/main/docker-compose.yml#L11
