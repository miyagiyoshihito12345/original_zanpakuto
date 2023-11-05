module OpenAiActions
  extend ActiveSupport::Concern

  private

  def chat(input, additional_prompt)
    response = @client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: additional_prompt },
          { role: "user", content: input },
        ],  
        temperature: 1.2,
      })  

    response.dig("choices", 0, "message", "content")
  end 
end
