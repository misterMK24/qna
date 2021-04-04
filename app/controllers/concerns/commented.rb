module Commented
  extend ActiveSupport::Concern

  included do
    before_action :current_commentable, only: %i[create_comment]
  end

  def create_comment
    @comment = current_user.comments.new(comment_params)
    @comment.commentable = @commentable
    @comment.save
  end

  def destroy_comment
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def current_commentable
    @commentable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
