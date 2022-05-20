require_relative './dataBase.rb'
require_relative './userLogs.rb'

class Application
    @@rollback = false
  
  def self.run
    open_application()
  end

  def self.get_rollback
    @@rollback
  end  

  private  
  def self.open_application
    show_instruction()
    while true
      print "> "
      userInput = gets.chomp      
      input = change_input_to_array(userInput)
      case input.first
      when "set"
        input.size == 3 ? DataBase.set_value(input[1], input[-1]) : next
      when "get"
        puts DataBase.get_value(input[-1])
      when "delete"
        input.size == 2 ? DataBase.delete_value(input[-1]) : next
      when "count"
        if input.size == 2
          puts DataBase.count_value(input[1]) 
        else
          next
        end  
      when "begin"
        UserLogs.set_new_logs_block      
      when "rollback"        
        if UserLogs.get_userLogs.size > 0
          Application.execute_rollback
        else
          puts Application.execute_rollback
        end    
      when "commit"
        UserLogs.delete_all_logs_blocks
      when "exit"
        puts "Are you sure? (Y/N)"
        input = gets.chomp
        break if input.downcase == "y" 
      else
        puts "There is no such action"
        puts "Do you want to show instructions? (Y/N)"
        print "> "
        input = gets.chomp
        show_Instruction() if input.downcase == "y"  
      end      
    end        
  end  
    
  def self.change_input_to_array(input)
    input.downcase.split(" ").map {|element| element}
  end  
 
  def self.execute_rollback
    Application.set_rollback_true()
    actions = UserLogs.get_userLogs.last    
    if UserLogs.get_userLogs.size > 0
        while actions.size > 0            
            action = actions.last.split(" ")            
            case action.first.downcase
            when "set"
              DataBase.set_value(action[1], action[-1])        
            when "delete"     
              DataBase.delete_value(action[-1])      
            end 
            actions.delete(actions.last)   
        end
        UserLogs.delete_last_logs_block
        Application.set_rollback_false()
    else
      Application.set_rollback_false()
      "No transaction"
    end
  end

  def self.set_rollback_true
    @@rollback = true
  end
  
  def self.set_rollback_false
    @@rollback = false
  end

  def self.show_instruction
    print """
    ************************************************************************************
    
    This is simple in-memory database
    Instrusciotns:

    SET [name] [value]: 
        Sets the variable named [name] to value [value]. 
        Value and name cannot contain spaces.
    GET [name]: 
        Displays the contents of the variable stored under the variable [name].         
    DELETE [name]: 
        Deletes the [name] variable.
    COUNT [value] Returns the number of variables equal to the given value [value].        
    BEGIN: Open a transaction.
    ROLLBACK: Undo all commands from the current transaction.
    COMMIT: Save the result of all operations from the current transaction.
    EXIT: Terminate the program

    ************************************************************************************ 
  """ + "\n"
  end 
   

end