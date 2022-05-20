class UserLogs
  @@userLogs = []

  
  def self.get_userLogs
    @@userLogs
  end
  
  # Begin new transaction
  def self.set_new_logs_block
    @@userLogs << []
  end    
  
  # Delete last transaction logs
  def self.delete_last_logs_block
    @@userLogs.delete_at(-1)
  end
  
  # Delete all transactions logs
  def self.delete_all_logs_blocks 
    if @@userLogs.empty?
      puts "No transaction"
    else
      @@userLogs.clear
    end  
  end     
end