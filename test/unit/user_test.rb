require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users, :items, :jobs, :tasks, :recurrings

  #############################################################################
  #                          C L A S S    M E T H O D S                       #
  #############################################################################
  def test_authenticate
    assert_equal users(:jordan), User.authenticate('jordan@test.com', 'test')
  end
  
  def test_fail_authenticate_wrong_password
    assert_nil User.authenticate('jordan@test.com', 'wrong')
  end
  
  def test_create_with_hash
    user = User.new :email=>'test@test.com', :time_zone=>'US', :password=>'test', :password_confirmation=>'test'
    assert user.valid?
  end
  
  def test_fail_create_no_password
    user = User.new :email=>'test@test.com', :time_zone=>'US'
    assert !user.valid?
  end
  
  def test_no_password_confirmation
    user = User.new :email=>'test@test.com', :time_zone=>'US', :password=>'test'
    assert !user.valid?
    assert_equal @@error[:not_confirmed], user.errors.on(:password)
    assert_equal @@error[:blank], user.errors.on(:password_confirmation)
  end
  
  def test_update_password
    user = users(:jordan)
    user.password = 'newpassword'
    user.password_confirmation = 'newpassword'
    assert user.valid?
    user.save
    assert_equal users(:jordan), User.authenticate('jordan@test.com', 'newpassword')
  end
  
  def test_change_password_without_confirmation
    user = users(:jordan)
    user.password = 'newpassword'
    assert !user.valid?
    assert_equal users(:jordan), User.authenticate('jordan@test.com', 'test')
  end
  
  def test_update_without_password
    user = users(:jordan)
    user.email = 'new@test.com'
    assert user.valid?
    user.save
    assert_equal users(:jordan), User.authenticate('new@test.com', 'test')
  end
  
  #############################################################################
  #                         R E L A T I O N S H I P S                         #
  #############################################################################
  def test_items
    assert_equal items(:sals, :panera), users(:jordan).items
  end
  
  def test_jobs
    assert_equal [jobs(:dms), jobs(:risi), jobs(:toms)], users(:jordan).jobs
    assert_equal [jobs(:dms), jobs(:risi)], users(:jordan).jobs.active
  end
  
  def test_recurrings
    assert_equal [recurrings(:rent)], users(:jordan).recurrings
  end
  
  def test_tasks
    assert_equal [tasks(:explain_search)], users(:jordan).tasks
  end
  
  #############################################################################
  #                   P R O T E C T E D    A T T R I B U T E S                #
  #############################################################################
  def test_protected_attributes
    user = users(:jordan)
    assert_raise ActiveRecord::ProtectedAttributeAssignmentError do
      user.update_attributes(:email=>'new@new.com', :password_hash=>'hash', :password_salt=>'salty', :created_at=>Date.new(2000,1,1).to_time)
    end
  end
  
  #############################################################################
  #                          V A L I D A T I O N                              #
  #############################################################################
  def test_presence_on_create
    user = User.new
    assert !user.valid?
    assert_equal @@error[:blank], user.errors.on(:time_zone)
    assert_equal @@error[:blank], user.errors.on(:password_confirmation)
  end
  
  def test_email_uniqueness
    user = users(:jordan).clone
    assert !user.valid?
    assert_equal @@error[:taken], user.errors.on(:email)
  end
  
  def test_email_format
    user = users(:jordan)
    %w{test.com test@testcom testtestcom @test.com test@test test.com test@test.}.each do |address|
      user.email = address
      assert !user.valid?
      assert_equal @@error[:invalid], user.errors.on(:email)
    end
  end
  
  #############################################################################
  #                             T O T A L I N G                               #
  #############################################################################
  def test_total_on
    assert_equal 37, users(:jordan).total_on(Date.today)
    assert_equal 0, users(:jordan).total_on(1.year.ago)
  end
  
  def test_total_during_alias_for_range
    assert_equal 37, users(:jordan).total_during(this_week)
  end
  
  def test_total_this_week
    assert_equal 37, users(:jordan).total_this_week
    assert_equal 0,  users(:jordan).total_this_week(6.weeks.ago.to_date)
  end
  
  def test_total_this_month
    assert_equal 37, users(:jordan).total_this_month
    assert_equal 0,  users(:jordan).total_this_month(6.months.ago.to_date)
  end
  
  def test_total_this_year
    assert_equal 37, users(:jordan).total_this_year
    assert_equal 0,  users(:jordan).total_this_year(1.year.ago.to_date)
  end
  
  def test_activity_during?
    # Single day
    assert  users(:jordan).activity_during?(Date.today)
    # Empty range
    assert !users(:jordan).activity_during?(Date.new(2005, 1, 1)..Date.new(2005, 12, 31))
    # Reversed range
    assert  users(:jordan).activity_during?(Date.today..(Date.today - 6))
  end
  
  #############################################################################
  #                       I N C O M E  /  E X P E N S E S                     #
  #############################################################################
  def test_sum_income
    assert_equal 0, users(:jordan).sum_income(this_week)
    assert_equal 0, users(:jordan).sum_income(Date.today)
  end
  
  def test_sum_expenses
    assert_equal -13, users(:jordan).sum_expenses(this_week)
    assert_equal -13, users(:jordan).sum_expenses(Date.today)
  end
  
  #############################################################################
  #                                    T A S K S                              #
  #############################################################################
  def test_value_unpaid_tasks
    assert_equal 50, users(:jordan).value_unpaid_tasks_on(Date.today)
    assert_equal 50, users(:jordan).value_unpaid_tasks_during(this_week)
  end
  
  #############################################################################
  #                              D E S T R O Y                                #
  #############################################################################
  def test_destroy
    users(:jordan).destroy
    assert_raise(ActiveRecord::RecordNotFound){items(:sals)}
    assert_raise(ActiveRecord::RecordNotFound){jobs(:risi)}
    assert_raise(ActiveRecord::RecordNotFound){recurrings(:rent)}
  end
end
