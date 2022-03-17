require 'rails_helper'

RSpec.describe User, type: :model do
  # it "is valid with a first name, last name, email, and password" do
  #   user = User.new(
  #     first_name: "Aaron",
  #     last_name:  "Sumner",
  #     email:      "tester@example.com",
  #     password:   "dottle-nouveau-pavilion-tights-furze",
  #   )
  #   expect(user).to be_valid
  # end
  # # 名がなければ無効な状態であること
  # it "is invalid without a first name" do
  #   user = User.new(first_name: nil)
  #   user.valid?
  #   expect(user.errors[:first_name]).to include("can't be blank")
  # end
  # # 姓がなければ無効な状態であること
  # it "is invalid without a last name"
  # # メールアドレスがなければ無効な状態であること
  # it "is invalid without an email address" do
  #   User.create(
  #     first_name:  "Joe",
  #     last_name:  "Tester",
  #     email:      "tester@example.com",
  #     password:   "dottle-nouveau-pavilion-tights-furze",
  #   )
  #   user = User.new(
  #     first_name:  "Jane",
  #     last_name:  "Tester",
  #     email:      "tester@example.com",
  #     password:   "dottle-nouveau-pavilion-tights-furze",
  #   )
  #   user.valid?
  #   expect(user.errors[:email]).to include("has already been taken")
  # end
  # # 重複したメールアドレスなら無効な状態であること
  # it "is invalid with a duplicate email address"
  # # ユーザーのフルネームを文字列として返すこと
  # it "returns a user's full name as a string"

  before(:suite) do
    @user = User.create!(first_name: "田中", last_name: "太郎", email: "test@test.com", password: "password")
  end

  describe "describe" do
    context "userは田中？" do
      it do
        expect(@user.first_name).to eq "田中"
        @user.first_name = "山田"
        @user.save
      end
    end

    context "test2" do
      it { expect(@user.first_name).to eq "田中" }
    end
  end
end
