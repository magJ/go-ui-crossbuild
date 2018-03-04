FROM magj/go-ui-crossbuild-base
WORKDIR /go/src
RUN printf '#!/bin/sh\n\
die () {\n\
    echo >&2 "$@"\n\
    exit 1\n\
}\n\
[ "$#" -eq 2 ] || die "Provide a project root path and a relative package path\\n\
usage: github.com/name/project ./cmd/gui"\n\
PROJECT_ROOT=$1\n\
PACKAGE=$2\n\
PACKAGE_BASENAME=`basename $PACKAGE| cut -f 1 -d '.'`\n\
shift\n\
shift\n\
cd $PROJECT_ROOT\n\
export CGO_ENABLED=1\n\
export GOARCH=amd64\n\
# Copy locally compiled libui to avoid linking error\n\
# Remove when https://github.com/andlabs/ui/issues/230 fixed\n\
cp /tmp/libui_linux_amd64.a vendor/github.com/andlabs/ui\n\
echo "Building linux binary"\n\
GOOS=linux CC=clang CXX=clang++ go build $PACKAGE $*\n\
echo "Building windows binary"\n\
GOOS=windows CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ go build -ldflags "-H=windowsgui -extldflags=-s" $PACKAGE $*\n\
echo "Building darwin binary"\n\
GOOS=darwin CGO_LDFLAGS_ALLOW="-mmacosx-version-min.*" CC=o64-clang CXX=o64-clang++ go build -o ${PACKAGE_BASENAME}.app $PACKAGE $*\n\
' >> /bin/gouicrossbuild
RUN chmod +x /bin/gouicrossbuild
CMD printf 'Cross compiler executable image intended for use with the andlabs/ui go library\n\
Builds binaries for amd64 linux/windows/darwin platforms\n\n\
usage: Mount your project in to the image $GOPATH source directory(/go/src).\n\
Invoke the `gouicrossbuild` command with the project name and the path to the module to build\n\
ie `docker run -v $GOPATH/project_name:/go/src/project_name magj/go-ui-crossbuild gouicrossbuild project_name ./cmd/gui`'
