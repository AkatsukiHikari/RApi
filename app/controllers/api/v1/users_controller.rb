class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user, only: %i[login create]
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    page = params[:page]
    limit = params[:limit]


    if page.nil? && limit.nil?
      begin
        @users = User.all
        make_response({ :data => @users.as_json(except: [:password_digest]) , :count => @users.length })
      rescue
        make_error( 201  )
      end
    else
      @page , @records = pagy( User.all , :page => page , :items => limit )
      make_response( {:data => @records.as_json(except: [:password_digest]) , :page => @page.count})
    end
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
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
      params.require(:user).permit(:name, :password_digest, :email, :phone, :avatar, :sex, :address, :description)
    end

    def login_params
      params.permit!
    end
end
