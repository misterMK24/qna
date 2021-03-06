class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @best_answer = question.best_answer
    @other_answers = question.answers.where.not(id: question.best_answer_id)
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your quesion successfully created.'
    else
      render :new
    end
  end

  def edit
    if current_user.author?(question)
      render :edit
    else
      redirect_to root_path, notice: 'You are not author of this question'
    end
  end

  def update
    if current_user.author?(question)
      question.update(question_params)
    else
      redirect_to root_path, notice: 'You are not author of this question'
    end
  end

  def mark_best
    if current_user.author?(question)
      answer = Answer.with_attached_files.find(params[:answer])
      @old_best_answer = question.best_answer
      question.mark_as_best(answer)
    else
      redirect_to root_path, notice: 'You are not author of this question'
    end
  end

  def destroy
    if current_user.author?(question)
      question.destroy
      redirect_to questions_path, notice: 'Question has been successfully deleted'
    else
      redirect_to questions_path, notice: 'You are not author of this question'
    end
  end

  private

  def question
    @question ||= Question.with_attached_files.find(params[:id])
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, :best_answer_id,
                                     files: [], links_attributes: %i[name url id _destroy],
                                     reward_attributes: %i[title image id _destroy])
  end
end
