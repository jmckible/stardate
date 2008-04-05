require File.dirname(__FILE__) + '/../test_helper'

class JobTest < Test::Unit::TestCase
  fixtures :jobs, :users, :tasks, :paychecks
  #############################################################################
  #                           C L A S S    M E T H O D S                      #
  #############################################################################
  def test_find_active
    assert_equal [jobs(:dms), jobs(:risi), jobs(:starbucks)], Job.active
  end
  #############################################################################
  #                            R E L A T I O N S H I P S                      #
  #############################################################################
  def test_user
    assert_equal users(:jordan), jobs(:risi).user
  end
  
  def test_paychecks
    assert_equal [paychecks(:last_week)], jobs(:starbucks).paychecks
    assert_equal [paychecks(:april)], jobs(:risi).paychecks.unpaid
  end
  
  def test_tasks
    assert_equal [tasks(:explain_search)], jobs(:risi).tasks
    assert_equal [tasks(:explain_search)], jobs(:risi).tasks.on(Date.today)
    assert_equal [tasks(:explain_search)], jobs(:risi).tasks.within((Date.today-1)..(Date.today+1))
    assert_equal [tasks(:explain_search)], jobs(:risi).tasks.unpaid
    assert_equal 30, jobs(:risi).tasks.minutes_on(Date.today)
    assert_equal 0, jobs(:risi).tasks.minutes_on(1.year.ago)
  end
  
  #############################################################################
  #                                P R O T E C T E D                          #
  #############################################################################
  def test_protected
    job = jobs(:risi)
    assert_raise ActiveRecord::ProtectedAttributeAssignmentError do
      job.update_attributes(:name=>'new', :user_id=>2, :created_at=>1.year.ago)
    end
  end
  
  #############################################################################
  #                              V A L I D A T I O N                          #
  #############################################################################
  def test_uniqueness
    job = jobs(:risi).clone
    assert !job.valid?
    assert_equal @@error[:taken], job.errors.on(:name)
  end
  
  def test_presence
    job = Job.new
    assert !job.valid?
    assert_equal @@error[:blank], job.errors.on(:user_id)
    assert_equal @@error[:blank], job.errors.on(:name)
    assert job.errors.on(:rate).include?(@@error[:blank])
  end
  
  def test_numericality
    job = jobs(:risi)
    job.rate = 'fake'
    assert !job.valid?
    assert_equal @@error[:not_a_number], job.errors.on(:rate)
  end
  
  def test_limit_50_job
    user = users(:new_guy)
    1.upto(50) do |i|
      user.jobs.create :name=>"Job #{i}", :rate=>100
    end
    job = user.jobs.build :name=>'Too many', :rate=>100
    assert !job.valid?
    assert_equal 'too many jobs', job.errors.on(:user)
  end
  
  #############################################################################
  #                                  D E S T R O Y                            #
  #############################################################################
  def test_destroy
    jobs(:risi).destroy
    assert_raise(ActiveRecord::RecordNotFound){tasks(:explain_search)}
    assert_raise(ActiveRecord::RecordNotFound){paychecks(:april)}
  end
end
