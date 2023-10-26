require 'net/ssh'
require 'parseconfig'
require './display'
require './dependency'

config = ParseConfig.new('config.conf')
prompt = Display.new()
check_dep = Dependency.new()
create_box = false
update_found = false

check_dep.check_dependency

vagrantfile_content = "Vagrant.configure(\"2\") do |config|\n"
vagrantfile_content << "    config.vm.box = \"#{config["vm_box"]}\"\n" unless config["vm_box"].eql? ''
vagrantfile_content << "    config.vm.box_version = \"#{config["vm_box_version"]}\"\n" unless config["vm_box_version"].eql? ''
vagrantfile_content << "    config.vm.box_url = \"#{config["vm_box_url"]}\"\n" unless config["vm_box_url"].eql? ''
vagrantfile_content << "    config.vm.provider 'parallels' do |prl|\n       prl.linked_clone = #{config["linked_clone"]}\n    end\n" unless config["linked_clone"].eql? ''
vagrantfile_content << "end"

vagrantfile_path = "Vagrantfile"

File.open(vagrantfile_path, "w") { |file| file.write(vagrantfile_content)}

system('cat vagrantfile')
system('vagrant up')

ssh_config_output = `vagrant ssh-config`
vm_ip = ssh_config_output.scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/)
should_continue = true

while should_continue
    begin
        Net::SSH.start(vm_ip.join(" "), 'vagrant', password: 'vagrant') do |ssh|

            available_updates = ssh.exec!('softwareupdate -l')

            if available_updates.include? "macOS #{config['update_name']}" and !config['update_name'].eql? ''
                puts "Update found!, updating now"

                result = available_updates.scan(/Label:([^T]+)/)

                result.each do|updates|
                    if updates[0].include? "macOS #{config['update_name']}"
                        command = "sudo softwareupdate -i \'#{updates[0].strip}\' -R"
                        update_found = true

                        channel = ssh.open_channel do |ch|
                            ch.exec(command) do |ch, success|
                                unless success
                                    puts "Failed to execute commands"
                                    exit 
                                end
                                ch.on_data do |c, data|
                                    print data 
                                end
                                ch.on_extended_data do |c, type, data|
                                    c.send_data("vagrant\n")
                                end
                            end
                        end

                        channel.wait 
                    end
                end
            else
                puts "Update not found!" unless update_found
                should_continue = false
            end
            ssh.close
        end

    rescue StandardError => e 
        puts "\nVM Restarted. Reconnecting..."
        sleep 120
    end
end

create_box = prompt.make_box_prompt(config)

system('vagrant halt')
system("vagrant package --output \"#{config["base_box_name"]}.box\"") unless create_box == false
system('vagrant destroy -f')

