class PostPolicy < ApplicationPolicy
  def show?
    record_exist? && (
      record.published? ||
      ( record.preview_mode? && (record_of_user? || user.can_review?) )
    )
  end

  def create?
    user_identified? && !user_sanctioned?
  end

  def update?
    create? && record_exist? && ( record_of_user? ||
      (record.preview_mode? && user.can_review?) )
  end

  def submit?
    create? && record_exist? && record_of_user? && record.may_submit?
  end

  def publish?
    create? && record_exist? && user.can_publish? && record.may_publish?
  end

  def unpublish?
    create? && record_exist? && user.can_unpublish? && record.may_unpublish?
  end

  def delete?
    create? && record_exist? && user.can_delete? && record.may_delete?
  end

  class Scope < Scope
    def published
      resolve.published
    end

    def by_user
      resolve.where(user: user)
    end

    def in_review
      scope.in_review
    end
  end

  private

  def record_exist?
    scope.where(id: record.id).exists?
  end

  def record_of_user?
    record.user == user
  end

  # def record_published?
  #   record.published?
  # end
  #
  #
  # # Check if user can access to administration panel
  # def allowed_to_view?
  #   user && ( user.administrator? || user.moderator? || user.reviewer? )
  # end
  #
  # def allowed_to_edit?
  #   user && ( user.administrator? || user.moderator? )
  # end
  #
  # def allowed_to_publish?
  #   allowed_to_view? || record_of_user?
  # end
  #
  # def allowed_to_unpublish?
  #   allowed_to_edit? || record_of_user?
  # end


  # def can?(action)
  #   return false if banned? || deleted?
  #
  #   case action
  #   when "review"
  #     ( reviewer? || moderator? || administrator? )
  #   when "publish"
  #     ( reviewer? || moderator? || administrator? )
  #   when "unpublish"
  #     ( moderator? || administrator? )
  #   when "deleted"
  #     ( administrator? )
  #   else
  #     false
  #   end
  # end
  #
  # def can_review?
  #   reviewer? || moderator? || administrator?
  # end
end
