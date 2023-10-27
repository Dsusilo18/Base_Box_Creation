require 'net/ssh'
require 'parseconfig'
require './display'
require './dependency'
require './vagrantfile_setup'

config = ParseConfig.new('config.conf')
prompt = Display.new()
check_dep = Dependency.new()
vagfile = Vagrantfile.new()
create_box = false
update_found = false

check_dep.check_dependency
vagfile.create_file
vagfile.start_file

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

if prompt.make_box_prompt(config['base_box_name'])
    vagfile.create_box(config['base_box_name'])
else
    vagfile.end_file
end
