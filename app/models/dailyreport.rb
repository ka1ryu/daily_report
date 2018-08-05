class Dailyreport < ApplicationRecord
  belongs_to :user

  default_scope -> {order(created_at: :desc)}

  validates :user_id, presence: true,uniqueness: {
    scope: :user_id,
    conditions: -> { where("DATE(created_at) = '#{Date.today}'") },
  }
  validates :content, presence: true, length: {maximum: 1000}
end
