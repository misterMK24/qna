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
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
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

  describe 'GET #edit' do
    let(:user_with_questions) { create(:user, :with_question, amount: 1) }
    let(:question) { user_with_questions.questions.first }

    context 'author' do
      it 'renders edit view' do
        login(user_with_questions)
        get :edit, params: { id: question.id }

        expect(response).to render_template :edit
      end
    end

    context 'third person' do
      let(:user) { create(:user) }

      it 'redirects to root page' do
        login(user)
        get :edit, params: { id: question.id }
        
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #update' do
    let(:user_with_questions) { create(:user, :with_question, amount: 1) }
    let(:question) { user_with_questions.questions.first }

    context 'author' do
      before { login(user_with_questions) }

      context "with valid attributes" do
        it 'update question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }  
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirects to updated question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(response).to redirect_to question
        end

      end

      context "with invalid attributes" do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

        it 'does not change the question' do
          question.reload

          expect(question.title).to eq 'Title'
          expect(question.body).to eq 'Body'
        end

        it 're-renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'third person' do
      before do
        login(user)
        patch :update, params: { id: question, question: attributes_for(:question) }
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
