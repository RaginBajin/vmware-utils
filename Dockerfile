FROM centos:centos7
MAINTAINER josephbajin@gmail.com

# Set the working directory to /root
WORKDIR /root

# Update Centos to have last known updated version
RUN yum -y update

## Add VMWare specific things ##
## -------- vSphere -------- ##

# Add All files first 
ADD VMware-vSphere-CLI-5.5.0-2043780.x86_64.tar.gz /tmp/
ADD VMware-ovftool-4.0.0-2301625-lin.x86_64.bundle /tmp/
ADD VMware-vix-disklib-5.5.4-2454786.x86_64.tar.gz /tmp/
ADD cloudclient-4.0.0-3343843-dist.zip /tmp/

RUN yum install -y epel-release
# Install vCLI Pre-Reqs
RUN yum install -y --nogpgcheck \
      gcc \
      perl \
      libssl-devel \
      e2fsprogs \
      git \
      expect \
      python \
      python-devel \
      python-pip \
      python-virtualenv \
      make \
      unzip \
      gem \
      libxml2 \
libxml2-devel \
libxslt  \
libxslt-devel \
gcc \
gcc-c++ \ 
make \
openssl-devel \
libuuid-devel \
perl-libxml-perl \
perl-Pod-Perldoc.noarch \
perl-Archive-Zip \
perl-Crypt-SSLeay \
perl-Class-MethodMaker \
perl-SOAP-Lite.noarch \
ruby \
perl-Data-Dump.noarch \
perl-Data-Dumper \
ruby-devel \
which \
      java-1.8.0-openjdk && \
    yum clean all;

# Install vCLI https://developercenter.vmware.com/web/dp/tool/vsphere_cli/5.5
# Install VMware OVFTool http://vmware.com/go/ovftool
# Install VDDK
# Install Cloud Client http://developercenter.vmware.com/web/dp/tool/cloudclient/3.1.0
# Add William Lams awesome scripts from vGhetto Script Repository

RUN yes | /tmp/vmware-vsphere-cli-distrib/vmware-install.pl -d && \
    rm -rf /tmp/vmware-vsphere-cli-distrib && \
    yes | /bin/bash /tmp/VMware-ovftool-4.0.0-2301625-lin.x86_64.bundle --required --console && \
    rm -f /tmp/VMware-ovftool-4.0.0-2301625-lin.x86_64.bundle && \
    yes | /tmp/vmware-vix-disklib-distrib/vmware-install.pl -d && \
    rm -rf /tmp/vmware-vix-disklib-distrib && \
    unzip /tmp/cloudclient-4.0.0-3343843-dist.zip -d /root && \
    rm -rf /tmp/cloudclient-4.0.0-3343843-dist.zip && \
    mkdir /root/vghetto && \
    git clone https://github.com/lamw/vghetto-scripts.git /root/vghetto


ENV GOPATH /root/src/go
ENV PATH $PATH:$GOPATH/bin

# Install rbVmomi &  RVC
# Install pyVmomi (vSphere SDK for Python)
# Install govc CLI
# Install vCloud SDK for Python
# Install vcloud-tools
RUN gem install rbvmomi rvc && \
    git clone https://github.com/vmware/pyvmomi.git /root/pyvmomi && \
    yum install -y golang libffi-devel && \
    mkdir -p $GOPATH && \
    go get github.com/vmware/govmomi/govc && \
    easy_install -U pip && \
    pip install vca-cli && \
    gem install RaaS && \
    pip install pyvcloud && \
    gem install --no-rdoc --no-ri vcloud-tools

# Run Bash when the image starts
CMD ["/bin/bash"]
