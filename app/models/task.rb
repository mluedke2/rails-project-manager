class Task < ActiveRecord::Base
  belongs_to :project
  enum status: [ :unstarted, :started, :finished ]
end
