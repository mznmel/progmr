module CommentsHelper
  def nested_comments(comments)
    comments.map do |comment, childs|
      chds = content_tag(:div, nested_comments(childs), :class => "nested nestedComment-#{comment.id}")
      render(comment, :childs => chds)
    end.join.html_safe
  end
end
