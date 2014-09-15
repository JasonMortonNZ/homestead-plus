class Homestead
  def Homestead.configure(config, settings)
    # Configure The Box
    config.vm.box = "laravel/homestead"
    config.vm.hostname = settings["hostname"] ||= "homestead"

    # Configure A Private Network IP
    config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.10"

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    # Configure Port Forwarding To The Box
    config.vm.network "forwarded_port", guest: 80, host: 8000     # HTTP
    config.vm.network "forwarded_port", guest: 443, host: 44300   # SSL
    config.vm.network "forwarded_port", guest: 3306, host: 33060  # MySQL
    config.vm.network "forwarded_port", guest: 5432, host: 54320  # PostgreSQL
    config.vm.network "forwarded_port", guest: 6379, host: 63790  # Redis
    config.vm.network "forwarded_port", guest: 11211, host: 11212 # Memcached

    # Configure The Public Key For SSH Access
    config.vm.provision "shell" do |s|
      s.inline = "echo $1 | tee -a /home/vagrant/.ssh/authorized_keys"
      s.args = [File.read(File.expand_path(settings["authorize"]))]
    end

    # Copy The SSH Private Keys To The Box
    settings["keys"].each do |key|
      config.vm.provision "shell" do |s|
        s.privileged = false
        s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
        s.args = [File.read(File.expand_path(key)), key.split('/').last]
      end
    end

    # Copy The Bash Aliases
    config.vm.provision "shell" do |s|
      s.inline = "cp /vagrant/aliases /home/vagrant/.bash_aliases"
    end

    # Register All Of The Configured Shared Folders
    settings["folders"].each do |folder|
      config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil
    end

    # Install All The Configured Nginx Sites
    settings["sites"].each do |site|
      config.vm.provision "shell" do |s|
          if (site.has_key?("hhvm") && site["hhvm"])
            s.inline = "bash /vagrant/scripts/serve-hhvm.sh $1 $2"
            s.args = [site["map"], site["to"]]
          else
            s.inline = "bash /vagrant/scripts/serve.sh $1 $2"
            s.args = [site["map"], site["to"]]
          end
      end
    end

    # Configure All Of The Server Environment Variables
    if settings.has_key?("variables")
      settings["variables"].each do |var|
        config.vm.provision "shell" do |s|
            s.inline = "echo \"\nenv[$1] = '$2'\" >> /etc/php5/fpm/php-fpm.conf && service php5-fpm restart"
            s.args = [var["key"], var["value"]]
        end
      end
    end

    # Create PostgreSQL Databases
    settings["databases"]["postgresql"].each do |postgresql|
      if !(postgresql.nil?)
        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = "export PGPASSWORD=secret;createdb -U homestead -h localhost \"$1\";"
          s.args = postgresql
        end
      end
    end

    # Create MySQL Databases
    settings["databases"]["mysql"].each do |mysql|
      if !(mysql.nil?)
        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = "export MYSQL_PWD=secret;mysql -u homestead -h localhost -e \"CREATE DATABASE $1\";"
          s.args = mysql
        end
      end
    end

    # Run Any Optional Commands
    if settings.has_key?("commands")
      settings["commands"].each do |command|
        config.vm.provision "shell" do |s|
            s.inline = command
        end
      end
    end
    
  end
end
