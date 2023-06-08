# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: :destroy

  def new; end

  def create
    user = User.find_by email: params[:email]
    if user&.authenticate(params[:password])
      sign_in user
      remember(user) if params[:remember_me] == '1'
      flash[:success] = "Welcome back, #{user.name}!"
      redirect_to root_path
    else
      print "!!!!!!!!!!!!!!!"
      flash.now[:warning] = 'Incorrect email and/or password'
      print "---------------"
      render :new
      print "+++++++++"
    end
  end

  def destroy
    sign_out
    flash[:success] = 'See you later!'
    redirect_to root_path
  end
end
