class CustomersController < ApplicationController

  def index
    @customers = Customer.all
     @customer = current_customer
  end

  def show
     @customer = Customer.find(params[:id])
     @posts = @customer.posts.page(params[:page])
  end

  def edit
     @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    redirect_to customer_path(@customer.id)
  end

  def favorites
    @customer = Customer.find(params[:id])
    favorites= Favorite.where(customer_id: @customer.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end


  private

  def customer_params
    params.require(:customer).permit(:name, :profile_image, :title)
  end
end
