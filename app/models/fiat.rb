class Fiat < ApplicationRecord
  validates :ticker, presence: true, uniqueness: true
end
