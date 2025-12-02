module MembersHelper

  def status_icons
    { "active" => "icon--check-check", "inactive" => "icon--circle-off", "draft" => "icon--circle-dashed" }
  end

  def priority_icons
    { "high" => "icon--arrow-up", "low" => "icon--arrow-down", "medium" => "icon--arrow-right" }
  end

  def display_value(value)
    value.presence || "--"
  end
end
