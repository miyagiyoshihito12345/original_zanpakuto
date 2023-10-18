class AiPostsController < ApplicationController
  before_action :set_token, only: :ai_generate

  def index; end

  def ai_generate
    @query = "オリジナル斬魄刀の「始解」と「卍解」を考えて下さい。
    ただし、始解名と卍解名に「#{params[:text]}」という漢字を含むようにして下さい。
    答え方は【始解：〜(ふりがな) 卍解：〜(ふりがな)】と答えて下さい。オシャレでカッコいい斬魄刀にして下さい。"
    @client = OpenAI::Client.new(access_token: @api_key)
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: @query }],
      })

    @chats = response.dig("choices", 0, "message", "content")
  end

  private

  def set_token
    @api_key = Rails.application.credentials.dig(:openai, :api_key)
  end
end
