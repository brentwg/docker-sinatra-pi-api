class User
  include Mongoid::Document

  field :user_id,   type: String
  field :firstname, type: String
  field :lastname,  type: String
  field :email,     type: String

end
