require 'spec_helper'
require 'uri'

RSpec.describe 'IsItDoneYet API' do
  include Rack::Test::Methods

  after do
    IsItDoneYet::WebApp.settings.state.clear
  end

  def app
    IsItDoneYet.build_app
  end

  describe 'GET /builds/:build_id/nodes/:node_id' do
    let(:path) { "/builds/#{build_id}/nodes/#{node_id}" }

    context 'with no data' do
      let(:build_id) { '265a' }
      let(:node_id) { 2 }
      it "shouldn't find anything" do
        get path
        expect(last_response).to be_not_found
      end
    end

    context 'with existing data' do
      let!(:payload) { { 'build_state' => 'ok' } }
      before do
        post path, payload.to_json, 'CONTENT_TYPE' => 'application/json'
      end

      context 'with simple ids' do
        let(:build_id) { '265a' }
        let(:node_id) { 2 }

        it 'should find the status' do
          get path
          expect(last_response).to be_ok
          expect(parse(last_response.body)).to eq payload
        end
      end

      context 'with ids using url-escaped characters' do
        let(:build_id) { URI.escape('bosso|elmo|d') }
        let(:node_id) { URI.escape('bosso   elmo\d') }

        it 'should find the status' do
          get path
          expect(last_response).to be_ok
          expect(parse(last_response.body)).to eq payload
        end
      end
    end
  end
end
