require 'lib/filterbubble/database.rb'

class WelcomeController < ApplicationController
  def index
    @test="test2"
  end
  def get_binding
    binding
  end
end
