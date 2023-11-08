module OpenAiActions
  extend ActiveSupport::Concern

  private

  def chat(input, additional_prompt)
    response = @client.chat(
      parameters: {
        model: "gpt-4-1106-preview",
        messages: [
          { role: "system", content: additional_prompt },
          { role: "user", content: input },
        ],  
        temperature: 1.2,
      })  

    response.dig("choices", 0, "message", "content")
  end 

  def word_count
    shikai_word_count = rand(2..4)

    case shikai_word_count
    when 2 then
      bankai_word_count = rand(3..6)
    when 3 then
      bankai_word_count = rand(4..6)
    else
      bankai_word_count = rand(5..6)
    end
    [shikai_word_count, bankai_word_count]
  end

  def zanpakuto_example(name_count)
    case name_count.first
    when 2 then
      shikai_example = [
        "斬月(ざんげつ)", 
        "紅姫(べにひめ)", 
        "逆撫(さかなで)", 
        "雀蜂(すずめばち)", 
        "神鎗(しんそう)", 
        "侘助(わびすけ)", 
        "凍雲(いてぐも)", 
        "風死(かぜしに)",
        "灰猫(はいねこ)",
        "野晒(のざらし)",
        "土鯰(つちなまず)",
        "断風(たちかぜ)",
        "捩花(ねじばな)"
      ].sample
    when 3 then
      shikai_example = [
        "厳霊丸(ごんりょうまる)", 
        "五形頭(げげつぶり)", 
        "虎落笛(もがりぶえ)", 
        "肉雫唼(みなづき)", 
        "千本桜(せんぼんざくら)", 
        "蛇尾丸(ざびまる)", 
        "氷輪丸(ひょうりんまる)", 
        "鬼灯丸(ほおずきまる)",
        "藤孔雀(ふじくじゃく)",
        "双魚理(そうぎょのことわり)",
        "袖白雪(そでのしらゆき)",
        "馘大蛇(くびきりおろち)",
        "天狗丸(てんぐまる)",
        "金沙羅(きんしゃら)"
      ].sample
    else
      shikai_example = [
        "流刃若火(りゅうじんじゃっか)", 
        "鏡花水月(きょうかすいげつ)", 
        "花天狂骨(かてんきょうこつ)", 
        "肉雫唼(みなづき)", 
        "三歩剣獣(さんぽけんじゅう)", 
        "疋殺地蔵(あしそぎじぞう)", 
        "鉄漿蜻蛉(はぐろとんぼ)", 
        "退紅時雨(あらぞめしぐれ)",
        "餓樂廻廊(ががくかいろう)"
      ].sample
    end 

    case name_count.last
    when 3 then
      bankai_example = [
        "神殺鎗(かみしにのやり)", 
        "白霞罸(はっかのとがめ)", 
        "業炎殻(ごうえんかく)", 
        "神怒鳴(かみなり)" 
      ].sample
    when 4 then
      bankai_example = [
        "鐵拳断風(てっけんたちかぜ)", 
        "天鎖斬月(てんさざんげつ)", 
        "碧雷翔神(へきらいしょうじん)", 
        "無経極天(むけいこくてん)", 
        "戯大老樹(たわむれだいろうじゅ)", 
        "黒獄天樂(こくごくてんがく)" 
      ].sample
    when 5 then
      bankai_example = [
        "雀蜂雷公鞭(じゃくほうらいこうべん)", 
        "千本桜景厳(せんぼんざくらかげよし)", 
        "双王蛇尾丸(そうおうざびまる)", 
        "龍紋鬼灯丸(りゅうもんほおずきまる)" 
      ].sample
    when 6 then
      bankai_example = [
        "黄煌厳霊離宮(こうこうごんりょうりきゅう)", 
        "狒狒王蛇尾丸(ひひおうざびまる)", 
        "黒縄天譴明王(こくじょうてんげんみょうおう)", 
        "金色疋殺地蔵(こんじきあしそぎじぞう)", 
        "金沙羅舞踏団(きんしゃらぶとうだん)", 
        "大紅蓮氷輪丸(だいぐれんひょうりんまる)" 
      ].sample
    end 
    [shikai_example, bankai_example]
  end
end
