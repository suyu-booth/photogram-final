class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  
  def index
    @list_of_users = User.all.order({ :username => :asc })
    if current_user != nil
      @followed_users_for_current_user = FollowRequest.where({ :sender_id => current_user.id})
    end 
    render({ :template => "users/index" })
  end

  def show
    @the_username = params.fetch("selected_username")

    @the_user = User.where({ :username => @the_username }).at(0)

    @user_photos = @the_user.photos.order({ :likes_count => :desc })
    
    if @the_username == current_user.username
      @followers = @the_user.followers
      @followers_all_status = @the_user.followers_all_status
      @followers_pending = @the_user.followers_pending

      @following = @the_user.leaders
      @following_all_status = @the_user.leaders_all_status
      @following_pending = @the_user.leaders_pending

      render({ :template => "users/self" })
    else 
      render({ :template => "users/show" })
    end 
  end
end
