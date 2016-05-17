class Project < ActiveRecord::Base
  has_many :project_users
  has_many :tasks
  has_many :users, through: :project_users

  before_destroy :validate_no_started_or_finished_tasks

  accepts_nested_attributes_for :tasks, :allow_destroy => true

  def force_destroy
    @@force = true
    Project.destroy(self.id)
    @@force = false
  end

  def validate_no_started_or_finished_tasks
    unless can_be_destroyed || @@force
      self.errors.add(:base, "can't destroy")
      return false
    end
  end

  def can_be_destroyed
    for task in self.tasks
      if task.started? || task.finished?
        return false
      end
    end
    true
  end
end
