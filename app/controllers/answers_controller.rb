class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = current_user.answers.new(answer_params) 
    @answer.question = question
    @answer.save
  end

  def update
    @question = answer.question
    if current_user.is_author?(answer)
      answer.update(answer_params)
    else
      redirect_to root_path, notice: 'You are not author of this answer'
    end
  end
  
  def destroy
    if current_user.is_author?(answer)
      answer.destroy
      redirect_to question, notice: 'Answer has been successfully deleted'
    else
      redirect_to question, notice: 'You are not author of this answer'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question, :answer
end
