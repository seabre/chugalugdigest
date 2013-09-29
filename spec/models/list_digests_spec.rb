require 'spec_helper'

describe ListDigest do
  before :each do
    @list_digest = ListDigest.new "test@example.com", "Some Title", "A bunch of text"
  end

  describe "#new" do
    it "takes title and digest_text arguments and returns a ListDigest object" do
        @list_digest.should be_an_instance_of ListDigest
    end

    it "sanitizes argument text if there are invalid utf8 sequences in them" do
      list_digest = ListDigest.new "text@example.com\255", "Some Title\255", "A bunch of text\255"
      expect(list_digest.from).to eq "text@example.com"
      expect(list_digest.title).to eq "Some Title"
      expect(list_digest.digest_text).to eq "A bunch of text"
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

    it "returns the sanitized title if there was an invalid utf8 sequence" do
      list_digest = ListDigest.new "test@example.com", "Some Title\255", "A bunch of text"
      expect(@list_digest.title).to eq "Some Title"
    end

    it "sets the title with sanitized text if there is an invalid utf8 sequence" do
      list_digest = ListDigest.new "test@example.com", "Some Title", "A bunch of text"
      list_digest.title = "New title\255"
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

    it "returns the sanitized digest text if there was an invalid utf8 sequence" do
      list_digest = ListDigest.new "test@example.com", "Some Title", "A bunch of text\255"
      expect(@list_digest.digest_text).to eq "A bunch of text"
    end

    it "sets the digest text with sanitized text if there is an invalid utf8 sequence" do
      list_digest = ListDigest.new "test@example.com", "Some Title", "A bunch of text"
      list_digest.digest_text = "New text\255"
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

    it "returns the sanitized from address if there was an invalid utf8 sequence" do
      list_digest = ListDigest.new "test@example.com\255", "Some Title", "A bunch of text"
      expect(@list_digest.from).to eq "test@example.com"
    end

    it "sets the from address with sanitized text if there is an invalid utf8 sequence" do
      list_digest = ListDigest.new "test@example.com", "Some Title", "A bunch of text"
      list_digest.from = "test@testy.com\255"
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
    it "adds four spaces after newlines" do
      expect(@list_digest.send(:to_inline, "\r\nsomething     \r\n  something")).to eq "    \r\n    something     \r\n      something"
    end

    it "adds four spaces to the beginning of a string" do
      expect(@list_digest.send(:to_inline, "something")).to eq "    something"
    end
  end

  describe "#serialize" do
    it "converts the instance of ListDigest into a bytestream" do
      expect(@list_digest.serialize).to eq Marshal.dump(@list_digest)
    end
  end

  describe "#persist" do
    before :each  do
      REDIS.flushdb
    end

    it "returns true if the object persisted successfully" do
      expect(@list_digest.persist).to be_true
    end

    it "stores the object in REDIS_STORAGE" do
      expect(@list_digest.persist).to be_true
      expect(REDIS.lpop ListDigest::REDIS_STORAGE).to eq @list_digest.serialize
    end

    it "returns false if the object did not persist successfully due to StandardError" do
      REDIS.stub(:lpush) { raise StandardError }
      list_digest = ListDigest.new "derp@derpy.com", "Some Title", "A bunch of text"
      expect(list_digest.persist).to be_false
    end

    it "returns false if the object did not persist successfully due to ConnectionError" do
      REDIS.stub(:lpush) { raise ConnectionError }
      list_digest = ListDigest.new "derp@derpy.com", "Some Title", "A bunch of text"
      expect(list_digest.persist).to be_false
    end
  end

  describe "#pop_and_run" do
    before :each  do
      REDIS.flushdb
      @list_digest.persist
    end

    it "removes ListDigest from REDIS_STORAGE on success" do
      ListDigest.any_instance.stub(:submit_to_reddit).and_return(true)
      ListDigest.pop_and_run

      expect(REDIS.llen ListDigest::REDIS_STORAGE).to eq 0
    end

    it "removes ListDigest from REDIS_STORAGE on failure" do
      ListDigest.any_instance.stub(:submit_to_reddit).and_return(false)
      ListDigest.pop_and_run

      expect(REDIS.llen ListDigest::REDIS_STORAGE).to eq 0
    end

    it "removes ListDigest from REDIS_STORAGE_PROCESSING on success" do
      ListDigest.any_instance.stub(:submit_to_reddit).and_return(true)
      ListDigest.pop_and_run

      expect(REDIS.llen ListDigest::REDIS_STORAGE_PROCESSING).to eq 0
    end

    it "leaves ListDigest in REDIS_STORAGE_PROCESSING on failure" do
      ListDigest.any_instance.stub(:submit_to_reddit).and_return(false)
      ListDigest.pop_and_run

      expect(REDIS.llen ListDigest::REDIS_STORAGE_PROCESSING).to eq 1
    end

  end

  describe "#pop_and_run_processing" do
    before :each  do
      REDIS.flushdb
      REDIS.lpush ListDigest::REDIS_STORAGE_PROCESSING, @list_digest.serialize
    end

    it "removes ListDigest from REDIS_STORAGE_PROCESSING on success" do
      ListDigest.any_instance.stub(:submit_to_reddit).and_return(true)
      ListDigest.pop_and_run_processing

      expect(REDIS.llen ListDigest::REDIS_STORAGE_PROCESSING).to eq 0
    end

    it "removes ListDigest from REDIS_STORAGE_PROCESSING on failure" do
      ListDigest.any_instance.stub(:submit_to_reddit).and_return(false)
      ListDigest.pop_and_run_processing

      expect(REDIS.llen ListDigest::REDIS_STORAGE_PROCESSING).to eq 0
    end

    it "removes ListDigest from REDIS_STORAGE on success" do
      ListDigest.any_instance.stub(:submit_to_reddit).and_return(true)
      ListDigest.pop_and_run_processing

      expect(REDIS.llen ListDigest::REDIS_STORAGE).to eq 0
    end

    it "leaves ListDigest in REDIS_STORAGE on failure" do
      ListDigest.any_instance.stub(:submit_to_reddit).and_return(false)
      ListDigest.pop_and_run_processing

      expect(REDIS.llen ListDigest::REDIS_STORAGE).to eq 1
    end
  end

  describe "#sanitize_utf8" do
    it "removes invalid utf8 sequences" do
      expect(@list_digest.send(:sanitize_utf8, "\255")).to eq ""
    end
  end

end
