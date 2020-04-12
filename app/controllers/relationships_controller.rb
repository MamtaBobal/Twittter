class RelationshipsController < ApplicationController
  
  def create
    Relationship.create(:user_id => params[:user_id], :follower_id => current_user.id)
    render json: {user_id: params[:user_id]}
  end

end
