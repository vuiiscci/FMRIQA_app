FROM centos:6.8

RUN yum -y update && \
    yum -y install java-1.7.0-openjdk libgomp wget unzip zip xorg-x11-server-Xvfb ghostscript ImageMagick && \
    yum install -y yum-utils && \
    yum groupinstall -y development && \
    yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel && \
    wget http://www.python.org/ftp/python/3.3.3/Python-3.3.3.tar.xz && \
    yum install xz-libs && \
    xz -d Python-3.3.3.tar.xz && \
    tar -xvf Python-3.3.3.tar && \
    cd Python-3.3.3 && \   
    ./configure && \
    make && make altinstall && \
    wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz && \
    tar -xvf setuptools-1.4.2.tar.gz && \
    cd setuptools-1.4.2 && \
    python3.3 setup.py install && \
    curl https://bootstrap.pypa.io/get-pip.py | python3.3 - &&\
    pip install pyyaml && \
    mkdir /tmp/matlab_mcr && \
    cd /tmp/matlab_mcr/ && \
    wget http://ssd.mathworks.com/supportfiles/downloads/R2016a/deployment_files/R2016a/installers/glnxa64/MCR_R2016a_glnxa64_installer.zip && \
    unzip MCR_R2016a_glnxa64_installer.zip && \
    ./install -agreeToLicense yes -mode silent && \
    cd .. && \
    rm -rf /tmp/matlab_mcr && \
    mkdir /INPUTS && \
    mkdir /OUTPUTS && \ 
    mkdir /extra

# Copy binaries and other files
ADD extra /extra

# Set home directory in OUTPUTS folder
ENV HOME /OUTPUTS/.local/home

# Set tmp directory in OUTPUTS folder
ENV TMPDIR /OUTPUTS/.local/tmp
ENV TEMP /OUTPUTS/.local/tmp
ENV TMP /OUTPUTS/.local/tmp

# Set environment for MATLAB MCR
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/local/MATLAB/MATLAB_Runtime/v901/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v901/bin/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v901/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v901/sys/opengl/lib/glnxa64"

# Set CMD
CMD /extra/pipeline.sh
