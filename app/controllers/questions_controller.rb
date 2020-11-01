class QuestionsController < ApplicationController
  # TODO : back to before_action :question, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    question
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your quesion successfully created.'
    else
      render :new
    end
  end

  def edit
    question
  end

  def update
    # question
    # @question = Question.new(question_params)
    if question.update(question_params)
      redirect_to question, notice: 'Your quesion successfully created.'
    else
      render :new
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path
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
