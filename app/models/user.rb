class User < ApplicationRecord
    has_secure_password
    validates :name , presence: true , uniqueness: true
    validates :password , presence: true, length: {minimum:6, maximum:10}
    validates :email , format: { with: URI::MailTo::EMAIL_REGEXP } , uniqueness: true , :unless => Proc.new{|f| f.email.nil?}

end