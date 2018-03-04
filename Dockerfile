FROM magj/go-ui-crossbuild-base
WORKDIR /go/src
COPY gouicrossbuild.sh /bin/gouicrossbuild
RUN ln /bin/gouicrossbuild /bin/gocrossbuild
RUN chmod +x /bin/gouicrossbuild
RUN chmod +x /bin/gocrossbuild
CMD printf 'Cross compiler executable image intended for use with the andlabs/ui go library\n\
Builds binaries for amd64 linux/windows/darwin platforms\n\n\
usage: Mount your project in to the image $GOPATH source directory(/go/src).\n\
Invoke the `gouicrossbuild` command with the project name and the path to the module to build\n\
ie `docker run -v $GOPATH/project_name:/go/src/project_name magj/go-ui-crossbuild gouicrossbuild project_name ./cmd/gui`'
