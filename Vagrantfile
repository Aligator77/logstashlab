# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end  

  config.vm.define "logvag" do |logvag|
    logvag.vm.network :private_network, ip: "192.168.33.10"
    logvag.vm.hostname = "logvag"

    logvag.vm.provision :shell, :inline => "apt-get update"
    logvag.vm.provision :shell, :inline => "apt-get -y install openjdk-7-jre-headless"
    logvag.vm.provision :shell, :inline => "apt-get -y install curl"


    #install logstash
    logvag.vm.provision :shell, :inline => "wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -"
    logvag.vm.provision :shell, :inline => "echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' > /etc/apt/sources.list.d/logstash.list"
    logvag.vm.provision :shell, :inline => "apt-get update"
    logvag.vm.provision :shell, :inline => "apt-get install logstash"


  # Install elasticache
    logvag.vm.provision :shell, :inline => "wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.deb"
    logvag.vm.provision :shell, :inline => "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64;dpkg -i elasticsearch-1.1.1.deb"
    logvag.vm.provision :shell, :inline => "/etc/init.d/elasticsearch start"
    logvag.vm.provision :shell, :inline => "sed -i 's/\# cluster.name\: elasticsearch/cluster.name\: logstash/' /etc/elasticsearch/elasticsearch.yml"
    logvag.vm.provision :shell, :inline => "sed -i 's/\# node.name\: \"Franz Kafka\"/node.name\: \"logvag\"/' /etc/elasticsearch/elasticsearch.yml"
    logvag.vm.provision :shell, :inline => "/etc/init.d/elasticsearch restart"
  #config.vm.provision :shell, :inline => "elasticsearch-1.1.1/bin/plugin -install lmenezes/elasticsearch-kopf"


  # Install redis
    logvag.vm.provision :shell, :inline => "apt-get -y install redis-server"
    logvag.vm.provision :shell, :inline => "sed -i 's/bind 127.0.0.1/#bind 127.0.0.1/' /etc/redis/redis.conf"
    logvag.vm.provision :shell, :inline => "/etc/init.d/redis-server restart"


  # Configure logstash
    logvag.vm.provision :shell, :inline => "cp /vagrant/central.conf /etc/logstash/conf.d/central.conf"
    logvag.vm.provision :shell, :inline => "cp /vagrant/key/server.key /etc/logstash"
    logvag.vm.provision :shell, :inline => "cp /vagrant/key/server.crt /etc/logstash"
    logvag.vm.provision :shell, :inline => "chmod 644 /etc/logstash/server*"
    logvag.vm.provision :shell, :inline => "service logstash start"

  # restart logstash in end
    logvag.vm.provision :shell, :inline => "service logstash restart"

  # Run self test
    logvag.vm.provision :shell, :inline => "/vagrant/testlogvag"

  # Start Kibana. This will take a couple of minutes so just background and let it work...
    logvag.vm.provision :shell, :inline => "/opt/logstash/bin/logstash web &"

  end

  config.vm.define "mojje" do |mojje|
    mojje.vm.network :private_network, ip: "192.168.33.11"
    mojje.vm.hostname = "mojje"

    #install logstash
    mojje.vm.box = "centos-65-x64-virtualbox-nocm"
    mojje.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-nocm.box"

  # Install and configure logstash
    mojje.vm.provision :shell, :inline => "rpm --import http://packages.elasticsearch.org/GPG-KEY-elasticsearch"
    mojje.vm.provision :shell, :inline => "cp /vagrant/logstash.repo /etc/yum.repos.d/logstash.repo"
    mojje.vm.provision :shell, :inline => "yum -y install logstash"
    mojje.vm.provision :shell, :inline => "cp /vagrant/shipper.conf /etc/logstash/conf.d/shipper.conf"
    mojje.vm.provision :shell, :inline => "service logstash start"

    # HACK This needs to get fixed
    mojje.vm.provision :shell, :inline => "chmod 644 /var/log/messages"
    mojje.vm.provision :shell, :inline => "chmod 644 /var/log/secure"

    # Helper functions
    mojje.vm.provision :shell, :inline => "yum -y install telnet"
    mojje.vm.provision :shell, :inline => "yum -y install nc"

    # restart logstash in end
    mojje.vm.provision :shell, :inline => "service logstash restart"

  # Run self test
    mojje.vm.provision :shell, :inline => "/vagrant/testmojje"
  end

  config.vm.define "syssy" do |syssy|
    syssy.vm.network :private_network, ip: "192.168.33.12"
    syssy.vm.hostname = "syssy"
    syssy.vm.provision :shell, :inline => "cp /vagrant/30-logstash.conf /etc/rsyslog.d/30-logstash.conf"
    syssy.vm.provision :shell, :inline => "/etc/init.d/rsyslog restart"

    # Helper functions
    syssy.vm.provision :shell, :inline => "apt-get -y install curl"

    syssy.vm.provision :shell, :inline => "/vagrant/testsyssy"
  end

  config.vm.define "lumberjack" do |lumberjack|
    lumberjack.vm.network :private_network, ip: "192.168.33.13"
    lumberjack.vm.hostname = "lumberjack"
    lumberjack.vm.provision :shell, :inline => "/vagrant/lumberjackbuilder.sh"

    # Helper functions
    lumberjack.vm.provision :shell, :inline => "apt-get -y install curl"

    lumberjack.vm.provision :shell, :inline => "/vagrant/testlumberjack"

  end

  config.vm.define "apachejson" do |apachejson|
    apachejson.vm.network :private_network, ip: "192.168.33.13"
    apachejson.vm.hostname = "apachejson"

    #install logstash
    apachejson.vm.box = "centos-65-x64-virtualbox-nocm"
    apachejson.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-nocm.box"

  # Install and configure logstash
    apachejson.vm.provision :shell, :inline => "rpm --import http://packages.elasticsearch.org/GPG-KEY-elasticsearch"
    apachejson.vm.provision :shell, :inline => "cp /vagrant/logstash.repo /etc/yum.repos.d/logstash.repo"
    apachejson.vm.provision :shell, :inline => "yum -y install logstash"
    apachejson.vm.provision :shell, :inline => "cp /vagrant/shipperfilter.conf /etc/logstash/conf.d/shipperfilter.conf"
    apachejson.vm.provision :shell, :inline => "service logstash start"

    # Apache, as that is what we are monitoring
    apachejson.vm.provision :shell, :inline => "yum -y install httpd"
    apachejson.vm.provision :shell, :inline => "/etc/init.d/httpd start"
    apachejson.vm.provision :shell, :inline => "cp /vagrant/apache_log.conf /etc/httpd/conf.d"
    apachejson.vm.provision :shell, :inline => "cp /vagrant/testpage.conf /etc/httpd/conf.d"
    apachejson.vm.provision :shell, :inline => "/etc/init.d/httpd restart"

    # HACK This needs to get fixed
    apachejson.vm.provision :shell, :inline => "chmod 644 /var/log/messages"
    apachejson.vm.provision :shell, :inline => "chmod 644 /var/log/secure"
    apachejson.vm.provision :shell, :inline => "chmod 755 /var/log/httpd"
    apachejson.vm.provision :shell, :inline => "chmod 644 /var/log/httpd/logstash_access_log"

    # Helper functions
    apachejson.vm.provision :shell, :inline => "yum -y install nc"

    # restart logstash in end
    apachejson.vm.provision :shell, :inline => "service logstash restart"

  # Run self test
    apachejson.vm.provision :shell, :inline => "/vagrant/testapachejson"
  end

  config.vm.define "postfilter" do |postfilter|
    postfilter.vm.network :private_network, ip: "192.168.33.14"
    postfilter.vm.hostname = "postfilter"

    postfilter.vm.provision :shell, :inline => "apt-get update"
    postfilter.vm.provision :shell, :inline => "apt-get -y install openjdk-7-jre-headless"
    postfilter.vm.provision :shell, :inline => "apt-get -y install curl"


    #install logstash
    postfilter.vm.provision :shell, :inline => "wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -"
    postfilter.vm.provision :shell, :inline => "echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' > /etc/apt/sources.list.d/logstash.list"
    postfilter.vm.provision :shell, :inline => "apt-get update"
    postfilter.vm.provision :shell, :inline => "apt-get -y install logstash"
    postfilter.vm.provision :shell, :inline => "cp /vagrant/shipperpostfilter.conf /etc/logstash/conf.d/shipperpostfilter.conf"
    postfilter.vm.provision :shell, :inline => "service logstash start"

    postfilter.vm.provision :shell, :inline => "apt-get -y install postfix &> /dev/null"
    postfilter.vm.provision :shell, :inline => "apt-get -y install mailutils &> /dev/null"


    # HACK This needs to get fixed
    postfilter.vm.provision :shell, :inline => "chmod 644 /var/log/mail.*"
  end


end
