#cloud init 28/09/2021 13:19
write_files:
- path: /etc/yum.repos.d/epel.repo
  content: |
    [epel]
    name=Extra Packages for Enterprise Linux 7 - $basearch
    #baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch
    metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
    failovermethod=priority
    enabled=1
    gpgcheck=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

    [epel-debuginfo]
    name=Extra Packages for Enterprise Linux 7 - $basearch - Debug
    #baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch/debug
    metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-7&arch=$basearch
    failovermethod=priority
    enabled=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
    gpgcheck=0

    [epel-source]
    name=Extra Packages for Enterprise Linux 7 - $basearch - Source
    #baseurl=http://download.fedoraproject.org/pub/epel/7/SRPMS
    metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-source-7&arch=$basearch
    failovermethod=priority
    enabled=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
    gpgcheck=1

- path: /root/install.sh
  content: |
    #!/usr/bin/env sh
    echo "BEGIN USER-DATA"
    export teamcluster='${teamcluster}'
    export asgname='${asgname}'
    #yum clean all; yum update -y ; yum  install ansible
    yum clean all; yum update --disablerepo=epel -y; yum  install ansible  -y
    aws s3 cp s3://${bucket_name}/ansible /home/ec2-user/ansible.zip
    unzip /home/ec2-user/ansible.zip -d /etc/ansible/roles/
    ansible-playbook /etc/ansible/roles/rabbitmq/tests/test.yml --connection=local --extra-vars='asgname=${asgname}'
    echo "END USER-DATA"
runcmd:
- export teamcluster='${teamcluster}'
- export AWS_DEFAULT_REGION='${region}'
- aws configure set aws_access_key_id '${aws_access_key}' --profile rabbitmq
- aws configure set aws_secret_access_key '${aws_secret_key}' --profile rabbitmq
- aws configure set region '${region}' --profile rabbitmq
- bash /root/install.sh
