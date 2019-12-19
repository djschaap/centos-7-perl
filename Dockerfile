FROM centos:7
LABEL authors="Doug Schaapveld <djschaap@gmail.com>"
# Log::Dispatch 2.69 requires Test2::Plugin::NoWarnings
# Test2::Plugin::NoWarnings works under Docker 19.03.5 (Fedora 30)
#   but fails t/compile.t under podman 1.6.2;
#   using --force seems to work
RUN \
  groupadd -r app \
  && useradd -mr -g app -s /bin/bash -G wheel app
