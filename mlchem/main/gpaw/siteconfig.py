"""
This is a customized gpaw siteconfig for conda-forge
User provided customizations.

Here one changes the default arguments for compiling _gpaw.so.

Here are all the lists that can be modified:

* libraries
  List of libraries to link: -l<lib1> -l<lib2> ...
* library_dirs
  Library search directories: -L<dir1> -L<dir2> ...
* include_dirs
  Header search directories: -I<dir1> -I<dir2> ...
* extra_link_args
  Arguments forwarded directly to linker
* extra_compile_args
  Arguments forwarded directly to compiler
* runtime_library_dirs
  Runtime library search directories: -Wl,-rpath=<dir1> -Wl,-rpath=<dir2> ...
* extra_objects
* define_macros

To override use the form:

    libraries = ['somelib', 'otherlib']

To append use the form

    libraries += ['somelib', 'otherlib']
"""

# flake8: noqa

# compiler = 'gcc'
# platform_id = ''

# MPI:
mpi = True
if mpi:
    compiler = "mpicc"

# FFTW3
fftw = True
if fftw:
    libraries += ["fftw3"]

# ScaLAPACK (version 2.0.1+ required):
scalapack = True
if scalapack:
    libraries += ["scalapack"]

# Elpa not used
if 0:
    elpa = True
    elpadir = "/home/user/elpa"
    libraries += ["elpa"]
    library_dirs += ["{}/lib".format(elpadir)]
    runtime_library_dirs += ["{}/lib".format(elpadir)]
    include_dirs += ["{}/include/elpa-xxxx.xx.xxx".format(elpadir)]


# - libxc dynamic linking (requires rpath or setting LD_LIBRARY_PATH at runtime):
if 1:
    if "xc" not in libraries:
        libraries.append("xc")


# libvdwxc:
if 1:
    libvdwxc = True
    libraries += ["vdwxc"]

# blas + lapack (conda-forge managed openblas)
if 1:
    libraries += ["blas", "lapack"]

# Extra flags
extra_compile_args += ["-fopenmp", "-fopenmp-simd"]
extra_link_args += ["-fopenmp", "-fopenmp-simd"]

# Extra macros
define_macros += [("GPAW_ASYNC", "1")]
define_macros += [("GPAW_MPI2", "1")]
define_macros += [("GPAW_NO_UNDERSCORE_CSCALAPACK", "1")]
define_macros += [("GPAW_NO_UNDERSCORE_CBLACS", "1")]
