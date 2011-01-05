class Clearance::UsersController < ApplicationController
  unloadable

  skip_before_filter :authenticate, :only => [:new, :create]
  before_filter :redirect_to_root,  :only => [:new, :create], :if => :signed_in?

  def new
    if params[:invite_token]
      @user = ::User.new(:invite_token => params[:invite_token])
      @user.email = @user.invite.email if @user.invite
      
      render :template => 'users/new'      
    else
      @applicant = Applicant.new
      render :template => '/users/invite_required'
    end
  end

  def create
    @user = ::User.new(params[:user])
    if @user.save
      flash_notice_after_create
      redirect_to(url_after_create)
    else
      render :template => 'users/new'
    end
  end

  private

  def flash_notice_after_create
    flash[:notice] = translate(:deliver_confirmation,
      :scope   => [:clearance, :controllers, :users],
      :default => "You will receive an email within the next few minutes. " <<
                  "It contains instructions for confirming your account.")
  end

  def url_after_create
    sign_in_url
  end
end
