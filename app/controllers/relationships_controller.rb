class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    check_valid @user
    current_user.follow @user
    response_to_user
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    check_valid @user
    current_user.unfollow @user
    response_to_user
  end

  private

  def check_valid user
    return if user
    flash[:warning] = t "cannot_find_user"
    redirect_to root_path
  end

  def response_to_user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
