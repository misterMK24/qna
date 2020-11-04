require 'rails_helper'

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
    let(:user_with_answers) { create(:user_with_answers) }

    context 'author' do
      before { login(user_with_answers) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: user_with_answers.authored_answers.first, question_id: question.id } }.to change(user_with_answers.authored_answers, :count).by(-1)
      end

      it 'redirects to question page' do
        delete :destroy, params: { id: user_with_answers.authored_answers.first , question_id: question.id }

        expect(response).to redirect_to question
      end
    end

    context 'third person' do
      let(:third_person) { create(:user) }
      before { login(third_person) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: user_with_answers.authored_answers.first , question_id: question.id } }.to_not change(user_with_answers.authored_answers, :count)
      end

      it 'redirects to qeustion page' do
        delete :destroy, params: { id: user_with_answers.authored_answers.first , question_id: question.id }

        expect(response).to redirect_to question
      end
    end
  end
end
