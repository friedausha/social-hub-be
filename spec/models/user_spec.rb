require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is not valid without a full_name" do
    user = build(:user, full_name: nil)
    expect(user).not_to be_valid
  end

  it "is not valid without an email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it "is not valid with a duplicate email" do
    create(:user, email: "test@example.com")
    user = build(:user, email: "test@example.com")
    expect(user).not_to be_valid
  end

  it "is not valid without a password" do
    user = build(:user, password: nil)
    expect(user).not_to be_valid
  end

  it "is not valid with a short password" do
    user = build(:user, password: "short")
    expect(user).not_to be_valid
  end

  it "encrypts the password into password_digest" do
    user = create(:user, password: "password")
    expect(user.password_digest).not_to eq("password")
  end
end
