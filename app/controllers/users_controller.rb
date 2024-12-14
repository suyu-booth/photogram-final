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

    @followers = @the_user.followers
    @followers_all_status = @the_user.followers_all_status
    @followers_pending = @the_user.followers_pending

    @following = @the_user.leaders
    @following_all_status = @the_user.leaders_all_status
    @following_pending = @the_user.leaders_pending
    
    if @the_username == current_user.username


      render({ :template => "users/self" })
    else 
      self_following = current_user.leaders
      @self_following_the_user_tf = self_following.where(username: @the_username).exists?
      if @self_following_the_user_tf || !@the_user.private
        @the_follow_request = current_user.sent_follow_requests.where( :recipient_id => @the_user.id ).at(0)
        render({ :template => "users/show" })
      else 
        redirect_to("/", { :notice => "You're not authorized for that."} )
      end 
      
    end 
  end

  def liked_photos
    @the_username = params.fetch("selected_username")

    @the_user = User.where({ :username => @the_username }).at(0)

    @user_photos = @the_user.photos.order({ :likes_count => :desc })
    @user_liked_photos = @the_user.liked_photos.order({ :likes_count => :desc })

    @followers = @the_user.followers
    @followers_all_status = @the_user.followers_all_status
    @followers_pending = @the_user.followers_pending

    @following = @the_user.leaders
    @following_all_status = @the_user.leaders_all_status
    @following_pending = @the_user.leaders_pending
    
    render({ :template => "users/liked_photos" })
  end 

  def feed
    @the_username = params.fetch("selected_username")

    @the_user = User.where({ :username => @the_username }).at(0)

    @user_photos = @the_user.photos.order({ :likes_count => :desc })

    @followers = @the_user.followers
    @followers_all_status = @the_user.followers_all_status
    @followers_pending = @the_user.followers_pending

    @following = @the_user.leaders
    @following_all_status = @the_user.leaders_all_status
    @following_pending = @the_user.leaders_pending
    
    
    @feed_photos = @the_user.feed_photos

    render({ :template => "users/feed" })
  end 

  def discover
    @the_username = params.fetch("selected_username")

    @the_user = User.where({ :username => @the_username }).at(0)

    @user_photos = @the_user.photos.order({ :likes_count => :desc })

    @followers = @the_user.followers
    @followers_all_status = @the_user.followers_all_status
    @followers_pending = @the_user.followers_pending

    @following = @the_user.leaders
    @following_all_status = @the_user.leaders_all_status
    @following_pending = @the_user.leaders_pending
    
    
    @discovery_photos = @the_user.discovery_photos

    render({ :template => "users/discovery" })
  end 
end
