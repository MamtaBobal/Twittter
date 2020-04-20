class TweeetsController < ApplicationController
  before_action :set_tweeet, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]


  # GET /tweeets
  # GET /tweeets.json
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 3
    following = User.includes(:tweeets).where(:id => current_user.id).first.following_users
    user_ids = following.pluck(:id) + [current_user.id]
    @tweeets = Tweeet.where(:user_id => user_ids).order(created_at: :desc).paginate(:page => params[:page], :per_page => 15) 
    @tweeet = Tweeet.new
    @current_user = current_user
    @can_be_followed = User.all - (Array(current_user))
  end

  # GET /tweeets/1
  # GET /tweeets/1.json
  def show
  end

  # GET /tweeets/new
  def new
    @tweeet = current_user.tweeets.build
  end

  # GET /tweeets/1/edit
  def edit
  end

  # POST /tweeets
  # POST /tweeets.json
  def create
    @tweeet = current_user.tweeets.build(tweeet_params)

    respond_to do |format|
      if @tweeet.save
        format.html { redirect_to tweeets_path, notice: 'Tweeet was successfully created.' }
        format.json { render :show, status: :created, location: @tweeet }
      else
        format.html { render :new }
        format.json { render json: @tweeet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweeets/1
  # PATCH/PUT /tweeets/1.json
  def update
    authorize @tweeet
    respond_to do |format|
      if @tweeet.update(tweeet_params)
        format.html { redirect_to @tweeet, notice: 'Tweeet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweeet }
      else
        format.html { render :edit }
        format.json { render json: @tweeet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweeets/1
  # DELETE /tweeets/1.json
  def destroy
    authorize @tweeet
    @tweeet.destroy
    respond_to do |format|
      format.html { redirect_to tweeets_url, notice: 'Tweeet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    @tweeet = Tweeet.find(params[:id])
    if @tweeet.parent.blank?
      Like.create(:user_id => current_user.id, :tweeet_id => params[:id])
    else
      Like.create(:user_id => current_user.id, :tweeet_id => @tweeet.parent_id)
    end
  end

  def dislike
    @tweeet = Tweeet.find(params[:id])
    tweeet_id = @tweeet.return_parent_or_self.id
    Like.where(:user_id => current_user.id, :tweeet_id => tweeet_id).first.destroy()
  end

  def retweeet
    @tweeet = Tweeet.find(params[:id]).return_parent_or_self
    new_tweeet = current_user.tweeets.build(parent_id: @tweeet.id, tweet: nil)
    new_tweeet.save!
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_tweeet
      @tweeet = Tweeet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tweeet_params
      params.require(:tweeet).permit(:tweet)
    end
end
