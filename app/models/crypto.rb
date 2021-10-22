class Crypto < ApplicationRecord
  validates :name, presence: true
  validates :ticker, presence: true, uniqueness: true
end
