require 'spec_helper'

describe ListDigestsController do

  describe "POST 'create'" do

    before(:each) do
      @json = JSON.parse(File.read("#{Rails.root}/spec/fixtures/mailing_list.json"))
    end

    it "returns success if digest is successfully stored to redis" do
      @list_digest = double(ListDigest)
      @list_digest.stub(:persist).and_return(true)

      ListDigest.should_receive(:new).and_return(@list_digest)

      @request.env['HTTP_ACCEPT'] = "application/json"
      @request.env['CONTENT_TYPE'] = "application/json"
      @request.env['REMOTE_ADDR'] = '127.0.0.1'

      post :create, @json
      expect(response.body).to eq "Success"
      expect(request.remote_ip).to eq "127.0.0.1"
    end

    it "returns failure if digest is not stored to redis" do
      @list_digest = double(ListDigest)
      @list_digest.stub(:persist).and_return(false)

      ListDigest.should_receive(:new).and_return(@list_digest)

      @request.env['HTTP_ACCEPT'] = "application/json"
      @request.env['CONTENT_TYPE'] = "application/json"
      @request.env['REMOTE_ADDR'] = '127.0.0.1'

      post :create, @json
      expect(response.body).to eq "Failed"
    end

    it "returns failure if the remote IP is not in the whitelist" do

      @request.env['HTTP_ACCEPT'] = "application/json"
      @request.env['CONTENT_TYPE'] = "application/json"
      @request.env['REMOTE_ADDR'] = '127.1.1.1'

      post :create, @json
      expect(response.body).to eq "Failed"
    end
  end

end
