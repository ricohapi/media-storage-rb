require 'spec_helper'

describe RicohAPI::MStorage::Client do
  let(:access_token) { 'access_token' }
  let(:media_id) { 'media-id' }
  let(:client) { RicohAPI::MStorage::Client.new access_token }
  subject { client }

  describe '#list' do
    it 'should return list of media ids' do
      response = mock_request :get, '/media', 'list.json' do
        client.list
      end
      response.should include :media, :paging
      response[:media].should be_a Array
    end

    context 'when pagination params given' do
      it do
        mock_request :get, '/media', 'list.json', params: {
          after: 'media#2',
          before: 'media#99',
          limit: 25
        } do
          client.list(
            after: 'media#2',
            before: 'media#99',
            limit: 25
          )
        end
      end
    end
  end

  describe '#info' do
    it 'should return basic info of the media' do
      response = mock_request :get, "/media/#{media_id}", 'info.json' do
        client.info media_id
      end
      response.should include :id, :content_type, :bytes, :created_at
    end
  end

  describe '#download' do
    it 'should return binary data of the media' do
      response = mock_request :get, "/media/#{media_id}/content", 'download.data' do
        client.download media_id
      end
      response.should == '<binary-data>'
    end
  end

  describe '#meta' do
    it 'should return metadata of the media' do
      response = mock_request :get, "/media/#{media_id}/meta", 'meta.json' do
        client.meta media_id
      end
      response.should include :exif, :gpano
    end
  end

  describe '#upload' do
    it 'should return basic info of the uploaded media' do
      response = mock_request :post, '/media', 'upload.json' do
        client.upload Tempfile.new('tmp.jpg')
      end
      response.should include :id, :content_type, :bytes, :created_at
    end
  end

  describe '#delete' do
    it 'should return nothing' do
      response = mock_request :delete, "/media/#{media_id}", 'delete.data' do
        client.delete media_id
      end
      response.should == ''
    end
  end
end
