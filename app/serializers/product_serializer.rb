class ProductSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :price, :availability
  belongs_to :user
end
