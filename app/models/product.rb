class Product < ApplicationRecord
  belongs_to :user

  validates :price, numericality: { greater_than_or_equal_to: 0}, presence: true
  validates :title, presence: true

  scope :filter_by_title, lambda { |query|
    where('lower(title) LIKE ?', "%#{query.downcase}%")
  }

  scope :above_or_equal_to_price, ->(price){
    where('price >= ?', price).order(:price)
  }

  scope :below_or_equal_to_price, ->(price){
    where('price <= ?', price).order(:price)
  }

  scope :recent, lambda {
    order(:updated_at)
  }
end
