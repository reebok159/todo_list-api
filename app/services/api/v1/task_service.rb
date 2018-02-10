class Api::V1::TaskService
  def initialize(task, params)
    @task = task
    @params = params
  end

  def update
    return change_priority if @params[:priority]
    @task.update(@params)
  end

  def change_priority
    case @params[:priority]
    when 'up' then @task.move_higher
    when 'down' then @task.move_lower
    else false
    end
  end
end
