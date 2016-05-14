module Admin
  class UsersController < Admin::ApplicationController
    def create
      resource = resource_class.new(resource_params)

      if resource.save
        redirect_to(
          [namespace, resource],
          notice: message_create_success("users.create.success", random_password),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    private

    def resource_params
      params.require(resource_name).permit(*permitted_attributes).
        merge(password: random_password, password_confirmation: random_password)
    end

    def random_password
      @random_password ||= (0...8).map { (65 + rand(26)).chr }.join
    end

    def message_create_success(key, password)
      t(
        "administrate.controller.#{key}",
        resource: resource_resolver.resource_title,
        password: password
      )
    end
  end
end
