# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :require_authentication

    def index
      respond_to do |format|
        format.html do
          @pagy, @users = pagy User.order(created_at: :desc)
        end

        format.zip { respond_with_zipped_users }
      end
    end

    def create
      if params[:archive].present?
        service = UserBulkService.call(params[:archive])

        if service&.error_message
          flash[:warning] = service.error_message
        else
          flash[:success] = t('.success')
        end
      else
        flash[:warning] = 'Please select a file to upload.'
      end

      redirect_to admin_users_path
    end

    private

    def respond_with_zipped_users
      compressed_filestream = Zip::OutputStream.write_buffer do |zos|
        User.order(created_at: :desc).each do |user|
          zos.put_next_entry "user_#{user.id}.xlsx"
          zos.print render_to_string(
            layout: false, handlers: [:axlsx], formats: [:xlsx], template: 'admin/users/user', locals: { user: }
          )
        end
      end

      compressed_filestream.rewind
      send_data compressed_filestream.read, filename: 'users.zip'
    end
  end
end
