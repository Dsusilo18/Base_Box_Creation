require 'parseconfig'

class Vagrantfile 
    def create_file 
        config = ParseConfig.new('config.conf')
        vagrantfile_content = "Vagrant.configure(\"2\") do |config|\n"
        vagrantfile_content << "    config.vm.box = \"#{config["vm_box"]}\"\n" unless config["vm_box"].eql? ''
        vagrantfile_content << "    config.vm.box_version = \"#{config["vm_box_version"]}\"\n" unless config["vm_box_version"].eql? ''
        vagrantfile_content << "    config.vm.box_url = \"#{config["vm_box_url"]}\"\n" unless config["vm_box_url"].eql? ''
        vagrantfile_content << "    config.vm.provider 'parallels' do |prl|\n       prl.linked_clone = #{config["linked_clone"]}\n    end\n" unless config["linked_clone"].eql? ''
        vagrantfile_content << "end"

        vagrantfile_path = "Vagrantfile"

        File.open(vagrantfile_path, "w") { |file| file.write(vagrantfile_content)}
    end

    def create_manual_file(inputs)
        config = ParseConfig.new('config.conf')
        vagrantfile_content = "Vagrant.configure(\"2\") do |config|\n"
        vagrantfile_content << "    config.vm.box = \"#{inputs[0]}\"\n" unless inputs[0].eql? ''
        vagrantfile_content << "    config.vm.box_version = \"#{inputs[1]}\"\n" unless inputs[1].eql? ''
        vagrantfile_content << "    config.vm.box_url = \"#{inputs[2]}\"\n" unless inputs[2].eql? ''
        vagrantfile_content << "    config.vm.provider 'parallels' do |prl|\n       prl.linked_clone = #{inputs[4]}\n    end\n" unless inputs[4].eql? ''
        vagrantfile_content << "end"

        vagrantfile_path = "Vagrantfile"
        File.open(vagrantfile_path, "w") { |file| file.write(vagrantfile_content)}
    end

    def start_file
        system('cat vagrantfile')
        system('vagrant up')
    end

    def end_file
        system('vagrant halt')
        system('vagrant destroy -f')
    end

    def create_box(base_name)
        system('vagrant halt')
        system("vagrant package --output \"#{base_name}.box\"")
        system('vagrant destroy -f')
    end
end