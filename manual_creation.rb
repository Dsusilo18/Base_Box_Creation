require './display'
require './dependency'
require './vagrantfile_setup'

prompt = Display.new()
check_dep = Dependency.new()
vagfile = Vagrantfile.new()

inputs = prompt.vagrantfile_info
check_dep.check_input(inputs)
vagfile.create_manual_file(inputs)
vagfile.start_file

puts "Once the VM is created, log into the VM using the user: 'vagrant' and password: 'vagrant'"
vagfile.end_file unless prompt.continue?
puts "Once logged in, COPY AND PASTE 'softwareupdate -l' into the terminal of the VM"
vagfile.end_file unless prompt.continue?
puts "After finding the label of the update to install, COPY AND PASTE 'sudo softwareupdate -i '<label>' -R into the terminal."
puts "Use the password: 'vagrant' to install the update."
puts "Make sure to terminate the terminal after the update has finished installing."
sleep(480)
puts "If the VM is done REBOOTING, you may continue"

if prompt.make_box_prompt(inputs[3])
    vagfile.create_box(inputs[3])
else
    vagfile.end_file
end

