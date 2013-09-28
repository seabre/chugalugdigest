class ListDigest

  REDIS_STORAGE = "listdigests"

  attr_accessor :title
  attr_accessor :digest_text
  attr_accessor :from

  def initialize(from, title, digest_text)
    @from = from
    @title = title
    @digest_text = digest_text
  end

  def submit_to_reddit(username, password, subreddit)
    if validate_sender(@from)
      reddit = Snoo::Client.new
      reddit.log_in username, password
      reddit.submit @title, subreddit, text: to_inline(@digest_text)
    else
      false
    end
  end

  def persist
    begin
      REDIS.rpush REDIS_STORAGE, serialize
      true
    rescue StandardError, ConnectionError
      false
    end
  end

  def serialize
    Marshal.dump(self)
  end

  private

  def validate_sender(from)
    "#{ENV['LISTDIGEST_WHITELIST']}".strip.split(',').include?(from)
  end

  def to_inline(txt)
    "    #{txt.gsub(/\n/, "\n    ")}"
  end

end
