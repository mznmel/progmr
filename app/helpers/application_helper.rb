module ApplicationHelper
  def markdown(text)
    Kramdown::Document.new(text).to_html.html_safe
  end

  def gravatar(email)
      emailMd5 = Digest::MD5.hexdigest(email)
      "http://gravatar.com/avatar/#{emailMd5}?s=32"
  end
end
