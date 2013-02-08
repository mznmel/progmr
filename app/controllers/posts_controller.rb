require 'uri'
class PostsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :admins_only, :only => [:tFeatured, :tSticky]

  def index
    orderBy = "posts.created_at DESC"
    @orderBy = :date
    if params[:order]
      if params[:order] == "votes"
        orderBy = "posts.votes DESC"
        @orderBy = :votes
      elsif params[:order] == "comments"
        orderBy = "posts.comments_count DESC"
        @orderBy = :comments
      end
    end
    orderBy = "posts.sticky DESC," + orderBy

    featuredOnly = ""
    if params[:featuredOnly] == "true"
      featuredOnly = "featured = true"
    end

    if current_user
      @posts = Post.where(featuredOnly).paginate(:page => params[:page], :per_page => 10).all(
          :include => [:major_tag, :minor_tag, :extra_tag],
          :joins => [:user,
                     "LEFT OUTER JOIN post_votes ON post_votes.post_id = posts.id AND post_votes.user_id = #{current_user.id}"],
          :select => "posts.*, users.username, users.comments_karma, users.posts_karma, post_votes.vote", :order => orderBy)
    else
      @posts = Post.where(featuredOnly).order(orderBy).paginate(:page => params[:page], :per_page => 10)
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

  def tFeatured
    post = Post.find(params[:id].to_i(36))
    logger.debug post.title
    logger.debug "######################"
    post.featured = (not post.featured)
    if post.save
      Almailer.featured_notification(post).deliver
      post.user.increment!(:posts_karma, 5)
    end
    redirect_to post_path(post.id.to_s(36))
  end

  def tSticky
    post = Post.find(params[:id].to_i(36))
    post.sticky = (not post.sticky)
    post.save
    redirect_to post_path(post.id.to_s(36))
  end
end
