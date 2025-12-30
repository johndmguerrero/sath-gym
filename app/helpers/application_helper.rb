module ApplicationHelper
  include Pagy::Frontend

  GYM_GOERS_MENU = ["members", "attendances", "products"].freeze
  PAYMENTS_MENU = ["transactions", "renewals", "invoices"].freeze
  MACHINES_MENU = ["equipments", "equipment_categories"].freeze

  def breadcrumbs_divider
    '<span class="icon icon--chevron-right" aria-hidden="true"></span>'.html_safe
  end

  def machines_menu
    MACHINES_MENU
  end

  def machines_menu_open?
    MACHINES_MENU.include?(controller_name)
  end

  def payment_menu
    PAYMENTS_MENU
  end

  def payment_menu_open?
    PAYMENTS_MENU.include?(controller_name)
  end

  def gym_goers_menu
    GYM_GOERS_MENU
  end

  def gym_goers_menu_open?
    GYM_GOERS_MENU.include?(controller_name)
  end

  # Custom link_to that adds aria-current="page" when on current page or child routes
  def nav_link_to(name = nil, options = nil, html_options = nil, &block)
    # Handle block syntax: link_to(url, options) { content }
    if block_given?
      html_options = options
      options = name
    end

    # Add aria-current if on current page or child routes
    html_options ||= {}
    if current_or_child_page?(options)
      html_options[:aria] ||= {}
      html_options[:aria][:current] = "page"
    end

    # Call original link_to
    if block_given?
      link_to(options, html_options, &block)
    else
      link_to(name, options, html_options)
    end
  end

  # Calculate age from date of birth to current date
  def calculate_age(date_of_birth)
    return nil unless date_of_birth

    now = Time.current.to_date
    age = now.year - date_of_birth.year
    age -= 1 if now.month < date_of_birth.month || (now.month == date_of_birth.month && now.day < date_of_birth.day)
    age
  end

  private

  # Check if current page matches the given path or is a child route
  def current_or_child_page?(options)
    return false unless options

    # Check if exactly on the given page
    return true if current_page?(options)

    # Get the URL path for the options
    target_path = url_for(options) rescue nil
    return false unless target_path

    # Normalize paths (remove trailing slashes and query params)
    target_path = target_path.split('?').first.chomp('/')
    current_path = request.path.chomp('/')

    # Don't match root path
    return false if target_path.empty? || target_path == "/"

    # Check if current path starts with the target path followed by a slash
    # This ensures /members matches /members/1/edit but not /members_old
    current_path.start_with?("#{target_path}/")
  end

end
