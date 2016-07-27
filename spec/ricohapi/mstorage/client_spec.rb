require 'spec_helper'

describe RicohAPI::MStorage::Client do
  let(:access_token) { 'access_token' }
  let(:media_id) { 'media-id' }
  let(:user_meta_key) { 'user_meta_key' }
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

    context 'when filter params given' do
      it 'should return search result' do
        response = mock_request :post, "/media/search", 'search.json' do
          filter = {'meta.user.key1' => 'value1', 'meta.user.key2' => 'value2'}
          client.list filter: filter
        end
        response.should include :media, :paging
        response[:media].should be_a Array
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

  describe '#add_meta' do
    it 'should return nothing' do
      request_user_meta = {"user.#{user_meta_key}" => 'value1'}
      response = mock_request :put, "/media/#{media_id}/meta/user/#{user_meta_key}", 'add_meta.data' do
        client.add_meta media_id, request_user_meta
      end
      response.should  == request_user_meta
    end
  end

  describe '#meta' do
    it 'should return all metadata of the media' do
      response = mock_request :get, "/media/#{media_id}/meta", 'meta.json' do
        client.meta media_id
      end
      response.should include :exif, :gpano, :user
    end
  end

  describe '#meta(exif)' do
    it 'should return exif of the media' do
      response = mock_request :get, "/media/#{media_id}/meta/exif", 'exif.json' do
        client.meta media_id, 'exif'
      end
      response.should be_a Hash
    end
  end

  describe '#meta(gpano)' do
    it 'should return gpano of the media' do
      response = mock_request :get, "/media/#{media_id}/meta/gpano", 'gpano.json' do
        client.meta media_id, 'gpano'
      end
      response.should be_a Hash
    end
  end

  describe '#meta(user)' do
    it 'should return all user metadata of the media' do
      response = mock_request :get, "/media/#{media_id}/meta/user", 'user.json' do
        client.meta media_id, 'user'
      end
      response.should be_a Hash
    end
  end

  describe '#meta(user.<key>)' do
    it 'should return specified user metadata of the media' do
      response = mock_request :get, "/media/#{media_id}/meta/user/#{user_meta_key}", 'user_meta_value.txt' do
        client.meta media_id, "user.#{user_meta_key}"
      end
      response.should == 'user_meta_value'
    end

    it 'should raise error when field_name is invalid format' do
      expect{client.meta media_id, "user."}.to raise_error(RicohAPI::MStorage::Client::Error)
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

  describe '#remove_meta (all user metadata)' do
    it 'should return nothing' do
      response = mock_request :delete, "/media/#{media_id}/meta/user", 'delete.data' do
        client.remove_meta media_id, 'user'
      end
      response.should == ''
    end
  end

  describe '#remove_meta (specified user metadata)' do
    it 'should return nothing' do
      response = mock_request :delete, "/media/#{media_id}/meta/user/#{user_meta_key}", 'delete.data' do
        client.remove_meta media_id, "user.#{user_meta_key}"
      end
      response.should == ''
    end

    it 'should raise error when key is invalid format' do
      expect{client.remove_meta media_id, "user."}.to raise_error(RicohAPI::MStorage::Client::Error)
    end
  end
end
