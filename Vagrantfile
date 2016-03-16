require 'yaml'

cfg = YAML.load_file('config.yml')

VAGRANTFILE_API_VERSION = '2'
Vagrant.require_version '>= 1.6.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = cfg["vagrant"]["box"]
    config.vm.hostname = cfg["vagrant"]["hostname"]
    config.vm.network "private_network", ip: cfg["vagrant"]["ip"]

    config.vm.provider :virtualbox do |vb|
        vb.memory = cfg["vagrant"]["ram"]
        vb.cpus = cfg["vagrant"]["cpus"]
        vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    end

    if Vagrant.has_plugin?('vagrant-hostsupdater')
        # Read all server names from nginx vhosts
        hosts = Array.new();

        Dir.glob("./sites-enabled/*").each do |host|
            server_name = File.readlines(host).select{|line| line[/server_name/i]}.first
            if server_name
                hosts = hosts | server_name.gsub(/\s+/, " ").strip.split(/[\s;]/).drop(1)
            end
        end

        hosts = hosts - ["localhost"]

        config.hostsupdater.aliases = hosts
    end

    config.vm.synced_folder "./bootstrap", "/bootstrap", type: "nfs"

    # Share all projects folders
    Dir.glob("./www/*").each do |dir|
        config.vm.synced_folder dir, "/srv/www/" + dir.split('/').last, type: "nfs"
    end

    config.vm.synced_folder "./sites-enabled", "/etc/nginx/sites-enabled", type: "nfs"

    config.vm.provision :shell, path: "./bootstrap/update.sh", preserve_order: true
    config.vm.provision :shell, path: "./bootstrap/common.sh", preserve_order: true
    config.vm.provision :shell, path: "./bootstrap/nginx.sh", preserve_order: true
    config.vm.provision :shell, path: "./bootstrap/php.sh", preserve_order: true

    config.vm.provision :shell, inline: "sudo sed -i 's/memory_limit = .*/memory_limit = '" + cfg["php"]["memory_limit"] + "'/' /etc/php.ini", preserve_order: true
    config.vm.provision :shell, inline: "sudo sed -i 's/upload_max_filesize = .*/upload_max_filesize = " + cfg["php"]["upload_max_filesize"] + "/' /etc/php.ini", preserve_order: true
    config.vm.provision :shell, inline: "sudo sed -i 's/error_reporting = .*/error_reporting = " + cfg["php"]["error_reporting"] + "/' /etc/php.ini", preserve_order: true
    config.vm.provision :shell, inline: "sudo echo 'date.timezone = \'" + cfg["php"]["date.timezone"] + "\'' >> /etc/php.ini", preserve_order: true
    config.vm.provision :shell, inline: "sudo sed -i 's/client_max_body_size .*;/client_max_body_size " + cfg["php"]["upload_max_filesize"] + ";/' /etc/nginx/nginx.conf", preserve_order: true

    config.vm.provision :shell, path: "./bootstrap/postinstall.sh", preserve_order: true

    # reload nginx after shared folders are mounted
    config.vm.provision :shell, inline: "sudo systemctl restart nginx.service", run: "always", preserve_order: true

    # fix synced nfs user on every boot
    # config.vm.provision :shell, inline: "sudo bindfs --force-user=vagrant /var/www /var/www;", run: "always", preserve_order: true

    config.vm.provision :shell, inline: "sudo echo '127.0.0.1   localhost " + hosts.join(' ') + "' > /etc/hosts", run: "always", preserve_order: true

    config.vbguest.auto_update = true
end
