#
# CentOS + mediainfo (built from code)  Dockerfile
#

# Build:
# docker build -t fursule/centos_mediainfo:latest .

# Create:
# docker create -it --name centos_mediainfo fursule/centos_mediainfo

# Start:
# docker start centos_mediainfo

# Connect with bash
# docker exec -it centos_mediainfo bash

# Pull base image
FROM centos:latest

# Maintener
MAINTAINER Swati Fursule <swatifursule@gmail.com>

# MediaInfo version
ENV MEDIAINFO_VERSION="18.03.1"

# Update CentOS 
RUN yum update -y && yum upgrade -y

# Install packages
RUN yum install -y unzip wget curl git

# Install EPEL Repository
RUN yum install -y epel-release

# Clean CentOS 
# RUN yum clean all

# Install Development Tools and libcurl-devel 
RUN yum -y groupinstall "Development Tools"
RUN yum -y install libcurl-devel

WORKDIR /opt

# Get mediainfo code and extract
RUN wget http://mediaarea.net/download/binary/mediainfo/"$MEDIAINFO_VERSION"/MediaInfo_CLI_"$MEDIAINFO_VERSION"_GNU_FromSource.tar.xz
RUN tar xvf MediaInfo_CLI_"$MEDIAINFO_VERSION"_GNU_FromSource.tar.xz

# Compile mediainfo
WORKDIR /opt/MediaInfo_CLI_GNU_FromSource/
RUN ./CLI_Compile.sh --with-libcurl
WORKDIR  MediaInfo/Project/GNU/CLI
RUN ./mediainfo --version
# Copy to $PATH, to access it from anywhere 
RUN cp mediainfo /usr/local/bin

# Default command
CMD mediainfo --version
