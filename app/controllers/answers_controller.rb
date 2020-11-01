class AnswersController < ApplicationController
  def index
    @answers = question.answers 
  end

  def new
    @answer = question.answers.new
  end

  def create
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to question, notice: "Answer has been posted successfully"
    else
      flash[:error] = @answer.errors.full_messages
      redirect_to question
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
