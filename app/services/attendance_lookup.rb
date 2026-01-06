class AttendanceLookup < RubyLLM::Tool
  description "Look up gym attendance records. Can fetch today's check-ins or last 24 hours attendance. Returns member details with check-in timestamps."

  def name
    "attendance_lookup"
  end

  params do
    string :timeframe, description: "Time period to query: 'today' for current day check-ins, 'last_24_hours' for recent 24h. Defaults to 'today' if not specified."
  end

  def execute(timeframe: "today")
    attendances = case timeframe
    when "last_24_hours"
      Attendance.logged_last_24_hours.order(created_at: :desc)
    when "today"
      Attendance.includes(:user)
                .where("DATE(created_at) = ?", Date.current)
                .order(created_at: :desc)
    else
      # Default to today for any other value
      Attendance.includes(:user)
                .where("DATE(created_at) = ?", Date.current)
                .order(created_at: :desc)
    end

    {
      success: true,
      timeframe: timeframe,
      count: attendances.count,
      attendances: attendances.map do |attendance|
        {
          id: attendance.id,
          check_in_time: attendance.created_at.iso8601,
          check_in_time_formatted: attendance.created_at.strftime("%B %d, %Y at %I:%M %p"),
          member: {
            customer_number: attendance.user.customer_number,
            name: attendance.user.fullname,
            subscription_status: attendance.user.subscription_status_badge
          },
          remarks: attendance.remarks
        }
      end
    }

  rescue => e
    {
      success: false,
      error: "An error occurred: #{e.message}"
    }
  end
end
