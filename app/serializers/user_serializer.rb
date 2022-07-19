class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :phone, :sex, :address, :description, :created_at, :updated_at, :role, :avatar_url
end
