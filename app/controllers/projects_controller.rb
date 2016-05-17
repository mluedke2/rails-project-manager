class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :require_user_allow_admin, only: [:edit, :update]
  before_action :require_user, only: [:destroy]
  before_action :require_login

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.page(params[:page]).per(10)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @tasks = @project.tasks
  end

  # GET /projects/new
  def new
    @project = Project.new
    @project.tasks.build
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.users += [current_user]

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: @project.errors.empty? ? "" : @project.errors[:base].first }
      format.json { head :no_content }
    end
  end

  def clear_old
    @projects = Project.all
    @projects.each do |project|
      next unless project.updated_at < (DateTime.now - 7.days)
      catch :unfinished do
        project.tasks.each do |task|
          throw :unfinished unless task.finished?
        end
        puts "delete"
      end
    end
    redirect_to projects_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def require_user_allow_admin
      require_user unless current_user.is_admin?
    end

    def require_user
      unless @project.users.include?(current_user)
        redirect_to projects_url, notice: 'Unauthorized to do this.'
      end
    end

    def require_login
      redirect_to "/" if current_user.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, tasks_attributes: [:id, :name, :description, :status, :_destroy])
    end
end
