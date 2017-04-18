require 'spec_helper'

RSpec.describe 'IsItDoneYet API' do
  include Rack::Test::Methods

  def app
    IsItDoneYet.build_app
  end

  def parse(json_text)
    JSON.parse(json_text).map { |(k, v)| [k.to_sym, v] }.to_h
  end

  describe 'GET /builds/:build_id/nodes/:node_id' do
    let(:build_id) { '265a' }
    let(:node_id) { 2 }
    let(:path) { "/builds/#{build_id}/nodes/#{node_id}" }

    context 'with no data' do
      it "shouldn't find anything" do
        get path
        expect(last_response).to be_not_found
      end
    end

    context 'with existing data' do
      let!(:payload) { { build_state: 'ok' } }

      before do
        post path, payload.to_json, 'CONTENT_TYPE' => 'application/json'
      end

      it 'should find the status' do
        get path
        expect(last_response).to be_ok
        expect(parse(last_response.body)).to eq payload
      end
    end
  end
end
