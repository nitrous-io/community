module ApplicationHelper
  def full_controller_action_name
    class_name = "#{controller_path.gsub('/','_')} #{action_name}"
    class_name += ' fullscreen' if params[:fullscreen] == '1'
    class_name
  end

  def classify_string(str)
    return str unless str.is_a?(String)

    str.downcase.strip.gsub(/[^A-Za-z0-9]+/, "-")
  end
end