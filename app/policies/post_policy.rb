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
end
