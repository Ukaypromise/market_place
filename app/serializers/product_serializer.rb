class ProductSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :price, :availability
end
