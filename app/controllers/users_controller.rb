class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  
  def index
    @list_of_users = User.all.order({ :username => :asc })
    if current_user != nil
      @followed_users_for_current_user = FollowRequest.where({ :sender_id => current_user.id})
    end 
    render({ :template => "users/index" })
  end
end
