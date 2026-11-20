# SL6 32-Bit CERN ROOT Apptainer Container

An Apptainer container based on `fermilab/fnal-wn-sl6` (`x86_64`) from Docker
Hub for running 32-bit CERN ROOT and the Beam DAQ binary.

## Overview

* **32-Bit Analysis Dependencies**: The Beam DAQ output files use Boost's
  non-portable native binary archive, so reading them requires a compatible
  32-bit Boost. The analysis executable also links against ROOT. ROOT and the
  executable must be 32-bit too. Boost is installed via `yum`; ROOT is built in
  `/opt/root` and added to the environment through `%environment`.
* **Scientific Linux 6 (`x86_64`) Base**: This container uses
  `fermilab/fnal-wn-sl6` (`x86_64`) from Docker Hub to provide compatibility
  with its legacy 32-bit dependencies.
* **Archived RPM Repositories**: Some RPM repositories (such as EPEL) have been
  patched to point to their respective archives.
* **64-Bit File Offset Support**: ROOT is built with large-file support flags,
  with patches applied to its built-in FreeType, libASImage, PCRE, LZMA, and
  LZ4 components. See the [compilation flags table](#compiling-downstream-binaries)
  for details.

## Security Warning

This container uses end-of-life Scientific Linux 6 and legacy software that no
longer receives security updates. Its CA bundle is not refreshed, so TLS clients
inside the container that verify certificates may reject newer certificate
chains. The build bypasses TLS certificate verification for the package-install
Yum transaction only; this does not update trusted certificates or fix TLS
protocol/cipher incompatibilities, and package downloads remain vulnerable to
interception. The ROOT source tarball is downloaded on the build host without a
checksum or signature verification step. These limitations leave supply-chain
risks.

Use this image only where its legacy environment is required. Do not rely on it
for security-sensitive workloads or expose it to untrusted networks; prefer a
supported OS and verified package sources whenever possible. A container does
not eliminate the security risks of outdated software.

## Building with Apptainer

### ROOT Source Tarball
If the ROOT source tarball does not already exist in your current working
directory, it will be downloaded there during the build.

### Build Command
```bash
apptainer build sl6-root-i686.sif sl6-root-i686.def
```

## Running the Container
Use `-e` (`--cleanenv`) to reduce interference from host environment variables.
This is especially useful when an RHEL 9 or another modern host exports variables
that might conflict with the Scientific Linux 6 environment.
Use `--env DISPLAY="$DISPLAY"` to forward the display setting.
Bind the data folder with `-B` / `--bind` if needed:

```bash
apptainer shell -e --env DISPLAY="$DISPLAY" -B /path/to/data sl6-root-i686.sif
```

For stronger separation from the host filesystem, use `-C` (`--containall`). It
limits host mounts and inherited environment variables; however, it does not
isolate the container from the host kernel or make the end-of-life software
secure. Bind every directory required by the application explicitly,
such as the data and Beam DAQ directories for the analysis,
and the X11 socket and authority file needed for X11 forwarding:

```bash
apptainer shell -C --bind /tmp/.X11-unix --bind "${HOME}/.Xauthority" -B /path/to/data -B /path/to/BeamDAQ --env DISPLAY="$DISPLAY" sl6-root-i686.sif
```

## Compiling Downstream Binaries

When compiling downstream binaries that link against the included 32-bit ROOT,
you will likely need these flags to support large files and compile for 32-bit:

```text
-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -m32
```

| Flag | Purpose | Make variable |
| --- | --- | --- |
| `-D_FILE_OFFSET_BITS=64` | Uses 64-bit offsets for standard file APIs. | `CPPFLAGS` |
| `-D_LARGEFILE_SOURCE` | Exposes large-file interfaces. | `CPPFLAGS` |
| `-D_LARGEFILE64_SOURCE` | Exposes explicit `*64` interfaces. | `CPPFLAGS` |
| `-m32` | Compiles and links for 32-bit. | `CFLAGS`, `CXXFLAGS`, `LDFLAGS` |

