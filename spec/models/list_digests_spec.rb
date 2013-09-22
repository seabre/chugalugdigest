require 'spec_helper'

describe ListDigest do
  before :each do
    @list_digest = ListDigest.new "test@example.com", "Some Title", "A bunch of text"
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
      list_digest = ListDigest.new "text@example.com", "Some Title", "A bunch of text"
      list_digest.title = "New title"
      expect(list_digest.title).to eq "New title"
    end
  end

  describe "#digest_text" do
    it "returns the correct digest text" do
        expect(@list_digest.digest_text).to eq "A bunch of text"
    end

    it "allows setting the digest text after the object has been created" do
      list_digest = ListDigest.new "test@example.com", "Some Title", "A bunch of text"
      list_digest.digest_text = "New text"
      expect(list_digest.digest_text).to eq "New text"
    end
  end

  describe "#from" do
    it "returns the correct from address" do
        expect(@list_digest.from).to eq "test@example.com"
    end

    it "allows setting the from address after the object has been created" do
      list_digest = ListDigest.new "test@example.com", "Some Title", "A bunch of text"
      list_digest.from = "test@testy.com"
      expect(list_digest.from).to eq "test@testy.com"
    end
  end

  describe "#validate_sender" do
    it "returns true if e-mail is in whitelist" do
      expect(@list_digest.send(:validate_sender, "test@example.com")).to be_true
    end

    it "returns false if e-mail is not in whitelist" do
      expect(@list_digest.send(:validate_sender, "derp@derpy.net")).to be_false
    end
  end

  describe "#submit_to_reddit" do
    it "does not submit if e-mail is not in the whitelist" do
      list_digest = ListDigest.new "derp@derpy.com", "Some Title", "A bunch of text"
      expect(list_digest.submit_to_reddit("fakeusername9235","fakepass1234","fakesub123123")).to be_false
    end
  end

  describe "#to_inline" do
    it "adds four spaces after newlines and carriage returns" do
      expect(@list_digest.send(:to_inline, "\r\nsomething     \r\n  something")).to eq "    \r\n    something     \r\n      something"
    end
  end

end
