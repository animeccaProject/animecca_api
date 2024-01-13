class UserController < ApplicationController
  def test
    test = "test OK"
    render json: test
  end
end
