class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    if current_user.author?(@attachment.record)
      @attachment.purge
    else
      redirect_to root_path, notice: "You are not author of this #{@attachment.record.class.name}"
    end
  end
end
