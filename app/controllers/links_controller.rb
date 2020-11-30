class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    @resource = @link.linkable
    @position = @resource.links.index(@link)
    if current_user.author?(@resource)
      @link.destroy
    else
      redirect_to root_path, notice: "You are not author of this #{@resource.class.name}"
    end
  end
end
