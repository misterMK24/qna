class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = question
    @answer.save
  end

  def update
    @question = answer.question
    if current_user.author?(answer)
      answer.update(answer_params)
    else
      redirect_to root_path, notice: 'You are not author of this answer'
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
    else
      redirect_to question, notice: 'You are not author of this answer'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url id _destroy])
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question, :answer
end
