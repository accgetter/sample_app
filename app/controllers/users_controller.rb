class UsersController < ApplicationController
  before_action :signed_in_user,         only: [:index, :edit, :update, :destroy]
  before_action :correct_user,           only: [:edit, :update]
  before_action :delete_myself,          only: :destroy 
  before_action :admin_user,             only: :destroy
  before_action :already_signed_in_user, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end 

  def edit
  end 

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end 

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end 

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def already_signed_in_user
     redirect_to(root_path) if signed_in?
  end

  def delete_myself
    if params[:id] == current_user.id.to_s then
      redirect_to edit_user_path, notice: "You can't delete yourself" 
    end
  end
end
