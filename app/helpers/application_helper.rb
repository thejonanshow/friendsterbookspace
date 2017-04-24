module ApplicationHelper
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? "active " : ""

    content_tag(:li, class: "nav-item") do
      link_to link_text, link_path, class: class_name + "nav-link"
    end
  end

  def nav_button(link_text, link_path, style = :success, method = :get)
    content_tag(:li, class: "nav-item") do
      button_to link_text, link_path, method: method, class: "btn btn-#{style}"
    end
  end
end
