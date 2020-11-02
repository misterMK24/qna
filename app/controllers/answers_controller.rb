class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to question, notice: "Answer has been posted successfully"
    else
      flash[:error] = @answer.errors.full_messages
      redirect_to question
    end
  end

  # TODO: is it necessary to implement an EDIT action?
  def update
    if answer.update(answer_params)
      redirect_to question, notice: 'Answer has been updated successfully'
    else
      render 'questions/show'
    end
  end
  
  def destroy
    answer.destroy
    redirect_to question, notice: 'Answer has been successfully deleted'
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
