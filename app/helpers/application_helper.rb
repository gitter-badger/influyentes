module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def bootstrap_alert_class_for(flash_type)
    case flash_type
      when "success" then "alert-success" # Green
      when "error"   then "alert-danger"  # Red
      when "alert"   then "alert-warning" # Yellow
      when "notice"  then "alert-info"    # Blue
      else
        flash_type.to_s
    end
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(with_toc_data: true, escape_html: true)
    markdown = Redcarpet::Markdown.new(renderer,
      no_intra_emphasis: true,
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      space_after_headers: true,
      superscript: true,
      underline: true,
      highlight: true,
      quote: true,
      footnotes: true,
    )
    markdown.render(text).html_safe
  end
end
