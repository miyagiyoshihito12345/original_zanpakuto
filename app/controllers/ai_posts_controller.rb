class AiPostsController < ApplicationController
  include OpenAiActions

  skip_before_action :require_login, only: %i[aaaaa new ai_generate]
  before_action :ai_validation, only: %i[ ai_generate ]
  before_action :ai_shikai_ability_count, only: %i[ ai_ability ]
  before_action :ai_bankai_ability_count, only: %i[ ai_bankai_ability ]

  def new; end

  def aaaaa # 開発用
    user_input("氷雪系", "かっこいい系", "卍解!", "憧れは、理解から最も遠い感情だよ", "氷")
    if logged_in?
      @post = current_user.posts.build(
        kaigo: '蒼天に坐せ',
        kaigo_hurigana: 'そうてんにざせ',
        shikai: '氷輪丸',
        shikai_hurigana: 'ひょうりんまる',
        ability: "#{@ability}の斬魄刀です。", 
        bankai: '大紅蓮氷輪丸', 
        bankai_hurigana: 'だいぐれんひょうりんまる', 
        detail: @meigen, 
        tag_list: Array[@ability,@atmosphere,@bankai_say]
      )
    else
      @post = Post.new(
        kaigo: '蒼天に坐せ',
        kaigo_hurigana: 'そうてんにざせ',
        shikai: '氷輪丸', 
        shikai_hurigana: 'ひょうりんまる', 
        bankai: '大紅蓮氷輪丸', 
        bankai_hurigana: 'だいぐれんひょうりんまる', 
        detail: @meigen
      )
    end
    render :ai_generate
  end

  def new_ai
    @post = current_user.posts.build(post_params)
    @post.tag_list = @post.tag_list.first.split(" ")
  end

  def ai_generate
    user_input(params[:ability], params[:atmosphere], params[:bankai], params[:meigen], params[:kangi_text])

    input = "斬魄刀の名前を考えて下さい。
    能力は#{@ability}で、斬魄刀の雰囲気は#{@atmosphere}です。
    ただし、名前に#{@kangi}という漢字を含むようにして下さい。"

    name_count = word_count
    example = zanpakuto_example(name_count)

    additional_prompt = "質問には#{name_count.first}文字の漢字で答えてください。漢字の横に()でふりがなを添えて下さい。解答例は、#{example.first}です。"

    @client = OpenAI::Client.new

    match_data = chat(input, additional_prompt).match(/(.+?)\((.+?)\)/)
    shikai = match_data[1]  # 漢字部分
    shikai_hurigana = match_data[2]  # ふりがな部分

    input = "「#{shikai}(#{shikai_hurigana})」に似合う命令形の動詞を考えて下さい。"

    additional_prompt = "質問には命令形の動詞で答えてください。その動詞の横に()でふりがなを添えて下さい。解答例は、#{kaigo_example}です。"

    match_data = chat(input, additional_prompt).match(/(.+?)\((.+?)\)/)
    kaigo = match_data[1]  # 漢字部分
    kaigo_hurigana = match_data[2]  # ふりがな部分

    input = "斬魄刀「#{shikai}」の卍解の名前を考えて下さい。
    能力は#{@ability}で、斬魄刀の雰囲気は#{@atmosphere}です。
    ただし、名前に#{@kangi}という漢字を含むようにして下さい。"

    additional_prompt = "質問には#{name_count.last}文字の漢字で答えてください。漢字の横に()でふりがなを添えて下さい。解答例は、#{example.last}です"

    match_data = chat(input, additional_prompt).match(/(.+?)\((.+?)\)/)
    bankai = match_data[1]  # 漢字部分
    bankai_hurigana = match_data[2]  # ふりがな部分
    if logged_in?
      @post = current_user.posts.build(
        kaigo: kaigo,
        kaigo_hurigana: kaigo_hurigana,
        shikai: shikai, 
        shikai_hurigana: shikai_hurigana, 
        ability: "#{@ability}の斬魄刀です。", 
        bankai: bankai, 
        bankai_hurigana: bankai_hurigana, 
        detail: @meigen, 
        tag_list: Array[@ability,@atmosphere,@bankai_say]
      )
    else
      @post = Post.new(
        kaigo: kaigo,
        kaigo_hurigana: kaigo_hurigana,
        shikai: shikai, 
        shikai_hurigana: shikai_hurigana, 
        bankai: bankai, 
        bankai_hurigana: bankai_hurigana, 
        detail: @meigen
      )
    end
  end

  def ai_ability
    input = "オリジナル斬魄刀「#{params[:shikai]}(#{params[:shikai_hurigana]})」の能力を考えて下さい。ただし、能力の種類は#{params[:ability]}で、雰囲気は、#{params[:atmosphere]}です。"
    additional_prompt = "質問には140字程度の日本語で答えて下さい。「である。」という口調で答えて下さい。"
    @client = OpenAI::Client.new
    ability = chat(input, additional_prompt)
    render turbo_stream: turbo_stream.replace(
      "ability-generate",
      partial: 'ai_posts/ability_turbo',
      locals: { ability: ability }
    )   
  end

  def ai_bankai_ability
    input = "オリジナル斬魄刀「#{params[:shikai]}(#{params[:shikai_hurigana]})」の卍解「#{params[:bankai]}(#{params[:bankai_hurigana]})」の能力を考えて下さい。ただし、能力の種類は#{params[:ability]}で、雰囲気は、#{params[:atmosphere]}です。"
    additional_prompt = "質問には140字程度の日本語で答えて下さい。「である。」という口調で答えて下さい。"
    @client = OpenAI::Client.new
    ability = chat(input, additional_prompt)
    render turbo_stream: turbo_stream.replace(
      "bankai-ability-generate",
      partial: 'ai_posts/bankai_ability_turbo',
      locals: { ability: ability }
    )   
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
    params.require(:post).permit(
      :kaigo, 
      :kaigo_hurigana, 
      :shikai, 
      :shikai_hurigana, 
      :ability, 
      :bankai, 
      :bankai_hurigana, 
      :detail, 
      :tag_list
    )
  end 

  def ai_count
    if session[:count] == nil 
      session[:count] = 1 
    elsif session[:count] == 5
      flash.now['danger'] = '一日5回までしか使えません'
      render :new, status: :unprocessable_entity
    else
      session[:count] += 1
    end
  end

  def ai_shikai_ability_count
    if session[:shikai_count] == nil 
      session[:shikai_count] = 1 
    elsif session[:shikai_count] == 1
      flash.now['danger'] = '使用できません'
      render :new_ai, status: :unprocessable_entity
    end
  end

  def ai_bankai_ability_count
    if session[:bankai_count] == nil 
      session[:bankai_count] = 1 
    elsif session[:bankai_count] == 1
      flash.now['danger'] = '使用できません'
      render :new_ai, status: :unprocessable_entity
    end
  end

  def user_input(ability, atmosphere, bankai_say, meigen, kangi)
    @ability = ability
    @atmosphere = atmosphere
    @bankai_say = bankai_say
    @meigen = meigen
    @kangi = kangi
  end
end
