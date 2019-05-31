# pull base image
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "===> Adding Ansible's prerequisites..."   && \
    apt-get update -y            && \
    apt-get upgrade -y            && \
        apt-get install --no-install-recommends -y -q  \
                build-essential                        \
                python3.7 python3-pip python3-dev           \
                libffi-dev libssl-dev                  \
                libxml2-dev libxslt1-dev zlib1g-dev    \
                git && \
    python3 -m pip install --upgrade pip && \
    pip3 install --upgrade setuptools pip wheel      && \
    pip3 install --upgrade pyyaml jinja2 pycrypto    && \
    pip3 install --upgrade pywinrm                   && \
    pip3 install --upgrade pyvmomi                   && \
    pip3 install --upgrade pyvcloud                  && \
    pip3 install --upgrade ansible                   && \
    pip3 install --upgrade openstacksdk              && \
    pip3 install --upgrade netapp-lib                && \
    pip3 install --upgrade lxml                      && \
    pip3 install --upgrade boto                      && \
    pip3 install --upgrade boto3                     && \
    pip3 install --upgrade ansible-cmdb              && \

    \
    echo "===> Installing handy tools (not absolutely required)..."  && \
    apt-get install -y sshpass openssh-client  && \
    echo "===> Installing DELL-openmanger tools (not absolutely required)..."  && \
    git clone -b devel --single-branch https://github.com/dell/dellemc-openmanage-ansible-modules.git && \
    cd dellemc-openmanage-ansible-modules && \
    python3 install.py && \
    cd .. && \
    \
    echo "===> Installing vmware automation tools (not absolutely required)..."  && \
    git clone --depth 1 https://github.com/vmware/vsphere-automation-sdk-python && \
    cd vsphere-automation-sdk-python && \
    pip3 install --upgrade --force-reinstall -r requirements.txt --extra-index-url file:///vsphere-automation-sdk-python/lib && \
     \
    echo "===> Clean up..."                                         && \
    apt-get remove -y --auto-remove \
            build-essential python-pip python-dev git libffi-dev libssl-dev  && \
    apt-get clean                                                   && \
    rm -rf /var/lib/apt/lists/*                                     && \
    \
    echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo 'localhost' > /etc/ansible/hosts


ENV PATH        /opt/ansible/bin:$PATH
ENV PYTHONPATH  /opt/ansible/lib:$PYTHONPATH
ENV MANPATH     /opt/ansible/docs/man:$MANPATH

WORKDIR /work

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
