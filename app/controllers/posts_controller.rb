require 'uri'
class PostsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]

  def index
    if current_user
      @posts = Post.all(
          :include => [:major_tag, :minor_tag, :extra_tag],
          :joins => [:user,
                     "LEFT OUTER JOIN post_votes ON post_votes.post_id = posts.id AND post_votes.user_id = #{current_user.id}"],
          :select => "posts.*, users.username, post_votes.vote", :order => "created_at DESC")
    else
      @posts = Post.all(:order => "created_at DESC")
    end
  end

  def show
    @post = Post.find(params[:id].to_i(36))
    if current_user
      @comment = Comment.new
      @comment.post = @post
      postVote = PostVote.where("user_id = ? AND post_id = ?", current_user.id, @post.id).first
      @postvote = postVote.vote if postVote
    end
  end

  def new
    @post = Post.new
  end

  def create
    # tags
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.prepare_tags(params[:major_tag], params[:minor_tag], params[:extra_tag])

    if @post.save
        @post.user.increment!(:posts_karma)
        redirect_to post_path(@post.id.to_s(36)), notice: (t :postSuccessfullyCreated)
    else
        # Should be refactored to a more ruby idiomatic way!
        render action: "new"
    end
  end

  def vote
    @postId = params[:id].to_i(36)
    @direction = params[:up_or_down] == "up" ? "up" : "down"

    postVote = PostVote.where("user_id = ? AND post_id = ?", current_user.id, @postId).first
    if postVote
      # if user already voted, destroy his vote
      orgVoteDirection = postVote.vote
      postVote.destroy
    end

    if postVote && ((@direction == "up" && orgVoteDirection == true) || (@direction == "down" && orgVoteDirection == false))
      # if clicked vote direction equals the previous one, then the user just want to remove his vote
      @status = "Removed"
    else
      # new vote or
      # the user clicked on vote direction that's different than the previous one

      post = Post.select("user_id, votes").find(@postId)

      if post.user_id == current_user.id
        @status = "CreatorAndVoterAreSame"
      else
        postVote = PostVote.new
        postVote.user_id = current_user.id
        postVote.post_id = @postId
        if @direction == "up"
          postVote.vote = true
          @status = "UpVoted"
        else
          postVote.vote = false
          @status = "DownVoted"
        end
        postVote.save
      end
    end
    #retrive updated votes
    @votes = Post.select("votes").find(@postId).votes

    respond_to do |format|
      format.js #render vote.js.erb
    end
  end

  def edit
    @post = Post.find(params[:id].to_i(36))

    if @post.user_id != current_user.id
      render :text => "422 You're Not Allowed to edit this post!", :status => 422
      return
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.prepare_tags(params[:major_tag], params[:minor_tag], params[:extra_tag])

    if @post.user_id != current_user.id
      render :text => "422 You're Not Allowed to edit this post!", :status => 422
      return
    end

    if @post.update_attributes(params[:post])
        redirect_to post_path(@post.id.to_s(36)), notice: 'Post was successfully updated.'
    else
      render action: "edit"
    end
  end

end
