class ApplicationController < ActionController::API
    # 引入权限控制
    include Pundit::Authorization
    # 引入分页
    include Pagy::Backend
    before_action :authenticate_user
    rescue_from ActiveRecord::RecordNotFound , with: :record_not_found
    rescue_from Pundit::NotAuthorizedError, with: :unauthorized_access

    '''
    # 接口调用前验证用户是否登录
    # controller里开放接口可通过skip_before_action跳过验证
    '''
    def authenticate_user
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        if header
            begin
                @decode = JsonWebToken::decode(header)
                @current_user = User.find(@decode[:user_id])
            rescue ActiveRecord::RecordNotFound => e
                render json: { :errors => e.message } , status: :unauthorized
            rescue JWT::DecodeError=> e
                render json: { :errors => "Session expired , Please Login again."} , status: :unauthorized
            end
        else
            render json: { :errors => "Authentication Token not provided."} , status: :unauthorized
        end
    end

    # 接口正确数据
    def make_response( data )
        data[:code] = 0
        render json: data , status: :ok
    end

    # 返回错误接口
    def make_error( code ,  message = "Unknown Error" )
        render json: { :code => code , :message => message } , status: :internal_server_error
    end

    private
    # 数据没有找到统一返回错误
    def record_not_found
        render json: { :errors => "Record not found."}, status: :not_found
    end

    # 权限认证失败统一返回
    def unauthorized_access
        render json: { :errors => "You have no permission to access this api"} , status: :forbidden
    end
end
