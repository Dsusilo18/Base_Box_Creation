require 'net/ssh'
require 'parseconfig'
require './display'

config = ParseConfig.new('config.conf')
prompt = Display.new()
create_box = false
update_found = false

vagrantfile_content = "Vagrant.configure(\"2\") do |config|\n"
vagrantfile_content << "    config.vm.box = \"#{config["vm_box"]}\"\n" unless config["vm_box"].eql? ''
vagrantfile_content << "    config.vm.box_version = \"#{config["vm_box_version"]}\"\n" unless config["vm_box_version"].eql? ''
vagrantfile_content << "    config.vm.box_url = \"#{config["vm_box_url"]}\"\n" unless config["vm_box_url"].eql? ''
vagrantfile_content << "    config.vm.provider 'parallels' do |prl|\n       prl.linked_clone = #{config["linked_clone"]}\n    end\n" unless config["linked_clone"].eql? ''
vagrantfile_content << "end"

vagrantfile_path = "Vagrantfile"

File.open(vagrantfile_path, "w") { |file| file.write(vagrantfile_content)}

puts "Vagrantfile created at #{vagrantfile_path}"

system('cat vagrantfile')
system('vagrant up')
ssh_config_output = `vagrant ssh-config`
vm_ip = ssh_config_output.scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/)

Net::SSH.start(vm_ip.join(" "), 'vagrant', password: 'vagrant') do |ssh|
    available_updates = ssh.exec!('softwareupdate -l')
    if available_updates.include? "macOS #{config['update_name']}" and !config['update_name'].eql? ''
        puts " Update found!, updating now"
        result = available_updates.scan(/Label:([^T]+)/)
        result.each do|updates|
            if updates[0].include? "macOS #{config['update_name']}"
                command = "sudo softwareupdate -i \'#{updates[0].strip}\' -R"
                # ssh.exec!("sudo softwareupdate -i \'#{result}\' -R\n")
                # sleep(120)
                # ssh.exec!("vagrant\n")
                update_found = true
            end
        end
    else
        puts " Update not found!"
    end
    ssh.close
end

create_box = prompt.make_box_prompt(config) unless update_found == false
system('vagrant halt')
system("vagrant package --output \"#{config["base_box_name"]}.box\"") unless create_box == false
system('vagrant destroy -f')

