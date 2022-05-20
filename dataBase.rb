require_relative './userLogs.rb'
require_relative './application.rb'

class DataBase
  @@dataBase = Hash.new("nil")
  @@valuesCounter = Hash.new(0)
  
  
  def self.set_value(key, value)
    oldValue = DataBase.get_value(key)
    DataBase.get_value(key) == "nil" ? delete_log(key) : set_log(key, oldValue)    
    if @@dataBase.has_key?(key)
      if oldValue != value 
          reduce_value_in_valueCounter(oldValue)
          increase_value_in_valueCounter(value)
      end
    else
      increase_value_in_valueCounter(value)
    end
    @@dataBase.store(key, value)    
  end  

  def self.get_value(key)
    @@dataBase[key]
  end 
  
  def self.delete_value(key)
    reduce_value_in_valueCounter(@@dataBase[key])
    set_log(key, @@dataBase[key])
    @@dataBase.delete(key)        
  end  

  def self.count_value(value)
    @@valuesCounter[value]
  end  

  

  private
  
  def self.set_log(key, value = 0)
    if UserLogs.get_userLogs.size > 0 && Application.get_rollback == false
      UserLogs.get_userLogs.last.push("Set #{key} #{value}")
    end  
  end  
  
  def self.delete_log(key)
    if UserLogs.get_userLogs.size > 0 && Application.get_rollback == false
      UserLogs.get_userLogs.last.push("Delete #{key}")
    end  
  end  
  
  def self.increase_value_in_valueCounter(value)
    @@valuesCounter.has_key?(value) ? @@valuesCounter[value] +=1 : @@valuesCounter.store(value, 1)
  end
  
  def self.reduce_value_in_valueCounter(value)
    @@valuesCounter[value] > 1 ? @@valuesCounter[value] -=1 : @@valuesCounter.delete(value)
  end 

end