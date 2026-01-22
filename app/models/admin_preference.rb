class AdminPreference < ApplicationRecord
  belongs_to :user
  validates :key, presence: true
end
