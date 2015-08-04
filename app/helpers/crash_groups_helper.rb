module CrashGroupsHelper
  def crash_status_tag(status)
    case status.to_i
    when 0
      content_tag :span, 'resolve', class: 'label label-success'
    when 1
      content_tag :span, 'multiple', class: 'label label-default'
    when 2
      content_tag :span, 'open', class: 'label label-danger'
    end
  end
end
