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

        if config['vm_box_url'] == '' and config['linked_clone'] != 'true' and config['linked_clone'] != 'false'
            errors = errors + 1
            warn 'ERROR: Please put true or false for linked_clone.'
        end

        if config['base_box_name'].include? '.box' and config['base_box_name'] != ''
            errors = errors + 1
            warn 'ERROR: Base box name cannot include .box'
        end

        if errors != 0
            exit
        end
    end
end