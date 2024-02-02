class MeccasController < ApplicationController
  before_action :jwt_authenticate, only: [:create, :update]

    def index
      @meccas = Mecca.all
    end

    def show
      
    end
  
    def create
     
    end
  
    def update
    
    end
  
    private
  
    def authenticate
    
    end
  
end