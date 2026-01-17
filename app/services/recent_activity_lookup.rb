class RecentActivityLookup < RubyLLM::Tool
  description "Fetches recent gym attendance activity statistics for social media content. Returns attendance counts, trends, peak times, and member activity patterns to help create engaging posts about gym activity."

  def name
    "recent_activity_lookup"
  end

  def execute
    {
      success: true,
      attendance_summary: attendance_summary,
      weekly_comparison: weekly_comparison,
      peak_hours: peak_hours,
      daily_breakdown: daily_breakdown,
      active_members_stats: active_members_stats,
      suggested_highlights: suggested_highlights
    }
  rescue => e
    {
      success: false,
      error: "An error occurred: #{e.message}"
    }
  end

  private

  def attendance_summary
    {
      today: Attendance.where("DATE(created_at) = ?", Date.current).count,
      yesterday: Attendance.where("DATE(created_at) = ?", Date.yesterday).count,
      this_week: Attendance.where(created_at: Date.current.beginning_of_week..Date.current.end_of_day).count,
      last_week: Attendance.where(created_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week).count,
      this_month: Attendance.where(created_at: Date.current.beginning_of_month..Date.current.end_of_day).count,
      last_month: Attendance.where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month).count
    }
  end

  def weekly_comparison
    this_week = Attendance.where(created_at: Date.current.beginning_of_week..Date.current.end_of_day).count
    last_week = Attendance.where(created_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week).count

    change_percentage = last_week.positive? ? ((this_week - last_week).to_f / last_week * 100).round(1) : 0

    {
      this_week_count: this_week,
      last_week_count: last_week,
      change_percentage: change_percentage,
      trend: change_percentage.positive? ? "increasing" : (change_percentage.negative? ? "decreasing" : "stable")
    }
  end

  def peak_hours
    # Get attendance by hour for the last 7 days
    hourly_counts = Attendance.where(created_at: 7.days.ago..Time.current)
                              .group("EXTRACT(HOUR FROM created_at)")
                              .count
                              .transform_keys(&:to_i)

    return { peak_hour: nil, busiest_times: [] } if hourly_counts.empty?

    sorted_hours = hourly_counts.sort_by { |_, count| -count }
    peak_hour = sorted_hours.first&.first

    {
      peak_hour: peak_hour,
      peak_hour_formatted: format_hour(peak_hour),
      busiest_times: sorted_hours.first(3).map { |hour, count| { hour: format_hour(hour), visits: count } }
    }
  end

  def daily_breakdown
    # Last 7 days breakdown
    (0..6).map do |days_ago|
      date = days_ago.days.ago.to_date
      count = Attendance.where("DATE(created_at) = ?", date).count

      {
        date: date.strftime("%A, %B %d"),
        day_name: date.strftime("%A"),
        count: count
      }
    end
  end

  def active_members_stats
    # Members who checked in at least once in different time periods
    {
      active_today: Attendance.where("DATE(created_at) = ?", Date.current).distinct.count(:user_id),
      active_this_week: Attendance.where(created_at: Date.current.beginning_of_week..Date.current.end_of_day).distinct.count(:user_id),
      active_this_month: Attendance.where(created_at: Date.current.beginning_of_month..Date.current.end_of_day).distinct.count(:user_id),
      total_registered_members: User.count,
      members_with_active_subscription: Subscription.active.distinct.count(:user_id)
    }
  end

  def suggested_highlights
    summary = attendance_summary
    comparison = weekly_comparison

    highlights = []

    # Highlight increasing activity
    if comparison[:trend] == "increasing" && comparison[:change_percentage] > 10
      highlights << "Gym activity is up #{comparison[:change_percentage]}% compared to last week!"
    end

    # Highlight busy month
    if summary[:this_month] > 100
      highlights << "Over #{summary[:this_month]} check-ins this month so far!"
    end

    # Highlight daily activity
    if summary[:today] > 20
      highlights << "#{summary[:today]} members have already worked out today!"
    end

    # Highlight active community
    active_stats = active_members_stats
    if active_stats[:active_this_week] > 50
      highlights << "#{active_stats[:active_this_week]} unique members stayed active this week!"
    end

    highlights
  end

  def format_hour(hour)
    return nil unless hour

    time = Time.current.beginning_of_day + hour.hours
    time.strftime("%I:%M %p")
  end
end
