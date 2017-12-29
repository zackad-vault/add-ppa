# Add-PPA

Shell (bash) script as replacement for `add-apt-repository` to add PPA (Personal Package Archive) into source repository.

## Disclaimer

Original script retrieved from https://blog.anantshri.info/content/uploads/2010/09/add-apt-repository.sh.txt

This is a modified version to accommodate for various version of ubuntu and it's varian.

## Installation

- Download the script

```shell
# Using curl
curl -o add-ppa https://github.com/zackad/add-ppa/raw/master/add-ppa.sh

wget -O add-ppa https://github.com/zackad/add-ppa/raw/master/add-ppa.sh
```

- Add executable permission

```shell
chmod +x add-ppa
```

- Move into one of your $PATH directory

```shell
# Move into path inside user home directory
mv add-ppa ~/.local/bin/

# Or move it into global bin directory so other user can access it
sudo mv add-ppa /usr/local/bin/
```
