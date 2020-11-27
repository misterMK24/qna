require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'should return an array of existed questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question.id } }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it "assigns new answer for question" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "assigns new link for answer" do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new Reward to @question' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context "with valid attributes" do
      it 'saves a new question into the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end

    end
    
    context "with invalid attributes" do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid ) }
        expect(response).to render_template :new
      end
    end    
  end

  describe 'PATCH #update', js: true do
    let(:user_with_questions) { create(:user, :with_question, amount: 1) }
    let(:question) { user_with_questions.questions.first }

    context 'author' do
      before { login(user_with_questions) }

      context "with valid attributes" do
        it 'update question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: 'js'  
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders update.js' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: 'js'

          expect(response).to render_template :update
        end

      end

      context "with invalid attributes" do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: 'js' }

        it 'does not change the question' do
          question.reload

          expect(question.title).to eq 'Title'
          expect(question.body).to eq 'Body'
        end

        it 'renders update.js' do
          expect(response).to render_template :update
        end
      end
    end

    context 'third person' do
      before do
        login(user)
        patch :update, params: { id: question, question: attributes_for(:question) }, format: 'js'
      end
      
      it 'does not change the question' do
        question.reload

        expect(question.title).to eq 'Title'
        expect(question.body).to eq 'Body'
      end

      it 'redirects to root page' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #mark_best', js: true do
    let!(:question) { create(:question, :with_answer) }
    let(:answer) { question.answers.first }
    let!(:reward) { create(:reward, question: question) }
    
    context 'author' do
      let(:user_with_question) { question.user }
  
      before do
        login(user_with_question)
        patch :mark_best, params: { id: question, answer: answer.id }, format: 'js'
      end

      it 'marks a specified answer as the best' do
        question.reload

        expect(question.best_answer).to eq answer
      end

      it 'rewards an author of the answer' do
        expect(answer.user.rewards.first).to eq reward
      end

      it 'renders mark_best.js' do
        expect(response).to render_template :mark_best
      end
    end
  
    context 'third person' do
      before do
        login(user)
        patch :mark_best, params: { id: question, question: { best_answer_id: answer.id } }, format: 'js'
      end

      it 'does not change the question' do
        question.reload

        expect(question.best_answer).to eq nil
      end

      it 'redirects to root page' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user_with_questions) { create(:user, :with_question, amount: 1) }
    let(:question) { user_with_questions.questions.first }

    context 'author' do
      before { login(user_with_questions) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(user_with_questions.questions, :count).by(-1)
      end

      it 'redirects to index page' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'third person' do
      before { login(user) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(user_with_questions.questions, :count)
      end

      it 'redirects to index page' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end
  end
end
