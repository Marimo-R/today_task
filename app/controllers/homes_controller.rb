class HomesController < ApplicationController
  def top
    @main_tasks = MainTask.all
  end

  def about
  end
end
