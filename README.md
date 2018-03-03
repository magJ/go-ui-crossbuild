# go-ui-docker
Cross compiler for use with the [go ui library](https://github.com/andlabs/ui) 

### Usage
1. Mount your project to `/go/src/project_name`
2. Invoke the `gouicrossbuild` command,  
   specify the name of your project (to match the mount point) and the path to the module to build.  
   
##### Example:
```bash
docker run -v $GOPATH/project_name:/go/src/project_name magj/go-ui-crossbuild gouicrossbuild project_name ./cmd/gui
```

## License
Building for macOS uses code from the Apple SDK  
[Please read and understand the Apple Xcode and SDK license before using.](https://www.apple.com/legal/sla/docs/xcode.pdf)

Any original code is licenced under "unlicense"