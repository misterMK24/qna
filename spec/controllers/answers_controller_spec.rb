require 'rails_helper'
# TODO: make specs for all actions

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context "with valid attributes" do
      it 'saves a new answer into the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id } }.to change(Answer, :count).by(1)
      end

      it 'redirects to question page' do
        post :create, params: { answer: attributes_for(:answer) , question_id: question.id }
        expect(response).to redirect_to question
      end

    end
    
    context "with invalid attributes" do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id } }.to_not change(Answer, :count)
      end

      it 'redirects to question page' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id }
        expect(response).to redirect_to question
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context "with valid attributes" do
      # it 'assigns the requested question to @question' do
      #   patch :update, params: { id: question, question: attributes_for(:question) }
      #   expect(assigns(:question)).to eq question
      # end

      it 'update answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question.id }  
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'redirects to updated question page' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question.id }

        expect(response).to redirect_to question
      end
    end

    context "with invalid attributes" do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question.id } }

      it 'does not change the answer' do
        question.reload

        expect(question.body).to eq 'Body'
      end

      it 're-renders question page' do
        expect(response).to render_template 'questions/show'
      end
    end    
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:answer) { create(:answer) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer , question_id: question.id } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question page' do
      delete :destroy, params: { id: answer , question_id: question.id }
      expect(response).to redirect_to question
    end
  end

end
