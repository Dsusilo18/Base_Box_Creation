class Display

    def make_box_prompt(box_name)
        done = false
        while done == false
            puts "Would you like to create base box? (Y/N)"
            input = gets.chomp.downcase 
            if input == 'y'
                done = true
                if box_name.eql? ''
                    puts "ERROR: Base box name must be delcared"
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

    def vagrantfile_info
        answers = Array.new
        puts "What is the name of the VM Box you would like to use? [Press ENTER if none]"
        answers.push(gets.chomp)
        puts "What is the VM Box version? [Press ENTER if none]"
        answers.push(gets.chomp)
        puts "What is the VM Box url? [Press ENTER if none]"
        answers.push(gets.chomp)
        puts "What would you like the Base Box to be named? [Press ENTER if none]"
        answers.push(gets.chomp.downcase)
        puts "Linked clone? true/false [Press ENTER if none]"
        answers.push(gets.chomp.downcase)
        answers
    end

    def continue?
        done = false
        while done == false
            puts "Would you like to continue? (Y/N)"
            input = gets.chomp.downcase 
            if input == 'y'
                done = true
                return true
            elsif input == 'n'
                done = true
                return false
            else 
                puts "ERROR: Please type Y or N\n"
            end
        end
    end
end