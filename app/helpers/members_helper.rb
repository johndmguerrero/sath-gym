module MembersHelper

  def status_icons
    { "active" => "icon--check-check", "walkins" => "icon--footprints", "deactivate" => "icon--user-x" }
  end

  def priority_icons
    { "high" => "icon--arrow-up", "low" => "icon--arrow-down", "medium" => "icon--arrow-right" }
  end
end
