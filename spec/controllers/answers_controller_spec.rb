require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { answer.question }
  let(:user_with_answer) { answer.user }

  describe 'POST #create', js: true do
    let(:question) { create(:question) }
    let(:user) { question.user }

    before { login(user) }

    context "with valid attributes" do
      it 'saves a new answer into the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: 'js' }.to change(Answer, :count).by(1)
      end

      it 'redirects to question page' do
        post :create, params: { answer: attributes_for(:answer) , question_id: question, format: 'js' }

        expect(response).to render_template :create
      end

    end
    
    context "with invalid attributes" do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: 'js' } }.to_not change(Answer, :count)
      end

      it 'redirects to question page' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: 'js' }

        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update', js: true do
    context 'author' do
      before { login(user_with_answer) }

      context "with valid attributes" do
        it 'update answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question, format: 'js' }  
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'redirects to updated question page' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question, format: 'js' }

          expect(response).to render_template :update
        end
      end

      context "with invalid attributes" do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question }, format: 'js' }

        it 'does not change the answer' do
          answer.reload

          expect(answer.body).to eq 'Body'
        end

        it 're-renders edit page' do
          expect(response).to render_template :update
        end
      end
    end 

    context 'third person' do
      let(:user) { create(:user) }

      before do
        login(user)
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }, format: 'js'
      end
      
      it 'does not change the answer' do
        answer.reload

        expect(answer.body).to eq 'Body'
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
