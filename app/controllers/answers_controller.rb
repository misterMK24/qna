class AnswersController < ApplicationController
  def index
    @answers = question.answers 
  end

  def create
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question
end
