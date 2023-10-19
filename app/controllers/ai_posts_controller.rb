class AiPostsController < ApplicationController

  def new; end
  def aaaaa
    render :ai_generate
  end

  def ai_generate
    ai_validation
    @ability = params[:ability]
    @atmosphere = params[:atmosphere]
    @bankai_say = params[:bankai]
    @meigen = params[:meigen]
    @kangi = params[:kangi_text]
    @shikai = "日本刀の名前を考えて下さい。
    能力は#{@ability}で、日本刀の雰囲気は#{@atmosphere}です。
    ただし、名前に#{@kangi}という漢字を含むようにして下さい。"
    @client = OpenAI::Client.new
    response = @client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: "質問には漢字で答えてください。漢字の横に()でふりがなを添えて下さい。解答例は、氷輪丸(ひょうりんまる)です" },
          { role: "user", content: @shikai },
        ],
        temperature: 1,
      })
    @shikai = response.dig("choices", 0, "message", "content")
    @bankai = "日本刀「#{@shikai}」の名前をもっとカッコよくした名前を考えて下さい。
    能力は#{@ability}で、日本刀の雰囲気は#{@atmosphere}です。
    ただし、名前に#{@kangi}という漢字を含むようにして下さい。"
    response = @client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: "質問には漢字で答えてください。漢字の横に()でふりがなを添えて下さい。解答例は、氷輪丸(ひょうりんまる)です" },
          { role: "user", content: @bankai },
        ],                
        temperature: 1,
      })  
    @bankai = response.dig("choices", 0, "message", "content")
    if match_data = @shikai.match(/(.+?)\((.+?)\)/)
      @shikai = match_data[1]  # 漢字部分
      @shikai_hurigana = match_data[2]  # ふりがな部分
    end
    if match_data = @bankai.match(/(.+?)\((.+?)\)/)
      @bankai = match_data[1]  # 漢字部分
      @bankai_hurigana = match_data[2]  # ふりがな部分
    end
    end

    private

    def ai_validation
      return if params[:ability].present? && params[:atmosphere].present? && params[:bankai].present? && params[:kangi_text].present?
      flash.now['danger'] = '必須項目に回答してください'
      render :new, status: :unprocessable_entity
    end
  end
