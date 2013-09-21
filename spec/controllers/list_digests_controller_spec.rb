require 'spec_helper'

describe ListDigestsController do

  describe "POST 'create'" do

    before(:each) do
      @json = JSON.parse(File.read("#{Rails.root}/spec/fixtures/mailing_list.json"))
    end

    it "returns success if digest is posted to reddit" do
      @list_digest = double(ListDigest)
      @list_digest.stub(:submit_to_reddit).and_return(true)

      ListDigest.should_receive(:new).and_return(@list_digest)

      @request.env["HTTP_ACCEPT"] = "application/json"
      @request.env["CONTENT_TYPE"] = "application/json"

      post :create, @json
      expect(response.body).to eq "Success"
    end

    it "returns failure if digest is not posted to reddit" do
      @list_digest = double(ListDigest)
      @list_digest.stub(:submit_to_reddit).and_return(false)

      ListDigest.should_receive(:new).and_return(@list_digest)

      @request.env["HTTP_ACCEPT"] = "application/json"
      @request.env["CONTENT_TYPE"] = "application/json"
      post :create, @json
      expect(response.body).to eq "Failed"
    end
  end

end
