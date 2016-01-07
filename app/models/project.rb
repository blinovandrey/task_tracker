class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :tasks, dependent: :destroy
  belongs_to :creator, class_name: "User"
  validates(:title, presence: true)
end
