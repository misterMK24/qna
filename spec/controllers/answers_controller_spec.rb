require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { answer.question }
  let(:user_with_answer) { answer.user }

  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:user) { question.user }

    before { login(user) }

    context "with valid attributes" do
      it 'saves a new answer into the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(Answer, :count).by(1)
      end

      it 'redirects to question page' do
        post :create, params: { answer: attributes_for(:answer) , question_id: question }

        expect(response).to redirect_to question
      end

    end
    
    context "with invalid attributes" do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 'redirects to question page' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }

        expect(response).to redirect_to question
      end
    end
  end

  describe 'GET #edit' do
    context 'author' do
      it 'renders edit view' do
        login(user_with_answer)
        get :edit, params: { id: answer, question_id: question }

        expect(response).to render_template :edit
      end
    end

    context 'third person' do
      let(:user) { create(:user) }

      it 'redirects to root page' do
        login(user)
        get :edit, params: { id: answer, question_id: question }

        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'author' do
      before { login(user_with_answer) }

      context "with valid attributes" do
        it 'update answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question }  
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'redirects to updated question page' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }

          expect(response).to redirect_to question
        end
      end

      context "with invalid attributes" do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question } }

        it 'does not change the answer' do
          question.reload

          expect(question.body).to eq 'Body'
        end

        it 're-renders edit page' do
          expect(response).to render_template :edit
        end
      end
    end 

    context 'third person' do
      let(:user) { create(:user) }

      before do
        login(user)
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }
      end
      
      it 'does not change the answer' do
        answer.reload

        expect(question.body).to eq 'Body'
      end

      it 'redirects to root page' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author' do
      before { login(user_with_answer) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: user_with_answer.answers.first, question_id: question } }.to change(user_with_answer.answers, :count).by(-1)
      end

      it 'redirects to question page' do
        delete :destroy, params: { id: user_with_answer.answers.first , question_id: question }

        expect(response).to redirect_to question
      end
    end

    context 'third person' do
      let(:third_person) { create(:user) }
      before { login(third_person) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: user_with_answer.answers.first , question_id: question } }.to_not change(user_with_answer.answers, :count)
      end

      it 'redirects to qeustion page' do
        delete :destroy, params: { id: user_with_answer.answers.first , question_id: question }

        expect(response).to redirect_to question
      end
    end
  end
end
