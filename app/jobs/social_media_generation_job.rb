class SocialMediaGenerationJob < ApplicationJob
  queue_as :default

  SYSTEM_PROMPT = <<~PROMPT
    You are a creative social media marketing specialist for Sath Gym. Your task is to generate
    engaging Facebook posts that promote gym memberships, special offers, and services.

    Guidelines:
    - Write in an energetic, motivating tone that inspires fitness goals
    - Focus on benefits and transformations, not just features
    - Include a clear call-to-action (e.g., "Visit us today!", "Limited spots available!")
    - Keep posts concise (150-300 words ideal for Facebook)
    - Use emojis strategically for visual appeal (fitness: 💪, celebration: 🎉, etc.)
    - Highlight specific pricing, plans, or promotions when relevant
    - Create urgency when appropriate ("Limited time offer!", "Sign up this week!")
    - Address common pain points (busy schedules, beginner anxiety, cost concerns)

    Post Types to Generate (rotate):
    1. New member promotion with pricing details
    2. Facility highlight (equipment, classes, amenities)
    3. Success story / transformation inspiration
    4. Limited-time discount or seasonal offer
    5. Class schedule or new program announcement

    Format:
    - Start with an attention-grabbing hook
    - 2-3 short paragraphs with line breaks
    - End with clear call-to-action
    - Include 3-5 relevant hashtags (e.g., #SathGym #FitnessJourney #GymLife)

    Use the available tools to fetch current products, pricing, gym statistics, and recent
    member activity to make posts accurate and data-driven. Leverage real attendance data
    to create authentic posts about gym activity and member engagement.
  PROMPT

  def perform(post_id)
    post = SocialMediaPost.find(post_id)

    Rails.logger.info "Starting generation for post ##{post.id}"

    # Generate post content using RubyLLM
    result = generate_post_content

    Rails.logger.info "Generated result: #{result.inspect}"

    # Update the post with generated content and token usage
    post.update!(
      content: result[:content],
      input_tokens: result[:input_tokens],
      output_tokens: result[:output_tokens],
      cached_tokens: result[:cached_tokens]
    )

    Rails.logger.info "Post ##{post.id} updated successfully. Content length: #{post.content&.length}"

    # Broadcast update via Turbo Stream
    broadcast_update(post)

  rescue => e
    Rails.logger.error "Social media generation failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    post.update(
      content: "Error generating content. Please try again.",
      status: :draft
    )
    raise
  end

  private

  def generate_post_content
    # Create a chat-like interface for the LLM
    chat = Chat.create!
    chat.with_tools(ProductLookup, GymStatsLookup, RecentActivityLookup)

    # Use the chat's ask method with streaming
    response_content = ""
    chat.with_instructions(SYSTEM_PROMPT).ask(generate_prompt) do |chunk|
      response_content += chunk.content if chunk.content
    end

    # Get the last message which contains the complete response
    last_message = chat.messages.reload.last

    result = {
      content: last_message&.content || response_content,
      input_tokens: last_message&.input_tokens || 0,
      output_tokens: last_message&.output_tokens || 0,
      cached_tokens: last_message&.cached_tokens || 0
    }

    Rails.logger.info "Generated content length: #{result[:content]&.length || 0}"
    Rails.logger.info "Content preview: #{result[:content]&.truncate(100)}"

    # Clean up the temporary chat after extracting the content
    chat.destroy

    result
  end

  def generate_prompt
    post_types = [
      "Generate a Facebook post promoting our gym membership plans with current pricing",
      "Create a post highlighting our gym facilities and equipment",
      "Write an inspirational post about fitness transformations and success stories",
      "Generate a limited-time promotion post with urgency and clear call-to-action",
      "Create a post announcing our class schedule and encouraging participation",
      "Create a post celebrating recent member activity and gym engagement using real attendance data"
    ]

    post_types.sample
  end

  def broadcast_update(post)
    Turbo::StreamsChannel.broadcast_replace_to(
      "social_media_posts",
      target: "post_#{post.id}",
      partial: "social_media/partials/post_row",
      locals: { post: post }
    )
  end
end
