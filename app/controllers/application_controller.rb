class ApplicationController < ActionController::Base
  def welcome 
    @greet = "Hello from Little Shop"
  end
end
