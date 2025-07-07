require 'rails_helper'

RSpec.describe User do
  let!(:user) { User.new("username@gmail.com", "password") } 

  it 'has a email' do
    expect(user.email).to eq 'username@gmail.com'
  end
  it 'has a password' do
    expect(user.password).to eq 'password'
  end
end