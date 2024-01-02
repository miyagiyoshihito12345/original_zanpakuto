require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context '投稿の新規登録ページにアクセス' do
        it '新規登録ページへのアクセスが失敗する' do
          visit new_post_path
          expect(page).to have_content('ログインして下さい')
          expect(current_path).to eq login_path
        end
      end

      context '投稿の編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_post_path(post)
          expect(page).to have_content('ログインして下さい')
          expect(current_path).to eq login_path
        end
      end

      context '投稿の詳細ページにアクセス' do
        it '投稿の詳細情報が表示される' do
          visit post_path(post)
          expect(page).to have_content post.shikai
          expect(page).to have_content post.ability
          expect(current_path).to eq post_path(post)
        end
      end

      context '投稿一覧ページにアクセス' do
        it 'すべての投稿が表示される' do
          post_list = create_list(:post, 3)
          visit posts_path
          expect(page).to have_content post_list[0].shikai
          expect(page).to have_content post_list[0].ability
          expect(page).to have_content post_list[1].shikai
          expect(page).to have_content post_list[1].ability
          expect(page).to have_content post_list[2].shikai
          expect(page).to have_content post_list[2].ability
          expect(current_path).to eq posts_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe '投稿を新規登録' do
      context 'フォームの入力値が正常' do
        it '投稿の新規作成が成功する' do
          visit new_post_path
          fill_in '始解', with: '氷輪丸'
          fill_in '能力', with: '氷雪系最強'
          click_button '投稿する'
          expect(page).to have_content '氷輪丸'
          expect(page).to have_content '氷雪系最強'
          expect(current_path).to eq root_path
        end
      end

      context '「始解」が未入力' do
        it '投稿の新規作成が失敗する' do
          visit new_post_path
          fill_in '始解', with: ''
          fill_in '能力', with: '氷雪系最強'
          click_button '投稿する'
          expect(page).to have_content '投稿を作成できませんでした'
          expect(page).to have_content '始解を入力してください'
          expect(current_path).to eq '/posts'
        end
      end
    end

    describe '投稿編集' do
      let!(:post) { create(:post, user: user) }
      before { visit edit_post_path(post) }

      context 'フォームの入力値が正常' do
        it '投稿の編集が成功する' do
          fill_in '始解', with: '氷輪丸'
          click_button '更新する'
          expect(page).to have_content '氷輪丸'
          expect(page).to have_content '投稿を更新しました'
          expect(current_path).to eq post_path(post)
        end
      end

      context '始解が未入力' do
        it '投稿の編集が失敗する' do
          fill_in '始解', with: nil
          click_button '更新する'
          expect(page).to have_content '投稿の更新に失敗しました'
          expect(page).to have_content '始解を入力してください'
          expect(current_path).to eq post_path(post)
        end
      end
    end

    describe '投稿の削除' do
      let!(:post) { create(:post, user: user) }

      it '投稿の削除が成功する' do
        visit post_path(post)
        click_link '削除'
        expect(page.accept_confirm).to eq '削除しますか？'
        expect(page).to have_content '削除しました'
        expect(current_path).to eq profiles_path
        expect(page).not_to have_content post.shikai
      end
    end
  end
end
