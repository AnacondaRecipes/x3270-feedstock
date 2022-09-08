#!/usr/bin/env bash

declare -a config_opts

config_opts+=(--enable-option-checking)

## What to build
config_opts+=(--enable-lib)         # Unix support libraries
config_opts+=(--enable-pr3287)      # 3287 line printer emulator

#config_opts+=(--enable-b3270)       # generic 3270 emulator backend
config_opts+=(--enable-c3270)       # character-mode 3270 emulator
#config_opts+=(--enable-x3270)       # X11 3270 emulator

config_opts+=(--enable-s3270)       # 3270 screen scraping tool
config_opts+=(--enable-tcl3270)     # Scripting support for s3270

## Enable TLS support
config_opts+=(--enable-tls)
config_opts+=(--with-openssl="${PREFIX}")
config_opts+=(--with-ssl="${PREFIX}")
#config_opts+=(--enable-mock-tls)        # TLS mock for testing

## Other common features
config_opts+=(--enable-ipv6)
config_opts+=(--enable-dbcs)
config_opts+=(--enable-local-process)

config_opts+=(--with-iconv)     # Use iconv instead of `__STDC_ISO_10646__`
config_opts+=(--with-readline)

#config_opts+=(--with-x)
#config_opts+=(--with-fontdir=DIR)       # install directory for X11 fonts
#config_opts+=(--enable-app-defaults)    # separate app-defaults file

case "$target_platform" in
    osx-*)
        # Use conda-provided OpenSSL for TLS support
        config_opts+=(--disable-stransport)
        ;;
esac

cp -fv "${BUILD_PREFIX}/share/gnuconfig/config.guess" .
cp -fv "${BUILD_PREFIX}/share/gnuconfig/config.sub" .

./configure --prefix="${PREFIX}" ${config_opts[@]}
make -j${CPU_COUNT}
make unix-install
