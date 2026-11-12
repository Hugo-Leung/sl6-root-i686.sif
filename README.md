# SL6 32-Bit CERN ROOT Apptainer Container

An Apptainer container based on `fermilab/fnal_wn_sl6` (`x86_64`) from Docker Hub for running 32-bit CERN ROOT and the Beam DAQ binary.

## Overview

* **32-Bit ROOT**: The Beam DAQ binary is a 32-bit Boost archive, so ROOT in the container is compiled as 32-bit. It is installed in `/opt/root`, and is included in the environment.
* **Scientific Linux 6 (`x86_64`) Base**: This container uses `fermilab/fnal_wn_sl6` (`x86_64`) from Docker Hub as the base image because SL6 was the last version to ship `i686` RPMs alongside the 64-bit OS.
* **Archived RPM Repositories**: Some RPM repositories (such as EPEL) have been patched to point to their respective archives.
* **64-Bit Host Inode Support**: Due to running on a 64-bit host environment, ROOT and FreeType were recompiled manually so they can handle 64-bit inodes.

## Building with Apptainer

### ROOT Source Tarball
If the ROOT source tarball does not already exist in your current working directory, it will be downloaded to the current working directory during the build.

### Build Command
```bash
apptainer build sl6-root-i686.sif sl6-root-i686.def
```

## Running the Container
When running the container, use `-e` (or a similar clean-environment option) to avoid leaking host environment variables or using any host software. Be sure to bind your data folder (using `-B` / `--bind`) if needed:

```bash
apptainer shell -e -B /path/to/data:/path/to/data sl6-root-i686.sif
```


## Compiling Downstream Binaries

When compiling other downstream binaries inside this environment, you will likely need to pass the following compiler flags to handle 64-bit host inodes:

```text
-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE
```

