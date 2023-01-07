class HomesController < ApplicationController
  def top
    @main_tasks = MainTask.all
  end
end
