class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @project = Project.find(params[:project_id])

    @task = Task.create(task_params)

    @project.tasks << @task

    redirect_to project_path(@project)

    # respond_to do |format|
    #   if @task.save
    #     format.html { redirect_to @task, notice: 'Task was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @task }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @task.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { render :json => {message: :success} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task, :project).permit(:name, :description, :status)
    end
end
