RubyLLM.configure do |config|
  config.anthropic_api_key = ENV['ANTHROPIC_API_KEY']
  # Use the new association-based acts_as API (recommended)
  config.default_model = 'claude-sonnet-4'
  config.use_new_acts_as = true
end
