class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.authored_questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your quesion successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if question.update(question_params)
      redirect_to question, notice: 'Your quesion successfully created.'
    else
      render :new
    end
  end

  def destroy
    if question.author == current_user
      question.destroy
      redirect_to questions_path, notice: 'Question has been successfully deleted'
    else
      redirect_to questions_path, notice: 'You are not author of this question'
    end
  end

  private

  def question
    @question ||= Question.find(params[:id])
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
