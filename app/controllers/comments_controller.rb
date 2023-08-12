# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authorize
  before_action :set_comment, only: %i[show update destroy]

  # GET /comments
  def index
    if params[:page].present? && params[:per_page].present?
      @comments = Comment.page(params[:page]).per(params[:per_page])
    else
      @comments = Comment.all
    end

    render json: { comments: @comments }
  end

  # GET /comments/1
  def show
    render json: { comment: @comment }
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: { comment: @comment }, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: { comment: @comment }
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:comment, :file, :user_id, :commentable_id, :commentable_type)
  end
end
