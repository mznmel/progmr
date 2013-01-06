module CommentsHelper
  def nested_comments(comments)
    comments.map do |comment, childs|
      render(comment) + content_tag(:div, nested_comments(childs), :class => "nested nestedComment-#{comment.id}" )
    end.join.html_safe
  end
end
