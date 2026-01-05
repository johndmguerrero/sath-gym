# README

Sath Gym application


# when generating an structure output do this in anthropic

person_schema = {
  type: 'object',
  properties: {
    name: { type: 'string' },
    age: { type: 'integer' },
    hobbies: {
      type: 'array',
      items: { type: 'string' }
    }
  },
  required: ['name', 'age', 'hobbies'],
  additionalProperties: false  # Required for OpenAI structured output
}

# important the headers

chat = RubyLLM.chat.with_headers('anthropic-beta' => "structured-outputs-2025-11-13").with_params(output_format: { type: "json_schema", schema: person_schema})