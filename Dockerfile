FROM centos:7
LABEL authors="Doug Schaapveld <djschaap@gmail.com>"
RUN \
  yum install --setopt=tsflags=nodocs -y epel-release \
  && yum install --setopt=tsflags=nodocs -y \
    augeas \
    freetds-devel \
    gcc \
    mariadb \
    perl-AnyEvent \
    perl-App-cpanminus \
    perl-AppConfig \
    perl-CPAN \
    perl-Clone \
    perl-DBD-MySQL \
    perl-DBD-ODBC \
    perl-DBD-SQLite \
    perl-DBI \
    perl-Data-UUID \
    perl-DateTime \
    perl-DateTime-Format-ISO8601 \
    perl-DateTime-Format-MySQL \
    perl-DateTime-Format-Strptime \
    perl-Exception-Class \
    perl-IPC-System-Simple \
    perl-JSON \
    perl-LWP-Protocol-https \
    perl-Moose \
    perl-MooseX-InsideOut \
    perl-Module-Load \
    perl-Net-CIDR \
    perl-Params-Validate \
    perl-REST-Client \
    perl-Regexp-Common \
    perl-Sys-Syslog \
    perl-TermReadKey \
    perl-Test-Simple \
    perl-Text-CSV \
    perl-Text-CSV_XS \
    perl-YAML-LibYAML \
    perl-YAML-Tiny \
    perl-autodie \
    perl-namespace-autoclean \
    sudo \
  && cpanm install DateTime::Format::SQLite \
  && cpanm install Test2::Plugin::NoWarnings --force \
  && cpanm install Log::Dispatch::File \
  && cpanm install Log::Dispatch::Screen \
  && cpanm install MooseX::Log::Log4perl \
  && cpanm install --force Net::AMQP::RabbitMQ \
  && cpanm install Net::IMAP::Simple::SSL \
  && yum remove -y cpp gcc libgomp libmpc mpfr perl-Test-Simple \
  && yum clean all
# Log::Dispatch 2.69 requires Test2::Plugin::NoWarnings
# Test2::Plugin::NoWarnings works under Docker 19.03.5 (Fedora 30)
#   but fails t/compile.t under podman 1.6.2;
#   using --force seems to work
RUN mkdir -p /usr/local/bin /usr/local/entrypoint.d
COPY \
  docker-entrypoint-app.sh \
  docker-entrypoint.sh \
  /usr/local/bin/
RUN \
  groupadd -r app \
  && useradd -mr -g app -s /bin/bash -G wheel app
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
