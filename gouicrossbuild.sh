#!/bin/sh
die () {
    printf >&2 "$@"
    exit 1
}
if (( $# < 2 )); then die "Provide a project root path and a relative package path \nusage: github.com/name/project ./cmd/gui binary_output_path"; fi
PROJECT_ROOT=$1
PACKAGE=$2
PACKAGE_BASENAME=`basename ${PACKAGE}| cut -f 1 -d '.'`
if [ -n "$1" ]; then
    mkdir -p $3
    BUILD_OUTPUT="${3}/${PACKAGE_BASENAME}"
else
    BUILD_OUTPUT="${PACKAGE_BASENAME}"
fi

shift
shift
shift
cd ${PROJECT_ROOT}
export GOARCH=amd64

# if not invoked via gouicrossbuild just do a simple go build
if [ `basename $0` == "gouicrossbuild" ]; then
    export CGO_ENABLED=1
    # Copy locally compiled libui to avoid linking error
    # Remove when https://github.com/andlabs/ui/issues/230 fixed
    cp /tmp/libui_linux_amd64.a vendor/github.com/andlabs/ui
    echo "Building linux binary"
    GOOS=linux CC=clang CXX=clang++ go build -o ${BUILD_OUTPUT}_linux ${PACKAGE} $*
    echo "Building windows binary"
    GOOS=windows CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ go build -o ${BUILD_OUTPUT}_windows.exe -ldflags "-H=windowsgui -extldflags=-s" ${PACKAGE} $*
    echo "Building darwin binary"
    GOOS=darwin CGO_LDFLAGS_ALLOW="-mmacosx-version-min.*" CC=o64-clang CXX=o64-clang++ go build -o ${BUILD_OUTPUT}_darwin.app ${PACKAGE} $*
else
    echo "Building linux binary"
    GOOS=linux go build -o ${BUILD_OUTPUT}_linux ${PACKAGE} $*
    echo "Building windows binary"
    GOOS=windows go build -o ${BUILD_OUTPUT}_windows.exe ${PACKAGE} $*
    echo "Building darwin binary"
    GOOS=darwin go build -o ${BUILD_OUTPUT}_darwin ${PACKAGE} $*
fi