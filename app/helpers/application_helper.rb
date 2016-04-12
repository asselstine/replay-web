module ApplicationHelper
  def flash_bootstrap_status_class(sym)
    case sym
    when :alert
      'danger'
    when :notice
      'info'
    when :warn
      'warning'
    else
      'info'
    end
  end
end
