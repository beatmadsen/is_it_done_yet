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

  describe 'DELETE /builds/:build_id' do
    let(:build_id) { '265a' }
    let(:path) { "/builds/#{build_id}" }

    context 'with no data' do
      it 'should behave idempotently' do
        delete path
        expect(last_response.status).to eq(204)
      end
    end

    context 'with simple existing data' do
      let(:ok_payload) { { build_state: 'ok' } }
      let(:different_build_path) { '/builds/lent2000' }
      let(:nodes_for_deletion) { 9..16 }
      let(:nodes_for_keeping) { 25..27 }
      let(:paths_on_same_build) do
        nodes_for_deletion.map { |n| "#{path}/nodes/#{n}" }
      end
      let(:paths_on_different_build) do
        nodes_for_keeping.map { |n| "#{different_build_path}/nodes/#{n}" }
      end

      before do
        (paths_on_same_build + paths_on_different_build).each do |path|
          post path, ok_payload.to_json, 'CONTENT_TYPE' => 'application/json'
        end
      end

      it 'should remove nodes on specified build' do
        delete path
        expect(last_response.status).to eq(204)

        get path
        expect(last_response).to be_not_found

        get different_build_path
        expect(last_response).to be_ok

        data = parse(last_response.body)['build_states']
        expect(data.keys).to match_array(nodes_for_keeping.map(&:to_s))
      end
    end
  end
end
