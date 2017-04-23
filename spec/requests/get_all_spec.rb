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

  describe 'GET /builds/:build_id' do
    let(:build_id) { '265a' }
    let(:path) { "/builds/#{build_id}" }

    context 'with no data' do
      it "shouldn't find anything" do
        get path
        expect(last_response).to be_not_found
      end
    end

    context 'with simple existing data' do
      let(:ok_payload) { { build_state: 'ok' } }
      let(:bad_payload) { { build_state: 'bad' } }
      let(:ok_nodes) { %w(a 56) }
      let(:bad_nodes) { %w(haha 57) }

      before do
        ok_nodes.each do |node_id|
          node_path = "#{path}/nodes/#{node_id}"
          post node_path, ok_payload.to_json, 'CONTENT_TYPE' => 'application/json'
        end
        bad_nodes.each do |node_id|
          node_path = "#{path}/nodes/#{node_id}"
          post node_path, bad_payload.to_json, 'CONTENT_TYPE' => 'application/json'
        end
      end

      it 'should list statues by node id' do
        get path
        expect(last_response).to be_ok

        data = parse(last_response.body)['build_states']
        expect(data.keys).to match_array(ok_nodes + bad_nodes)

        ok_nodes.each do |node_id|
          expect(data[node_id]).to eq('ok')
        end

        bad_nodes.each do |node_id|
          expect(data[node_id]).to eq('bad')
        end
      end
    end

    context 'with url-escaped data' do
      let(:payload) { { build_state: 'ok' } }

      let(:nodes) { ['a', 'a||s,+a  d', "\ndd\t"] }
      let(:nodes_esc) { nodes.map { |n| URI.escape(n) } }
      before do
        nodes_esc.each do |node_id|
          node_path = "#{path}/nodes/#{node_id}"
          post node_path, payload.to_json, 'CONTENT_TYPE' => 'application/json'
        end
      end

      it 'should list statuses by unescaped node ids' do
        get path
        expect(last_response).to be_ok

        data = parse(last_response.body)['build_states']
        expect(data.keys).to match_array(nodes)
      end
    end
  end
end
