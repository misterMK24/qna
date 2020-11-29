require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy', js: true do
    let(:question) { create(:question, :with_attachment) }
    let(:user) { question.user }

    context 'when author' do
      before { login(user) }

      it 'deletes an attachment from question' do
        expect { delete :destroy, params: { id: question.files.first.id }, format: 'js' }.to change(question.files, :count).by(-1)
      end

      it 'renders destroy js template' do
        delete :destroy, params: { id: question.files.first.id }, format: 'js'

        expect(response).to render_template :destroy
      end
    end

    context 'when third person' do
      let(:third_person) { create(:user) }

      before { login(third_person) }

      it 'does not delete an attachment from question' do
        expect { delete :destroy, params: { id: question.files.first.id }, format: 'js' }.not_to change(question.files, :count)
      end

      it 'redirects to root page' do
        delete :destroy, params: { id: question.files.first.id }, format: 'js'

        expect(response).to redirect_to root_path
      end
    end
  end
end
