class PostCommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    comment = current_customer.post_comments.new(post_comment_params)
    comment.post_id = post.id
    if comment.save
     redirect_to post_path(post), notice: 'コメントを投稿しました'
    else
        @error_comment = comment
        @post = Post.find(params[:post_id])
        @post_comment = PostComment.new
        render 'posts/show'
    end

  end

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_to post_path(params[:post_id]), alert: 'コメントを削除しました'
  end


  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end
