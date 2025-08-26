FROM vanilla:latest
#FROM public.ecr.aws/amazonlinux/amazonlinux:latest
#FROM ubuntu:24.04

RUN mkdir -p /app
WORKDIR /app

RUN yum update
RUN yum upgrade -y
#RUN yum install iproute2 net-tools php composer php8.3-xml php8.3-sqlite3 iproute2 netcat-traditional -y
RUN yum install  net-tools php composer php8.3-xml php-sqlite3  nmap-ncat.x86_64 vim  -y

COPY myapp myapp
ENV myapp_dir=/app/myapp
COPY myapp/run_env/start_app.bash /etc/start_scripts/start_app
ENTRYPOINT ["/etc/start_scripts/start_app"]
