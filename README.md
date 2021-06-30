# gitpuller-docker

A docker container in charge of continuously git pull a folder (every minutes).

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
  abesesr/gitpuller-docker:1.0.1
```

## Parameters

- `/folder-to-git-pull/` : this is the internal folder where git pull will be executed continuously, this is a mandatory parameter, you have to mount the wanted git clonned folder on it as a volume
- SSH keys needed for git pull, see example here: https://github.com/abes-esr/gitpuller-docker/blob/main/docker-compose.yml#L11


## Developement

### Generating a new version

To generate a new version, just run theses commandes (and change the "-patch" option in the NEXT_VERSION line if necessary):
```
curl https://raw.githubusercontent.com/fmahnke/shell-semver/master/increment_version.sh > increment_version.sh
chmod +x ./increment_version.sh
CURRENT_VERSION=$(git tag | tail -1)
NEXT_VERSION=$(./increment_version.sh -patch $CURRENT_VERSION) # -patch, -minor or -major
sed -i "s#gitpuller-docker:$CURRENT_VERSION#gitpuller-docker:$NEXT_VERSION#g" README.md docker-compose.yml
git commit README.md docker-compose.yml -m "Version $NEXT_VERSION" 
git tag $NEXT_VERSION
git push && git push --tags
```

