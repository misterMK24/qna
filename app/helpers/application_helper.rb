module ApplicationHelper
  def link_to_file(file)
    link_to file.filename.to_s, url_for(file), class: "ml-2"
  end

  def link_delete_file(file)
    link_to 'delete', attachment_path(file), remote: true, method: :delete
  end
end
