class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.page(params[:page]).per(10)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "新規投稿が完了しました"
      redirect_to post_path(@post.id)
    else
      render :new
    end
  end

  def show
    @post_comment = PostComment.new
  end

  def edit
    if @post.user == current_user
      render :edit
    else
      posts_path
    end
  end

  def update
    @post.update(post_params)
    flash[:notice] = "投稿内容を変更しました"
    redirect_to post_path(@post.id)
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :spot_image, :star, :address)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path
    end
  end
end
