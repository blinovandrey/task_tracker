class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :tasks
  has_many :created_projects, class_name: "Project", foreign_key: 'creator_id'
  has_many :created_tasks, class_name: "Task", foreign_key: 'creator_id'
  has_many :executing_tasks, class_name: "Task", foreign_key: 'executor_id'

  validates(:email, presence: true)
  validates(:username, presence: true, uniqueness: { case_sensitive: false })
end
