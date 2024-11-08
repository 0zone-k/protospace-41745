class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy] 
  before_action :move_to_index, except: [:index, :show ]

  
  def index
    @prototypes = Prototype.includes(:user)
  
  end
  def new
    @prototype = Prototype.new
    
  end

  def create
    @prototypes = Prototype.new(prototype_params)
    if @prototypes.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])

  end

  def update
    prototype = Prototype.find(params[:id])
    if prototype.update(prototype_params)
       redirect_to prototype_path, notice: 'Updated successfully.'
    else
      render edit, status: :unprocessable_entity
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end
end

private
    def prototype_params
      params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
    end

    def move_to_index
     unless user_signed_in? && current_user.id != Prototype.name
      redirect_to action: :index
     end
    end
