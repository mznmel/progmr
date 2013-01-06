class CommentsController < ApplicationController
  before_filter :login_required

  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(:parent_id => params[:parent_id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params[:comment])
    @comment.user_id = current_user.id
    if @comment.save
      respond_to do |format|
        format.html { redirect_to post_path(@comment.post_id.to_s(36)), notice: (t :commentSuccessfulylAdded)}
        format.js
      end
    else
      respond_to do |format|
        #format.html { redirect_to post_path(@comment.post_id.to_s(36))}
        format.json { render :json => @comment.errors }
      end
    end
  end
end
