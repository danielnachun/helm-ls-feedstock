#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ ${target_platform} == "linux-aarch64" ]]; then
tee ${BUILD_PREFIX}/bin/cc_shim << EOF
args=()
for arg in "\$@"; do
    if [[ "\$arg" == "-fuse-ld=gold" ]]; then
        echo "Go build hack: dropping -fuse-ld=gold arg"
    else
        args+=("\$arg")
    fi
done
exec \${CC_FOR_BUILD} "\${args[@]}"
EOF
chmod +x ${BUILD_PREFIX}/bin/cc_shim
export CC_FOR_BUILD=${BUILD_PREFIX}/bin/cc_shim
fi

go build -o=${PREFIX}/bin/${PKG_NAME} -ldflags="-s -w"
go-licenses save . --save_path=license-files
