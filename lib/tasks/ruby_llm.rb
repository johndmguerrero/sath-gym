namespace :ruby_llm do
  desc "Load Models for RubyLLM and save to db"
  task load_models: :environment do
    RubyLLM.model.load_from_json!
    Model.save_to_database
  end
end