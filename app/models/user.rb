class User < ApplicationRecord
  authenticates_with_sorcery!
    include Rails.application.routes.url_helpers

    has_one_attached :avatar
    has_secure_password

    validates :name , presence: true , uniqueness: true
    validates :password , presence: true, length: {minimum:6, maximum:10}
    validates :email , format: { with: URI::MailTo::EMAIL_REGEXP } , uniqueness: true , :unless => Proc.new{|f| f.email.nil?}

    def avatar_url
        avatar.attached? ? url_for( avatar ) : nil
    end
end