class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    if @post.save
    redirect_to posts_path
    else
      render :new
    end
  end

  def index
     @posts = Post.page(params[:page])
  end

  def show
     @post = Post.find(params[:id])
     @post_comment = PostComment.new
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end


  private

  def post_params
    params.require(:post).permit(:title, :body, :image )
  end

end
