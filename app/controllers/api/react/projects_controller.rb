class Api::React::ProjectsController < Api::React::ApiController
  
  # GET api/react/projects
  def index
    projects = Project.order('position DESC')
    render json: projects, each_serializer: ProjectSerializer, status: :ok
  end
  
  # POST api/react/projects
  def create
    project = Project.new(project_params)
    if project.save
      render json: project, serializer: ProjectSerializer, status: :ok
    else
      render json: { errors: project.errors.full_messages }, status: :bad_request
    end
  end
  
  # PUT/PATCH api/react/projects/:id
  def update
    project = Project.find(params[:id])
    if project.update(project_params)
      render json: project, serializer: ProjectSerializer, status: :ok
    else
      render json: { errors: project.errors.full_messages }, status: :bad_request
    end
  end
  
  # DELETE api/react/projects/:id
  def destroy
    project = Project.find(params[:id])
    project.destroy
    render json: {}, status: :ok
  end
  
  # POST api/react/projects/sort
  def sort
    params[:project_ids].reverse.each_with_index do |id, index|
      Project.where(id: id).update_all(position: index + 1)
    end
    render json: {}, status: :ok
  end
  
  private
  
    def project_params
      params.require(:project).permit(:description, :html_description, :title)
    end
end