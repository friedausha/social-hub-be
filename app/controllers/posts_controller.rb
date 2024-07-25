class PostsController < ApplicationController
  before_action :authenticate_request, only: [:create]

  def index
    @posts = Post.order(created_at: :desc, id: :desc).limit(post_limit)
    if params[:before].present? && params[:last_id].present?
      @posts = @posts.where('(created_at, id) < (?, ?)', params[:before], params[:last_id].to_i)
    end

    render json: {
      posts: @posts,
      next_cursor: next_cursor(@posts)
    }
  end
  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def post_limit
    (params[:limit] || 10).to_i
  end
  def next_cursor(posts)
    return nil if posts.nil? || posts.size < post_limit

    last_post = posts.last
    {
      before: last_post.created_at,
      last_id: last_post.id
    }
  end
end
