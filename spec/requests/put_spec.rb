# frozen_string_literal: true

require 'spec_helper'
require 'uri'

RSpec.describe 'IsItDoneYet API' do
  include Rack::Test::Methods

  let(:state) { IsItDoneYet::WebApp.settings.state }

  after do
    state.clear
  end

  def app
    IsItDoneYet.build_app
  end

  describe 'PUT /builds/:build_id/nodes/:node_id' do
    let(:path) { "/builds/#{build_id}/nodes/#{node_id}" }
    let(:build_id) { '265a' }
    let(:node_id) { 2 }

    context 'with no data in map' do
      context 'after putting' do
        let!(:put_payload) { { 'build_state' => 'ok' } }

        before do
          put path, put_payload.to_json, 'CONTENT_TYPE' => 'application/json'
        end

        it 'should find the status' do
          expect(last_response).to be_no_content
          get path
          expect(last_response).to be_ok
          expect(parse(last_response.body)).to eq put_payload
        end
      end
    end

    context 'with existing data' do
      let!(:post_payload) { { 'build_state' => 'ok' } }
      before do
        post path, post_payload.to_json, 'CONTENT_TYPE' => 'application/json'
      end

      context 'after putting' do
        before do
          put path, put_payload.to_json, 'CONTENT_TYPE' => 'application/json'
        end

        context 'with no overwrite param' do
          let!(:put_payload) { { 'build_state' => 'nuts' } }

          it 'should find the build state' do
            expect(last_response).to be_no_content
            get path
            expect(last_response).to be_ok
            expect(parse(last_response.body)).to eq put_payload
          end
        end

        context 'with overwrite param present' do
          let!(:put_payload) do
            {
              'build_state' => 'nuts',
              'build_state_on_overwrite' => 'mengo'
            }
          end

          it 'should find the build state' do
            expect(last_response).to be_no_content
            get path
            expect(last_response).to be_ok
            expect(parse(last_response.body)).to eq('build_state' => 'mengo')
          end
        end
      end
    end
  end
end
