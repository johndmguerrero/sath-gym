module ApplicationHelper

  GYM_GOERS_MENU = ["members", "attendances", "plans"].freeze

  def breadcrumbs_divider
    '<span class="icon icon--chevron-right" aria-hidden="true"></span>'.html_safe
  end

  def gym_goers_menu
    GYM_GOERS_MENU
  end

  def gym_goers_menu_open?
    GYM_GOERS_MENU.include?(controller_name)
  end

  # Custom link_to that adds aria-current="page" when on current page
  def nav_link_to(name = nil, options = nil, html_options = nil, &block)
    # Handle block syntax: link_to(url, options) { content }
    if block_given?
      html_options = options
      options = name
    end

    # Add aria-current if on current page
    html_options ||= {}
    if current_page?(options)
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

end
