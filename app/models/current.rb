class Current < ActiveSupport::CurrentAttributes
  attribute :household, :user

  def user=(user)
    super
    Current.household = user.household
  end
end
