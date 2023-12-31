require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Postのバリデーション' do
    it '始解と能力が入力されている時' do
      post = build(:post)
      expect(post).to be_valid
      expect(post.errors).to be_empty
    end

    it '始解が入力されていない時' do
      post_without_shikai = build(:post, shikai: "")
      expect(post_without_shikai).to be_invalid
      expect(post_without_shikai.errors[:shikai]).to eq ["を入力してください"]
    end

    it '能力が入力されていない時' do
      post_without_ability = build(:post, ability: "")
      expect(post_without_ability).to be_invalid
      expect(post_without_ability.errors[:ability]).to eq ["を入力してください"]
    end
  end
end
