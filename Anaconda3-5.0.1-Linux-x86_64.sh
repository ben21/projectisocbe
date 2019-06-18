#!/bin/sh
#
# NAME:  Anaconda3
# VER:   5.0.1
# PLAT:  linux-64
# BYTES:    550796553
# LINES: 697
# MD5:   1ee39d9d2fdcb20cf833c08ca4fca4fa

export OLD_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
unset LD_LIBRARY_PATH
if ! echo "$0" | grep '\.sh$' > /dev/null; then
    printf 'Please run using "bash" or "sh", but not "." or "source"\\n' >&2
    return 1
fi

# Determine RUNNING_SHELL; if SHELL is non-zero use that.
if [ -n "$SHELL" ]; then
    RUNNING_SHELL="$SHELL"
else
    if [ "$(uname)" = "Darwin" ]; then
        RUNNING_SHELL=/bin/bash
    else
        if [ -d /proc ] && [ -r /proc ] && [ -d /proc/$$ ] && [ -r /proc/$$ ] && [ -L /proc/$$/exe ] && [ -r /proc/$$/exe ]; then
            RUNNING_SHELL=$(readlink /proc/$$/exe)
        fi
        if [ -z "$RUNNING_SHELL" ] || [ ! -f "$RUNNING_SHELL" ]; then
            RUNNING_SHELL=$(ps -p $$ -o args= | sed 's|^-||')
            case "$RUNNING_SHELL" in
                */*)
                    ;;
                default)
                    RUNNING_SHELL=$(which "$RUNNING_SHELL")
                    ;;
            esac
        fi
    fi
fi

# Some final fallback locations
if [ -z "$RUNNING_SHELL" ] || [ ! -f "$RUNNING_SHELL" ]; then
    if [ -f /bin/bash ]; then
        RUNNING_SHELL=/bin/bash
    else
        if [ -f /bin/sh ]; then
            RUNNING_SHELL=/bin/sh
        fi
    fi
fi

if [ -z "$RUNNING_SHELL" ] || [ ! -f "$RUNNING_SHELL" ]; then
    printf 'Unable to determine your shell. Please set the SHELL env. var and re-run\\n' >&2
    exit 1
fi

THIS_DIR=$(DIRNAME=$(dirname "$0"); cd "$DIRNAME"; pwd)
THIS_FILE=$(basename "$0")
THIS_PATH="$THIS_DIR/$THIS_FILE"
PREFIX=$HOME/anaconda3
BATCH=0
FORCE=0
SKIP_SCRIPTS=0
TEST=0
USAGE="
usage: $0 [options]

Installs Anaconda3 5.0.1

-b           run install in batch mode (without manual intervention),
             it is expected the license terms are agreed upon
-f           no error if install prefix already exists
-h           print this help message and exit
-p PREFIX    install prefix, defaults to $PREFIX, must not contain spaces.
-s           skip running pre/post-link/install scripts
-u           update an existing installation
-t           run package tests after installation (may install conda-build)
"

if which getopt > /dev/null 2>&1; then
    OPTS=$(getopt bfhp:sut "$*" 2>/dev/null)
    if [ ! $? ]; then
        printf "%s\\n" "$USAGE"
        exit 2
    fi

    eval set -- "$OPTS"

    while true; do
        case "$1" in
            -h)
                printf "%s\\n" "$USAGE"
                exit 2
                ;;
            -b)
                BATCH=1
                shift
                ;;
            -f)
                FORCE=1
                shift
                ;;
            -p)
                PREFIX="$2"
                shift
                shift
                ;;
            -s)
                SKIP_SCRIPTS=1
                shift
                ;;
            -u)
                FORCE=1
                shift
                ;;
            -t)
                TEST=1
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                printf "ERROR: did not recognize option '%s', please try -h\\n" "$1"
                exit 1
                ;;
        esac
    done
else
    while getopts "bfhp:sut" x; do
        case "$x" in
            h)
                printf "%s\\n" "$USAGE"
                exit 2
            ;;
            b)
                BATCH=1
                ;;
            f)
                FORCE=1
                ;;
            p)
                PREFIX="$OPTARG"
                ;;
            s)
                SKIP_SCRIPTS=1
                ;;
            u)
                FORCE=1
                ;;
            t)
                TEST=1
                ;;
            ?)
                printf "ERROR: did not recognize option '%s', please try -h\\n" "$x"
                exit 1
                ;;
        esac
    done
fi

if ! bzip2 --help >/dev/null 2>&1; then
    printf "WARNING: bzip2 does not appear to be installed this may cause problems below\\n" >&2
fi

# verify the size of the installer
if ! wc -c "$THIS_PATH" | grep    550796553 >/dev/null; then
    printf "ERROR: size of %s should be    550796553 bytes\\n" "$THIS_FILE" >&2
    exit 1
fi

if [ "$BATCH" = "0" ] # interactive mode
then
    if [ "$(uname -m)" != "x86_64" ]; then
        printf "WARNING:\\n"
        printf "    Your operating system appears not to be 64-bit, but you are trying to\\n"
        printf "    install a 64-bit version of Anaconda3.\\n"
        printf "    Are sure you want to continue the installation? [yes|no]\\n"
        printf "[no] >>> "
        read -r ans
        if [ "$ans" != "yes" ] && [ "$ans" != "Yes" ] && [ "$ans" != "YES" ] && \
           [ "$ans" != "y" ]   && [ "$ans" != "Y" ]
        then
            printf "Aborting installation\\n"
            exit 2
        fi
    fi
    printf "\\n"
    printf "Welcome to Anaconda3 5.0.1\\n"
    printf "\\n"
    printf "In order to continue the installation process, please review the license\\n"
    printf "agreement.\\n"
    printf "Please, press ENTER to continue\\n"
    printf ">>> "
    read -r dummy
    pager="cat"
    if command -v "more" > /dev/null 2>&1; then
      pager="more"
    fi
    "$pager" <<EOF
===================================
Anaconda End User License Agreement
===================================

Copyright 2015, Anaconda, Inc.

All rights reserved under the 3-clause BSD License:

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
  * Neither the name of Continuum Analytics, Inc. (dba Anaconda, Inc.) ("Continuum") nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL CONTINUUM BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


Notice of Third Party Software Licenses
=======================================

Anaconda contains open source software packages from third parties. These are available on an "as is" basis and subject to their individual license agreements. These licenses are available in Anaconda or at https://docs.anaconda.com/anaconda/packages/pkg-docs . Any binary packages of these third party tools you obtain via Anaconda are subject to their individual licenses as well as the Anaconda license. Continuum reserves the right to change which third party tools are provided in Anaconda.

In particular, Anaconda contains re-distributable, run-time, shared-library files from the Intel(TM) Math Kernel Library ("MKL binaries"). You are specifically authorized to use the MKL binaries with your installation of Anaconda. You are also authorized to redistribute the MKL binaries with Anaconda or in the conda package that contains them. Use and redistribution of the MKL binaries are subject to the licensing terms located at https://software.intel.com/en-us/license/intel-simplified-software-license. If needed, instructions for removing the MKL binaries after installation of Anaconda are available at http://www.anaconda.com.

Anaconda also contains cuDNN software binaries from NVIDIA Corporation ("cuDNN binaries"). You are specifically authorized to use the cuDNN binaries with your installation of Anaconda. You are also authorized to redistribute the cuDNN binaries with an Anaconda package that contains them. If needed, instructions for removing the cuDNN binaries after installation of Anaconda are available at http://www.anaconda.com.


Cryptography Notice
===================

This distribution includes cryptographic software. The country in which you currently reside may have restrictions on the import, possession, use, and/or re-export to another country, of encryption software. BEFORE using any encryption software, please check your country's laws, regulations and policies concerning the import, possession, or use, and re-export of encryption software, to see if this is permitted. See the Wassenaar Arrangement <http://www.wassenaar.org/> for more information.

Continuum has self-classified this software as Export Commodity Control Number (ECCN) 5D002.C.1, which includes information security software using or performing cryptographic functions with asymmetric algorithms. The form and manner of this distribution makes it eligible for export under the License Exception ENC Technology Software Unrestricted (TSU) exception (see the BIS Export Administration Regulations, Section 740.13) for both object code and source code. In addition, the Intel(TM) Math Kernel Library contained in Continuum's software is classified by Intel(TM) as ECCN 5D992b with no license required for export to non-embargoed countries.

The following packages are included in this distribution that relate to cryptography:

openssl
    The OpenSSL Project is a collaborative effort to develop a robust, commercial-grade, full-featured, and Open Source toolkit implementing the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols as well as a full-strength general purpose cryptography library.

pycrypto
    A collection of both secure hash functions (such as SHA256 and RIPEMD160), and various encryption algorithms (AES, DES, RSA, ElGamal, etc.).

pyopenssl
    A thin Python wrapper around (a subset of) the OpenSSL library.

kerberos (krb5, non-Windows platforms)
    A network authentication protocol designed to provide strong authentication for client/server applications by using secret-key cryptography.

cryptography
    A Python library which exposes cryptographic recipes and primitives.

EOF
    printf "\\n"
    printf "Do you accept the license terms? [yes|no]\\n"
    printf "[no] >>> "
    read -r ans
    while [ "$ans" != "yes" ] && [ "$ans" != "Yes" ] && [ "$ans" != "YES" ] && \
          [ "$ans" != "no" ]  && [ "$ans" != "No" ]  && [ "$ans" != "NO" ]
    do
        printf "Please answer 'yes' or 'no':'\\n"
        printf ">>> "
        read -r ans
    done
    if [ "$ans" != "yes" ] && [ "$ans" != "Yes" ] && [ "$ans" != "YES" ]
    then
        printf "The license agreement wasn't approved, aborting installation.\\n"
        exit 2
    fi
    printf "\\n"
    printf "Anaconda3 will now be installed into this location:\\n"
    printf "%s\\n" "$PREFIX"
    printf "\\n"
    printf "  - Press ENTER to confirm the location\\n"
    printf "  - Press CTRL-C to abort the installation\\n"
    printf "  - Or specify a different location below\\n"
    printf "\\n"
    printf "[%s] >>> " "$PREFIX"
    read -r user_prefix
    if [ "$user_prefix" != "" ]; then
        case "$user_prefix" in
            *\ * )
                printf "ERROR: Cannot install into directories with spaces\\n" >&2
                exit 1
                ;;
            *)
                eval PREFIX="$user_prefix"
                ;;
        esac
    fi
fi # !BATCH

case "$PREFIX" in
    *\ * )
        printf "ERROR: Cannot install into directories with spaces\\n" >&2
        exit 1
        ;;
esac

if [ "$FORCE" = "0" ] && [ -e "$PREFIX" ]; then
    printf "ERROR: File or directory already exists: '%s'\\n" "$PREFIX" >&2
    printf "If you want to update an existing installation, use the -u option.\\n" >&2
    exit 1
fi


if ! mkdir -p "$PREFIX"; then
    printf "ERROR: Could not create directory: '%s'\\n" "$PREFIX" >&2
    exit 1
fi

PREFIX=$(cd "$PREFIX"; pwd)
export PREFIX

printf "PREFIX=%s\\n" "$PREFIX"

# verify the MD5 sum of the tarball appended to this header
MD5=$(tail -n +697 "$THIS_PATH" | md5sum -)
if ! echo "$MD5" | grep 1ee39d9d2fdcb20cf833c08ca4fca4fa >/dev/null; then
    printf "WARNING: md5sum mismatch of tar archive\\n" >&2
    printf "expected: 1ee39d9d2fdcb20cf833c08ca4fca4fa\\n" >&2
    printf "     got: %s\\n" "$MD5" >&2
fi

# extract the tarball appended to this header, this creates the *.tar.bz2 files
# for all the packages which get installed below
cd "$PREFIX"


if ! tail -n +697 "$THIS_PATH" | tar xf -; then
    printf "ERROR: could not extract tar starting at line 697\\n" >&2
    exit 1
fi

PRECONDA="$PREFIX/preconda.tar.bz2"
bunzip2 -c $PRECONDA | tar -xf - --no-same-owner || exit 1
rm -f $PRECONDA

PYTHON="$PREFIX/bin/python"
MSGS="$PREFIX/.messages.txt"
touch "$MSGS"
export FORCE

install_dist()
{
    # This function installs a conda package into prefix, but without linking
    # the conda packages.  It untars the package and calls a simple script
    # which does the post extract steps (update prefix files, run 'post-link',
    # and creates the conda metadata).  Note that this is all done without
    # conda.
    printf "installing: %s ...\\n" "$1"
    PKG_PATH="$PREFIX"/pkgs/$1
    PKG="$PKG_PATH".tar.bz2
    mkdir -p $PKG_PATH || exit 1
    bunzip2 -c "$PKG" | tar -xf - -C "$PKG_PATH" --no-same-owner || exit 1
    "$PREFIX/pkgs/python-3.6.3-hc9025b9_1/bin/python" -E -s \
        "$PREFIX"/pkgs/.install.py $INST_OPT --root-prefix="$PREFIX" --link-dist="$1" || exit 1
    if [ "$1" = "python-3.6.3-hc9025b9_1" ]; then
        if ! "$PYTHON" -E -V; then
            printf "ERROR:\\n" >&2
            printf "cannot execute native linux-64 binary, output from 'uname -a' is:\\n" >&2
            uname -a >&2
            exit 1
        fi
    fi
}

install_dist python-3.6.3-hc9025b9_1
install_dist ca-certificates-2017.08.26-h1d4fec5_0
install_dist conda-env-2.6.0-h36134e3_1
install_dist intel-openmp-2018.0.0-h15fc484_7
install_dist libgcc-ng-7.2.0-h7cc24e2_2
install_dist libgfortran-ng-7.2.0-h9f7466a_2
install_dist libstdcxx-ng-7.2.0-h7a57d05_2
install_dist bzip2-1.0.6-h0376d23_1
install_dist expat-2.2.4-hc00ebd1_1
install_dist gmp-6.1.2-hb3b607b_0
install_dist graphite2-1.3.10-hc526e54_0
install_dist icu-58.2-h211956c_0
install_dist jbig-2.1-hdba287a_0
install_dist jpeg-9b-habf39ab_1
install_dist libffi-3.2.1-h4deb6c0_3
install_dist libsodium-1.0.13-h31c71d8_2
install_dist libssh2-1.8.0-h8c220ad_2
install_dist libtool-2.4.6-hd50d1a6_0
install_dist libxcb-1.12-h84ff03f_3
install_dist lzo-2.10-h1bfc0ba_1
install_dist mkl-2018.0.0-hb491cac_4
install_dist ncurses-6.0-h06874d7_1
install_dist openssl-1.0.2l-h077ae2c_5
install_dist patchelf-0.9-hf79760b_2
install_dist pcre-8.41-hc71a17e_0
install_dist pixman-0.34.0-h83dc358_2
install_dist tk-8.6.7-h5979e9b_1
install_dist unixodbc-2.3.4-hc36303a_1
install_dist xz-5.2.3-h2bcbf08_1
install_dist yaml-0.1.7-h96e3832_1
install_dist zlib-1.2.11-hfbfcf68_1
install_dist curl-7.55.1-hcb0b314_2
install_dist glib-2.53.6-hc861d11_1
install_dist hdf5-1.10.1-hb0523eb_0
install_dist libedit-3.1-heed3624_0
install_dist libpng-1.6.32-hda9c8bc_2
install_dist libtiff-4.0.8-h90200ff_9
install_dist libxml2-2.9.4-h6b072ca_5
install_dist mpfr-3.1.5-h12ff648_1
install_dist pandoc-1.19.2.1-hea2e7c5_1
install_dist readline-7.0-hac23ff0_3
install_dist zeromq-4.2.2-hb0b69da_1
install_dist dbus-1.10.22-h3b5a359_0
install_dist freetype-2.8-h52ed37b_0
install_dist gstreamer-1.12.2-h4f93127_0
install_dist libxslt-1.1.29-hcf9102b_5
install_dist mpc-1.0.3-hf803216_4
install_dist sqlite-3.20.1-h6d8b0f3_1
install_dist fontconfig-2.12.4-h88586e7_1
install_dist gst-plugins-base-1.12.2-he3457e5_0
install_dist alabaster-0.7.10-py36h306e16b_0
install_dist asn1crypto-0.22.0-py36h265ca7c_1
install_dist backports-1.0-py36hfa02d7e_1
install_dist beautifulsoup4-4.6.0-py36h49b8c8c_1
install_dist bitarray-0.8.1-py36h5834eb8_0
install_dist boto-2.48.0-py36h6e4cd66_1
install_dist cairo-1.14.10-haa5651f_5
install_dist certifi-2017.7.27.1-py36h8b7b77e_0
install_dist chardet-3.0.4-py36h0f667ec_1
install_dist click-6.7-py36h5253387_0
install_dist cloudpickle-0.4.0-py36h30f8c20_0
install_dist colorama-0.3.9-py36h489cec4_0
install_dist contextlib2-0.5.5-py36h6c84a62_0
install_dist dask-core-0.15.3-py36h10e6167_0
install_dist decorator-4.1.2-py36hd076ac8_0
install_dist docutils-0.14-py36hb0f60f5_0
install_dist entrypoints-0.2.3-py36h1aec115_2
install_dist et_xmlfile-1.0.1-py36hd6bccc3_0
install_dist fastcache-1.0.2-py36h5b0c431_0
install_dist filelock-2.0.12-py36hacfa1f5_0
install_dist glob2-0.5-py36h2c1b292_1
install_dist gmpy2-2.0.8-py36h55090d7_1
install_dist greenlet-0.4.12-py36h2d503a6_0
install_dist heapdict-1.0.0-py36h79797d7_0
install_dist idna-2.6-py36h82fb2a8_1
install_dist imagesize-0.7.1-py36h52d8127_0
install_dist ipython_genutils-0.2.0-py36hb52b0d5_0
install_dist itsdangerous-0.24-py36h93cc618_1
install_dist jdcal-1.3-py36h4c697fb_0
install_dist jedi-0.10.2-py36h552def0_0
install_dist lazy-object-proxy-1.3.1-py36h10fcdad_0
install_dist llvmlite-0.20.0-py36_0
install_dist locket-0.2.0-py36h787c0ad_1
install_dist lxml-4.1.0-py36h5b66e50_0
install_dist markupsafe-1.0-py36hd9260cd_1
install_dist mccabe-0.6.1-py36h5ad9710_1
install_dist mistune-0.7.4-py36hbab8784_0
install_dist mkl-service-1.1.2-py36h17a0993_4
install_dist mpmath-0.19-py36h8cc018b_2
install_dist msgpack-python-0.4.8-py36hec4c5d1_0
install_dist multipledispatch-0.4.9-py36h41da3fb_0
install_dist numpy-1.13.3-py36ha12f23b_0
install_dist olefile-0.44-py36h79f9f78_0
install_dist pandocfilters-1.4.2-py36ha6701b7_1
install_dist path.py-10.3.1-py36he0c6f6d_0
install_dist pep8-1.7.0-py36h26ade29_0
install_dist pickleshare-0.7.4-py36h63277f8_0
install_dist pkginfo-1.4.1-py36h215d178_1
install_dist ply-3.10-py36hed35086_0
install_dist psutil-5.4.0-py36h84c53db_0
install_dist ptyprocess-0.5.2-py36h69acd42_0
install_dist py-1.4.34-py36h0712aa3_1
install_dist pycodestyle-2.3.1-py36hf609f19_0
install_dist pycosat-0.6.2-py36h1a0ea17_1
install_dist pycparser-2.18-py36hf9f622e_1
install_dist pycrypto-2.6.1-py36h6998063_1
install_dist pycurl-7.43.0-py36h5e72054_3
install_dist pyodbc-4.0.17-py36h999153c_0
install_dist pyparsing-2.2.0-py36hee85983_1
install_dist pysocks-1.6.7-py36hd97a5b1_1
install_dist pytz-2017.2-py36hc2ccc2a_1
install_dist pyyaml-3.12-py36hafb9ca4_1
install_dist pyzmq-16.0.2-py36h3b0cf96_2
install_dist qt-5.6.2-h974d657_12
install_dist qtpy-1.3.1-py36h3691cc8_0
install_dist rope-0.10.5-py36h1f8c17e_0
install_dist ruamel_yaml-0.11.14-py36ha2fb22d_2
install_dist simplegeneric-0.8.1-py36h2cb9092_0
install_dist sip-4.18.1-py36h51ed4ed_2
install_dist six-1.11.0-py36h372c433_1
install_dist snowballstemmer-1.2.1-py36h6febd40_0
install_dist sortedcontainers-1.5.7-py36hdf89491_0
install_dist sphinxcontrib-1.0-py36h6d0f590_1
install_dist sqlalchemy-1.1.13-py36hfb5efd7_0
install_dist tblib-1.3.2-py36h34cf8b6_0
install_dist testpath-0.3.1-py36h8cadb63_0
install_dist toolz-0.8.2-py36h81f2dff_0
install_dist tornado-4.5.2-py36h1283b2a_0
install_dist typing-3.6.2-py36h7da032a_0
install_dist unicodecsv-0.14.1-py36ha668878_0
install_dist wcwidth-0.1.7-py36hdf4376a_0
install_dist webencodings-0.5.1-py36h800622e_1
install_dist werkzeug-0.12.2-py36hc703753_0
install_dist wrapt-1.10.11-py36h28b7045_0
install_dist xlrd-1.1.0-py36h1db9f0c_1
install_dist xlsxwriter-1.0.2-py36h3de1aca_0
install_dist xlwt-1.3.0-py36h7b00a1f_0
install_dist babel-2.5.0-py36h7d14adf_0
install_dist backports.shutil_get_terminal_size-1.0.0-py36hfea85ff_2
install_dist bottleneck-1.2.1-py36haac1ea0_0
install_dist cffi-1.10.0-py36had8d393_1
install_dist conda-verify-2.0.0-py36h98955d8_0
install_dist cycler-0.10.0-py36h93f1223_0
install_dist cytoolz-0.8.2-py36h708bfd4_0
install_dist h5py-2.7.0-py36he81ebca_1
install_dist harfbuzz-1.5.0-h2545bd6_0
install_dist html5lib-0.999999999-py36h2cfc398_0
install_dist networkx-2.0-py36h7e96fb8_0
install_dist nltk-3.2.4-py36h1a0979f_0
install_dist numba-0.35.0-np113py36_10
install_dist numexpr-2.6.2-py36hdd3393f_1
install_dist openpyxl-2.4.8-py36h41dd2a8_1
install_dist packaging-16.8-py36ha668100_1
install_dist partd-0.3.8-py36h36fd896_0
install_dist pathlib2-2.3.0-py36h49efa8e_0
install_dist pexpect-4.2.1-py36h3b9d41b_0
install_dist pillow-4.2.1-py36h9119f52_0
install_dist pyqt-5.6.0-py36h0386399_5
install_dist python-dateutil-2.6.1-py36h88d3b88_1
install_dist pywavelets-0.5.2-py36he602eb0_0
install_dist qtawesome-0.4.4-py36h609ed8c_0
install_dist scipy-0.19.1-py36h9976243_3
install_dist setuptools-36.5.0-py36he42e2e1_0
install_dist singledispatch-3.4.0.3-py36h7a266c3_0
install_dist sortedcollections-0.5.3-py36h3c761f9_0
install_dist sphinxcontrib-websupport-1.0.1-py36hb5cb234_1
install_dist sympy-1.1.1-py36hc6d1c1c_0
install_dist terminado-0.6-py36ha25a19f_0
install_dist traitlets-4.3.2-py36h674d592_0
install_dist zict-0.1.3-py36h3a3bf81_0
install_dist astroid-1.5.3-py36hbdb9df2_0
install_dist bleach-2.0.0-py36h688b259_0
install_dist clyent-1.2.2-py36h7e57e65_1
install_dist cryptography-2.0.3-py36ha225213_1
install_dist cython-0.26.1-py36h21c49d0_0
install_dist datashape-0.5.4-py36h3ad6b5c_0
install_dist distributed-1.19.1-py36h25f3894_0
install_dist get_terminal_size-1.0.0-haa9412d_0
install_dist gevent-1.2.2-py36h2fe25dc_0
install_dist imageio-2.2.0-py36he555465_0
install_dist isort-4.2.15-py36had401c0_0
install_dist jinja2-2.9.6-py36h489bce4_1
install_dist jsonschema-2.6.0-py36h006f8b5_0
install_dist jupyter_core-4.3.0-py36h357a921_0
install_dist matplotlib-2.1.0-py36hba5de38_0
install_dist navigator-updater-0.1.0-py36h14770f7_0
install_dist nose-1.3.7-py36hcdf7029_2
install_dist pandas-0.20.3-py36h842e28d_2
install_dist pango-1.40.11-h8191d47_0
install_dist patsy-0.4.1-py36ha3be15e_0
install_dist pyflakes-1.6.0-py36h7bd6a15_0
install_dist pygments-2.2.0-py36h0d3125c_0
install_dist pytables-3.4.2-py36h3b5282a_2
install_dist pytest-3