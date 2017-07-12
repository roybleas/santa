module ApplicationHelper
  #Add bootstrap glyphicon span tag
  def glyph(name)
    class_def = "glyphicon glyphicon-#{name.to_s}"
    content_tag :span, nil, class: "glyphicon glyphicon-#{name.to_s}" , :'aria-hidden' => "true"
  end
end
