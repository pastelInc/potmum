class ArticlePolicy < ApplicationPolicy
  def show?
    if record.published?
      if GlobalSetting.private_mode?
        user.member?
      else
        true
      end
    else
      user.id == record.user.id
    end
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
