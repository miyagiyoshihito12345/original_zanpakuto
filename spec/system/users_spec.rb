require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit new_user_path
          fill_in 'ユーザー名', with: '山田太郎'
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録、ログインしました'
          expect(current_path).to eq root_path
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'ユーザー名', with: '山田太郎'
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(current_path).to eq users_path
        end
      end

      context 'ユーザー名が未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'ユーザー名', with: ''
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'ユーザー名を入力してください'
          expect(current_path).to eq users_path
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          existed_user = create(:user)
          visit new_user_path
          fill_in 'ユーザー名', with: '山田太郎'
          fill_in 'メールアドレス', with: existed_user.email
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'メールアドレスはすでに存在します'
          expect(current_path).to eq users_path
          expect(page).to have_field 'メールアドレス', with: existed_user.email
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit profiles_path
          expect(page).to have_content 'ログインして下さい'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit edit_profiles_path
          fill_in 'ユーザー名', with: '田中太郎'
          click_button '更新する'
          expect(page).to have_content('ユーザーを更新しました')
          expect(page).to have_content '田中太郎'
          expect(current_path).to eq profiles_path
        end
      end

      context 'ユーザー名が未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_profiles_path
          fill_in 'ユーザー名', with: ''
          click_button '更新する'
          expect(page).to have_content('ユーザーの更新に失敗しました')
          expect(page).to have_content('ユーザー名を入力してください')
          expect(current_path).to eq profiles_path
        end
      end
    end

    describe 'マイページ' do
      context '投稿を作成' do
        it '新規作成した投稿が表示される' do
          create(:post, shikai: '氷輪丸', ability: '氷雪系最強', user: user)
          visit profiles_path
          expect(page).to have_content('氷輪丸')
          expect(page).to have_content('氷雪系最強')
          expect(page).to have_link('自分の投稿')
          expect(page).to have_link('霊圧')
          expect(page).to have_link('下書き')
        end
      end
    end
  end
end
