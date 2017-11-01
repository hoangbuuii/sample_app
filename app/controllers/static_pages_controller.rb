class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost  = current_user.microposts.build
    @feed_items = current_user.feed.order_by_created_at_desc
      .paginate page: params[:page], per_page: Settings.per_page
  end

  def help; end

  def about; end
  
  def contact; end
end
