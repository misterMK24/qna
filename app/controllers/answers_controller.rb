class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = current_user.answers.new(answer_params) 
    @answer.question = question

    if @answer.save
      redirect_to question, notice: "Answer has been posted successfully"
    else
      flash[:error] = @answer.errors.full_messages
      redirect_to question
    end
  end

  def edit
    if current_user.is_author?(answer)
      render :edit
    else
      redirect_to root_path, notice: 'You are not author of this answer'
    end
  end

  def update
    if current_user.is_author?(answer)
      if answer.update(answer_params)
        redirect_to question, notice: 'Answer has been updated successfully.'
      else
        render :edit
      end
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
