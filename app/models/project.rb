class Project < ActiveRecord::Base
  has_many :project_users
  has_many :tasks
  has_many :users, through: :project_users

  accepts_nested_attributes_for :tasks, :allow_destroy => true

  def destroy
    if canBeDestroyed
      super
    else
      raise "can't destroy"
    end
  end

  def canBeDestroyed
    for task in self.tasks
      if task.started? || task.finished?
        return false
      end
    end
    true
  end
end
