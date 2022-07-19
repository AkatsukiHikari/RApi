class Api::Spec::ExcelController < ApplicationController
  skip_before_action :authenticate_user

  #测试上传csv
  def upload_csv
    data = Lib::Utils::Book::parse_csv( params[:file] )
    puts data
    render json: data
  end
end
