module Api
  module V1
    class TaskService
      def initialize(task)
        @task = task
      end

      def update(params)
        @params = params
        return change_priority if @params[:priority]
        @task.update(@params)
      end

      private

      def change_priority
        case @params[:priority]
        when 'up' then @task.move_higher
        when 'down' then @task.move_lower
        else false
        end
      end
    end
  end
end
