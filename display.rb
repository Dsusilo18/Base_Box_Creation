class Display

    def make_box_prompt(config)
        done = false
        while done == false
            puts "Would you like to create base box? (Y/N)"
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
                puts "ERROR: Please type Y or N\n"
            end
        end
    end
end