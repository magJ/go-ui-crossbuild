FROM archlinux/base
# Add mingw binary distribution repository
RUN printf  "[ownstuff]\n\
SigLevel = Optional TrustAll\n\
Server = http://martchus.no-ip.biz/repo/arch/\$repo/os/\$arch" >> /etc/pacman.conf
# install dependencies
RUN pacman -Sy \
  && pacman -S --noconfirm \
  base-devel \
  git \
  sudo \
  ppl \
  zlib \
  libmpc \
  gcc-ada \
  gmp \
  libxml2 \
  patch \
  clang \
  llvm \
  mingw-w64-gcc \
  gtk3 \
  cmake \
  go
WORKDIR /tmp

# install macOS cross compilation tools
RUN sudo -u nobody git clone https://aur.archlinux.org/osxcross-git.git \
  && cd osxcross-git \
  && sudo -u nobody makepkg --noconfirm -s \
  && pacman -U --noconfirm osxcross-git*.pkg.tar.xz \
  && cd .. \
  && rm -Rf osxcross-git
ENV PATH /usr/local/osx-ndk-x86/bin/:$PATH

# setup go environment and install go dep
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

# compile libui library (needed due to https://github.com/andlabs/ui/issues/230)
RUN git clone https://github.com/andlabs/libui.git \
  && cd libui/ \
  && mkdir build \
  && cd build/ \
  && cmake -DBUILD_SHARED_LIBS=OFF .. \
  && make \
  && cp out/libui.a /tmp/libui_linux_amd64.a \
  && cd .. \
  && rm -Rf libui

WORKDIR $GOPATH