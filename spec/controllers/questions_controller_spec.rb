require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
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
    before { login(user) }
    before { get :edit, params: { id: question.id } }

    it 'renders show view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context "with valid attributes" do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

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

      it 're-renders new view' do
        expect(response).to render_template :new
      end
    end    
  end

  describe 'DELETE #destroy' do
    let(:user_with_questions) { create(:user_with_questions) }
  
    context 'author' do
      before { login(user_with_questions) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: user_with_questions.authored_questions.first } }.to change(user_with_questions.authored_questions, :count).by(-1)
      end

      it 'redirects to index page' do
        delete :destroy, params: { id: user_with_questions.authored_questions.first }

        expect(response).to redirect_to questions_path
      end
    end

    context 'third person' do
      let(:third_person) { create(:user) }
      before { login(third_person) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: user_with_questions.authored_questions.first } }.to_not change(user_with_questions.authored_questions, :count)
      end

      it 'redirects to index page' do
        delete :destroy, params: { id: user_with_questions.authored_questions.first }

        expect(response).to redirect_to questions_path
      end
    end
  end
end
