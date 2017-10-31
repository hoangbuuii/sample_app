class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.select_id_name_email.order_created_at.paginate page: 
      params[:page], per_page: Settings.per_page
  end

  def new
  	@user = User.new
  end

  def show
    @microposts = @user.microposts.order_by_created_at_desc
      .paginate page: params[:page], per_page: Settings.per_page
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_email_to_activate"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".user_cannot_be_deleted"
    end
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit :name, :email, :password, :password_confirmation
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t "please_log_in"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find_by id: params[:id]
      redirect_to(root_url) unless @user.current_user?(current_user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.is_admin?
    end

    def load_user
      @user = User.find_by id: params[:id]
      return if @user
      flash[:warning] = t ".cannot_find_user"
      redirect_to root_path
    end
end
