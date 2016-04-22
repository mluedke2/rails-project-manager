class Project < ActiveRecord::Base
  has_many :project_users
  has_many :tasks
  has_many :users, through: :project_users

  accepts_nested_attributes_for :tasks, :allow_destroy => true
end
