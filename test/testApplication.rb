require "../userLogs.rb"
require "../dataBase.rb"
require "../application.rb"
require 'test/unit'

class TestApplication < Test::Unit::TestCase
   

  def test_basic_1
    DataBase.set_value("a", "10")
    assert_equal("10", DataBase.get_value("a"))
    DataBase.delete_value("a")
    assert_equal("nil", DataBase.get_value("a"))
  end 
  
  def test_basic_2
    DataBase.set_value("a", "10")
    DataBase.set_value("b", "10")
    assert_equal(2, DataBase.count_value("10"))
    assert_equal(0, DataBase.count_value("20"))
    DataBase.delete_value("a")
    assert_equal(1, DataBase.count_value("10"))
    DataBase.set_value("b", "30")
    assert_equal(0, DataBase.count_value("10"))
  end 

  def test_transaction_1
    UserLogs.set_new_logs_block
    DataBase.set_value("a", "10")
    assert_equal("10", DataBase.get_value("a"))
    UserLogs.set_new_logs_block
    DataBase.set_value("a", "20")
    assert_equal("20", DataBase.get_value("a"))
    Application.execute_rollback
    assert_equal("10", DataBase.get_value("a"))
    Application.execute_rollback
    assert_equal("nil", DataBase.get_value("a"))
  end  

  def test_transaction_2
    UserLogs.set_new_logs_block  
    DataBase.set_value("a", "30")
    UserLogs.set_new_logs_block 
    DataBase.set_value("a", "40")
    UserLogs.delete_all_logs_blocks
    assert_equal("40", DataBase.get_value("a"))
    assert_equal("No transaction", Application.execute_rollback)
  end  

  def test_transaction_3
    DataBase.set_value("a", "50")
    UserLogs.set_new_logs_block
    assert_equal("50", DataBase.get_value("a"))    
    DataBase.set_value("a", "60")
    UserLogs.set_new_logs_block
    DataBase.delete_value("a")
    assert_equal("nil", DataBase.get_value("a"))
    Application.execute_rollback
    assert_equal("60", DataBase.get_value("a"))
    UserLogs.delete_all_logs_blocks
    Application.execute_rollback
    assert_equal("60", DataBase.get_value("a"))
  end  

  def test_transaction_4
    DataBase.set_value("a", "10")
    UserLogs.set_new_logs_block
    assert_equal(1, DataBase.count_value("10"))
    UserLogs.set_new_logs_block
    DataBase.delete_value("a")
    assert_equal(0, DataBase.count_value("10"))
    Application.execute_rollback
    assert_equal(1, DataBase.count_value("10"))
  end 
end