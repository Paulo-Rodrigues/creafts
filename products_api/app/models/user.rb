class User
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :external_id

  validates :external_id, presence: true
end
