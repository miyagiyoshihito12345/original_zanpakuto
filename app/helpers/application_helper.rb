module ApplicationHelper
  def default_meta_tags
    {
      site: 'OriginalZanpakutoShareService',
      title: 'オリジナル斬魄刀投稿サイト',
      reverse: true,
      charset: 'utf-8',
      description: '自分の考えたオリジナル斬魄刀を投稿、シェアできるサービスです。',
      keywords: 'BLEACH,BLEACH_anime,ブリーチ,オリジナル斬魄刀',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.webp'), # 配置するパスやファイル名によって変更すること
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image', # Twitterで表示する場合は大きいカードにする
        site: '@miyagi_RUNTEQ', # アプリの公式Twitterアカウントがあれば、アカウント名を書く
        image: image_url('ogp.webp') # 配置するパスやファイル名によって変更すること
      }
    }
  end
end
