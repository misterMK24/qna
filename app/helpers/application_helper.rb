module ApplicationHelper
  def link_to_file(file)
    link_to file.filename.to_s, url_for(file), class: "ml-2"
  end

  def link_delete_file(file)
    link_to 'delete', attachment_path(file), remote: true, method: :delete
  end

  def to_link(link)
    link_to link.name, link.url, class: "my-2"
  end

  def to_gist_link(link)
    "<code data-gist-id= '#{link.gist_id}' data-gist-line='1-5' data-gist-hide-line-numbers='true'></code>".html_safe
  end

  def to_delete_gist_link(link)
    "<p>#{link_to 'delete', link_path(link), remote: true, method: :delete}</p>".html_safe
  end

  def to_delete_link(link)
    link_to 'delete', link_path(link), remote: true, method: :delete
  end
end
