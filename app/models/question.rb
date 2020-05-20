class Question < ActiveRecord::Base

  has_many :answers
  belongs_to :user

  scope :not_private, -> { where(private: false) }
end
