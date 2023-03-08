class RelationshipsController < ApplicationController
  def create
    #current_customer.follow(params[:customer_id])
     @customer = Customer.find(params[:customer_id])
    following = current_customer.follow(params[:customer_id])
    following.save
    #redirect_to request.referer
    @customer.create_notification_follow!(current_customer)
  end
  # フォロー外すとき
  def destroy
    #current_customer.unfollow(params[:customer_id])
     @customer = Customer.find(params[:customer_id])
     following = current_customer.unfollow(params[:customer_id])
     following.destroy
    #redirect_to request.referer
  end

  def followings
     @customer = Customer.find(params[:customer_id])
    @customers = @customer.followings
  end

  def followers
    @customer = Customer.find(params[:customer_id])
    @customers = @customer.followers
  end
end
