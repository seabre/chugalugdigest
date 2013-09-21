require 'spec_helper'

describe ListDigest do
  before :each do
    @list_digest = ListDigest.new "Some Title", "A bunch of text"
  end

  describe "#new" do
    it "takes title and digest_text arguments and returns a ListDigest object" do
        @list_digest.should be_an_instance_of ListDigest
    end
  end

  describe "#title" do
    it "returns the correct title" do
        expect(@list_digest.title).to eq "Some Title"
    end

    it "allows setting the title after the object has been created" do
      list_digest = ListDigest.new "Some Title", "A bunch of text"
      list_digest.title = "New title"
      expect(list_digest.title).to eq "New title"
    end
  end

  describe "#digest_text" do
    it "returns the correct digest text" do
        expect(@list_digest.digest_text).to eq "A bunch of text"
    end

    it "allows setting the digest text after the object has been created" do
      list_digest = ListDigest.new "Some Title", "A bunch of text"
      list_digest.digest_text = "New text"
      expect(list_digest.digest_text).to eq "New text"
    end
  end

  describe "#to_markdown" do
    it "converts given HTML to markdown" do
      expect(@list_digest.send(:to_markdown, "<strong>Test</strong>")).to eq "**Test**"
    end
  end




end
