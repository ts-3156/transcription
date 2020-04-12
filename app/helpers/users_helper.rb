module UsersHelper
  def current_user_plan
    if user_signed_in?
      if current_user.paid?
        :paid
      else
        :login
      end
    else
      :guest
    end
  end

  def current_user_plan_text
    t("layouts.application.user_plan.#{current_user_plan}")
  end

end
