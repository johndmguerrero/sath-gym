RubyLLM.configure do |config|
  config.anthropic_api_key = ENV['ANTHROPIC_API_KEY']
  config.default_model = 'claude-3-5-haiku-20241022'
  # Use the new association-based acts_as API (recommended)
  config.use_new_acts_as = true
end
