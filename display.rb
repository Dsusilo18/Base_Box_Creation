class Display
    def update_prompt(cmd)
        prompt = " When the Virtual Machine is done booting, please login.
 Use the user: \'vagrant\' and the password: \'vagrant\'.
 Onced logged in, COPY AND PASTE this command in the terminal of the VM:\n
 #{cmd}\n\n When finished installing and restarting, type y below to continue."
        puts prompt
        continue_prompt
    end

    def make_box_prompt(config)
        done = false
        while done == false
            puts " Would you like to create base box? (Y/N)"
            input = gets.chomp.downcase 
            if input == 'y'
                done = true
                if config["base_box_name"].eql? ''
                    puts "ERROR: Base box name must be delcared in \'config.conf\'"
                    return false
                else 
                    return true
                end
            elsif input == 'n'
                done = true
                return false
            else 
                puts " ERROR: Please type Y or N\n"
            end
        end
    end
end