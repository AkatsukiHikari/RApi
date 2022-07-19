class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user, only: %i[login create]
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    page = params[:page]
    limit = params[:limit]
    # response params
    count = nil
    data = {}
    if page.nil? && limit.nil?
      @users = User.all
      hash = UserSerializer.new(@users).serializable_hash
      hash = hash[:data].map { |user| ( user[:attributes] ) }

      data[:data] = hash
      count = @users.length
    else
      @page , @records = pagy( User.all , :page => page , :items => limit )
      data = UserSerializer.new(@records).serializable_hash
      count = @page.count
    end


    data[:count] = count

    make_response( data )
  end

  # GET /users/1
  def show
    user = UserSerializer.new(@user).serializable_hash
    make_response( {:data => user[:data][:attributes]} )
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      hash = UserSerializer.new(@user).serializable_hash
      make_response( hash )
    else
      make_error(202, @user.errors.full_messages, :unprocessable_entity)
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      make_response( UserSerializer.new(@user).serializable_hash )
    else
      make_error( 203 , @user.errors.full_messages , :unprocessable_entity)
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    make_response( UserSerializer.new(@user).serializable_hash )
  end

  # 登陆授权
  def login
    user = User.where(:name => login_params[:name]).first
    if user&.authenticate( login_params[:password] )
      token = JsonWebToken.encode( :user_id => user.id )
      render json: { :code => 0 , :token => token }
    else
      render json: { :errors => "User Not Fount or Password Invalidate" }, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password, :email, :avatar)
    end

    def login_params
      params.permit!
    end
end
