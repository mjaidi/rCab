module CardHelper
  def card_content_p(title, content, options = {title_classes: '', content_classes: '', wrapper_classes: ''})
    title = content_tag(:span, "#{title}", class: "card-content-title #{options[:title_classes]}")
    content = content_tag(:span, "#{content == '' ? '---' : content}", class: "card-content-content #{options[:content_classes]}")
    if I18n.locale == :ar
      content_tag(:p, safe_join([content,title]), class: "card-content-wrapper #{options[:wrapper_classes]}")
    else
      content_tag(:p, safe_join([title, content]), class: "card-content-wrapper #{options[:wrapper_classes]}")
    end
  end
end
