# Patching BroadSign Player .DEB installation

To be able to install the BroadSign Player binary into the image we need to remove all traces of systemd first since Docker is not designed to work with systemd.

This can be done by running the following commands:

1. Extract the contents of the BroadSign Player .DEB file:

```
$ ar xf control-player-ubuntu.deb
```

2. After extracting the contents of `control-player-ubuntu.deb` you'll end up with 3 files:

```
control.tar.gz
data.tar.xz
debian-binary
```

All we want to touch is file `control.tar.gz`.

3. Extract the contents of `control.tar.gz` inside a directory and `cd` into it:

```
$ mkdir control-temp/
$ tar xvf control.tar.gz -C control-temp/ && cd -
```

4. Open file `postinst`, go to line `119`, and remove the following two lines of code:

```
sudo systemctl enable bsum-broadsign.service
sudo systemctl start bsum-broadsign.service
```

Save and exit.

5. Open file `prerm`, go to line `41`, and remove the following code completely:

```
if [ "${DISTRIBUTION}" == "ubuntu" -a "${VERSION}" -ge 16 ]; then
    sudo systemctl disable bsum-broadsign.service
else
    $BSUM_RC_SCRIPT stop &>/dev/null
fi
```

Save and exit.

6. Repack everything into a new `control.tar.gz`:

**Inside the folder, in which you extracted `control.tar.gz`, run the following commands:**

```
$ tar cvf ../control.tar.gz * && cd ..
```

This will create a new, modified version of `control.tar.gz`.

7. Repack everything into a new .DEB installer:

```
$ ar rcs control-player-ubuntu.deb ./debian-binary ./control.tar.gz ./data.tar.xz
```

That's it. All you have to do now is run `apt install -yq ./control-player-ubuntu.deb` inside your container and all dependencies will be installed accordingly as well as BroadSign Player.
