class Dependency
    def check_dependency
        config = ParseConfig.new("config.conf")
        errors = 0

        if config['vm_box_url'] != '' and !config['vm_box_url'].include? '.box' and !config['vm_box_url'].include? '.com'
            errors = errors + 1
            warn 'ERROR: You did not give a valid VM Box URL!'
        end 

        if config['vm_box_version'] != '' and !config['vm_box_version'].match(/[^0-9.]/)
            errors = errors + 1
            warn 'ERROR: You did not give a valid VM Box Version.'
        end

        if config['linked_clone'] == '' and config['linked_clone'] != 'true' and config['linked_clone'] != 'false'
            errors = errors + 1
            warn 'ERROR: Please put true or false for linked_clone.'
        end

        if config['base_box_name'].include? '.box' and config['base_box_name'] != ''
            errors = errors + 1
            warn 'ERROR: Base box name cannot include .box'
        end

        if config['vm_box'].include? '.box' or config['vm_box'] == ''
            errors = errors + 1
            warn 'ERROR: Requires a VM box name that do not include .box'
        end

        errors = errors + check_vm_box(config['vm_box'], config['vm_box_url'])
        
        if errors != 0
            exit
        end
    end

    def check_input(inputs)
        errors = 0

        if inputs[2] != '' and !inputs[2].include? '.box' and !inputs[2].include? '.com'
            errors = errors + 1
            warn 'ERROR: You did not give a valid VM Box URL!'
        end 

        if inputs[1] != '' and !inputs[1].match(/[^0-9.]/)
            errors = errors + 1
            warn 'ERROR: You did not give a valid VM Box Version.'
        end

        if inputs[4] == '' and inputs[4] != 'true' and inputs[4] != 'false'
            errors = errors + 1
            warn 'ERROR: Please put true or false for linked_clone.'
        end

        if inputs[3].include? '.box' and inputs[3] != ''
            errors = errors + 1
            warn 'ERROR: Base box name cannot include .box'
        end

        if inputs[0].include? '.box' or inputs[0] == ''
            errors = errors + 1
            warn 'ERROR: Requires a VM box name that do not include .box'
        end

        errors = errors + check_vm_box(inputs[0], inputs[2])

        if errors != 0
            puts errors
            exit
        end
    end

    private 

    def check_vm_box(box, url)
        box_list = `vagrant box list`
        if url == ''
            warn 'ERROR: Requires url to add the VM box.' unless box_list.include? box
            return 1 unless box_list.include? box
        end
        0
    end
end