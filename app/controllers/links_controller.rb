class LinksController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    @link = Link.find(params[:id])
    if current_user.is_author?(@link.linkable)
      @link.destroy
    else
      redirect_to root_path, notice: "You are not author of this #{@link.linkable.class.to_s}"
    end
  end
end
