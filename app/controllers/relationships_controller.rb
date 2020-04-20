class RelationshipsController < ApplicationController
  
  def create
    relationship = Relationship.create(:user_id => params[:user_id], :follower_id => current_user.id)
    render json: { id: relationship.id, user_id: params[:user_id] }
  end

  def destroy
    relationship = Relationship.where(:user_id => params[:user_id], :follower_id => current_user.id).first
    relationship.destroy()
    render json: {message: 'deleted successfully'}
  end

end
