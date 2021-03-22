module Voted
  extend ActiveSupport::Concern

  included do
    before_action :current_votable, only: %i[vote_resource vote_cancel]
  end

  def vote_resource
    @vote = Vote.new(user: current_user, votable: @votable, positive: params[:positive])

    respond_to do |format|
      if @vote.save
        format.json { render json: @votable.resource_rating }
      else
        format.json { render_errors }
      end
    end
  end

  def vote_cancel
    @vote = Vote.find_by(user: current_user, votable: @votable)
    return nil unless @vote

    respond_to do |format|
      @vote.destroy
      format.json { render json: @votable.resource_rating }
    end
  end

  private

  def current_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def render_errors
    render json: { errorMessages: @vote.errors.full_messages },
           status: :forbidden
  end
end
