class AiPostsController < ApplicationController
  skip_before_action :require_login, only: %i[aaaaa new ai_generate]
  before_action :ai_validation, only: %i[ ai_generate ]
  def new; end
  def aaaaa
    @ability = "氷雪系"
    @atmosphere = "かっこいい系"
    @bankai_say = "卍解!"
    @meigen = "憧れは、理解から最も遠い感情だよ"
    @kangi = "氷"
    @shikai = "氷輪丸"
    @shikai_hurigana = "ひょうりんまる"
    @bankai = "大紅蓮氷輪丸"
    @bankai_hurigana = "だいぐれんひょうりんまる"
    if logged_in?
      @post = current_user.posts.build(shikai: @shikai, shikai_hurigana: @shikai_hurigana, ability: "#{@ability}の斬魄刀です。", bankai: @bankai, bankai_hurigana: @bankai_hurigana, detail: @meigen, tag_list: Array[@ability,@atmosphere,@bankai_say])
    else
      @post = Post.new(shikai: @shikai, shikai_hurigana: @shikai_hurigana, bankai: @bankai, bankai_hurigana: @bankai_hurigana, detail: @meigen)
    end
    render :ai_generate
  end

  def new_ai
    @post = current_user.posts.build(post_params)
    @post.tag_list = @post.tag_list.first.split(" ")
  end

  def ai_generate
    @ability = params[:ability]
    @atmosphere = params[:atmosphere]
    @bankai_say = params[:bankai]
    @meigen = params[:meigen]
    @kangi = params[:kangi_text]
    @shikai = "斬魄刀の名前を考えて下さい。
    能力は#{@ability}で、斬魄刀の雰囲気は#{@atmosphere}です。
    ただし、名前に#{@kangi}という漢字を含むようにして下さい。"
    @client = OpenAI::Client.new
    response = @client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: "質問には漢字で答えてください。漢字の横に()でふりがなを添えて下さい。解答例は、氷輪丸(ひょうりんまる)です" },
          { role: "user", content: @shikai },
        ],
        temperature: 1.2,
      })
    @shikai = response.dig("choices", 0, "message", "content")
    @bankai = "斬魄刀「#{@shikai}」の卍解の名前を考えて下さい。
    能力は#{@ability}で、斬魄刀の雰囲気は#{@atmosphere}です。
    ただし、名前に#{@kangi}という漢字を含むようにして下さい。"
    response = @client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: "質問には漢字で答えてください。漢字の横に()でふりがなを添えて下さい。解答例は、大紅蓮氷輪丸(だいぐれんひょうりんまる)です" },
          { role: "user", content: @bankai },
        ],                
        temperature: 1.2,
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
    if logged_in?
      @post = current_user.posts.build(shikai: @shikai, shikai_hurigana: @shikai_hurigana, ability: "#{@ability}の斬魄刀です。", bankai: @bankai, bankai_hurigana: @bankai_hurigana, detail: @meigen, tag_list: Array[@ability,@atmosphere,@bankai_say])
    else
      @post = Post.new(shikai: @shikai, shikai_hurigana: @shikai_hurigana, bankai: @bankai, bankai_hurigana: @bankai_hurigana, detail: @meigen)
    end
  end

  private

  def ai_validation
    if params[:ability].present? && params[:atmosphere].present? && params[:bankai].present? && params[:kangi_text].present?
      if params[:kangi_text].match?(/\p{Han}/) && params[:kangi_text].length == 1
        ai_count
        return
      end
      flash.now['danger'] = '一文字の漢字を入力して下さい'
      render :new, status: :unprocessable_entity
    else
      flash.now['danger'] = '必須項目に回答してください'
      render :new, status: :unprocessable_entity
    end
  end

  def post_params
    params.require(:post).permit(:kaigo, :kaigo_hurigana, :shikai, :shikai_hurigana, :ability, :bankai, :bankai_hurigana, :detail, :tag_list)
  end 

  def ai_count
    if session[:count] == nil 
      session[:count] = 1 
    elsif session[:count] == 3
      flash.now['danger'] = '一日3回までしか使えません'
      render :new, status: :unprocessable_entity
    else
      session[:count] += 1
    end
  end

end
