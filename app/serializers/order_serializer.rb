class OrderSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :user
  has_many :products

  cache_options enable:true, cache_lenght: 12.hours
end
