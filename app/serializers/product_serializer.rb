class ProductSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :price, :availability
  belongs_to :user

  cache_options enable:true, cache_lenght: 12.hours
end
