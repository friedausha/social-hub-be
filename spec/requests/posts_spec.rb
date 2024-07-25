require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{generate_token(user.id)}" } }

  def generate_token(user_id)
    JWT.encode({ user_id: user_id }, Rails.application.credentials.secret_key_base)
  end

  describe 'POST /posts' do
    context 'with valid attributes' do
      let(:valid_attributes) { attributes_for(:post) }

      it 'creates a new post' do
        expect {
          post '/posts', params: { post: valid_attributes }, headers: headers
        }.to change(Post, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['title']).to eq(valid_attributes[:title])
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { post: { title: '', content: '' } } }

      it 'does not create a new post' do
        expect {
          post '/posts', params: invalid_attributes, headers: headers
        }.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'without authentication' do
      it 'returns an unauthorized status' do
        post '/posts', params: { post: attributes_for(:post) }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /posts' do
    let!(:posts) { create_list(:post, 15) }
    let(:headers) { { 'Content-Type' => 'application/json' } }

    context 'without cursor' do
      it 'returns the first set of posts' do
        get '/posts', headers: headers

        expect(response).to have_http_status(:ok)
        expect(json['posts'].size).to eq(10)
        expect(json['next_cursor']).to be_present
      end
    end

    context 'with cursor' do
      it 'returns the next set of posts' do
        oldest_post = posts[9]
        get '/posts', params: { before: oldest_post.created_at, last_id: oldest_post.id }, headers: headers

        expect(response).to have_http_status(:ok)
        # puts "Returned posts: #{json['posts'].map { |p| p['created_at'] }}"

        expect(json['posts'].size).to eq(5)
        expect(json['next_cursor']).to be_nil
      end
    end
  end
end
