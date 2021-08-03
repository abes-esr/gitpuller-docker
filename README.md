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
  -e GIT_AS_UID=$(id -u) -e GIT_AS_GID=$(id -g) \
  -v $(pwd)/my-gitclonned-folder/:/folder-to-git-pull/ \
  abesesr/gitpuller-docker:1.1.0
```

## Parameters

- `GIT_AS_UID` : this is the linux user id (uid) to use to run the git pull on the `/folder-to-git-pull/` folder. This parameter is usefull if you do not want to change root permission on your git pulled repository (optional - default `0`)
- `GIT_AS_GID` : this is the linux group id (gid) to use to run the git pull on the `/folder-to-git-pull/` folder (optional - default `0`)
- `/folder-to-git-pull/` : this is the internal folder where git pull will be executed continuously, this is a mandatory parameter, you have to mount the wanted git clonned folder on it as a volume (mandatory)
- SSH keys needed for git pull, see example here: https://github.com/abes-esr/gitpuller-docker/blob/main/docker-compose.yml#L11 (optional)


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

