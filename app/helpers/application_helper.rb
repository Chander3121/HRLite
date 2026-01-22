module ApplicationHelper
  include Heroicon::Engine.helpers
  def attendance_status_color(status)
    case status
    when "present"
      "bg-green-100 text-green-700"
    when "short_working"
      "bg-yellow-100 text-yellow-700"
    when "half_day"
      "bg-orange-100 text-orange-700"
    when "holiday"
      "bg-blue-100 text-blue-700"
    when "weekly_off"
      "bg-gray-100 text-gray-600"
    else
      "bg-red-100 text-red-700"
    end
  end

  def greeting_message
    hour = Time.now.hour

    if hour < 12
      "Good morning"
    elsif hour < 17
      "Good afternoon"
    else
      "Good evening"
    end
  end

  def dashboard_greeting(user)
    name =
      user.employee_profile&.first_name ||
      user.email.split("@").first.capitalize

    "#{greeting_message}, #{name}"
  end

  def sidebar_link(label, path, icon, count: nil, pulsing: false, badge_id: nil)
    active = current_page?(path)

    link_to path,
      class: "flex items-center justify-between px-3 py-2 rounded-lg
              #{active ? 'bg-indigo-50 text-indigo-700 font-medium'
                        : 'text-gray-700 hover:bg-gray-100'}" do

      concat(
        content_tag(:div, class: "flex items-center gap-3") do
          concat heroicon(icon, variant: :outline, options: { class: "h-5 w-5 text-gray-500" })
          concat content_tag(:span, label)
        end
      )

      if badge_id
        concat content_tag(
          :div,
          sidebar_badge(count: count, pulsing: pulsing),
          id: badge_id
        )
      end
    end
  end

  def sidebar_badge(count:, pulsing: false)
    return if count.to_i.zero?

    classes = "ml-2 min-w-[1.5rem] px-2 py-0.5 text-xs font-semibold
               text-white bg-red-600 rounded-full text-center"

    classes += " animate-pulse" if pulsing

    content_tag(:span, count, class: classes)
  end
end
