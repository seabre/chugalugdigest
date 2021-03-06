class ListDigest

  REDIS_STORAGE = "listdigests"
  REDIS_STORAGE_PROCESSING = "listdigests_processing"

  attr_reader :title, :digest_text, :from

  def initialize(from, title, digest_text)
    @from = sanitize_utf8(from)
    @title = sanitize_utf8(title)
    @digest_text = sanitize_utf8(digest_text)
  end

  def title=(title)
    @title = sanitize_utf8(title)
  end

  def digest_text=(digest_text)
    @digest_text = sanitize_utf8(digest_text)
  end

  def from=(from)
    @from = sanitize_utf8(from)
  end

  def submit_to_reddit(username, password, subreddit)
    if validate_sender(@from)
      begin
        reddit = Snoo::Client.new
        reddit.log_in username, password
        valid_response?(reddit.submit @title, subreddit, text: to_inline(@digest_text))
      rescue
        false
      end
    else
      false
    end
  end

  def persist
    begin
      REDIS.lpush REDIS_STORAGE, serialize
      true
    rescue StandardError, ConnectionError
      false
    end
  end

  def serialize
    Marshal.dump(self)
  end

  def self.pop_and_run
    list_digest = REDIS.rpoplpush REDIS_STORAGE, REDIS_STORAGE_PROCESSING

    if list_digest.length > 0
      if Marshal.load(list_digest).submit_to_reddit(ENV['REDDIT_USERNAME'],
                                                    ENV['REDDIT_PASSWORD'],
                                                    ENV['REDDIT_SUBREDDIT'])
        REDIS.lrem REDIS_STORAGE_PROCESSING, 0, list_digest
      end
    end
  end

  def self.pop_and_run_processing
    list_digest = REDIS.rpoplpush REDIS_STORAGE_PROCESSING, REDIS_STORAGE

    if list_digest.length > 0
      if Marshal.load(list_digest).submit_to_reddit(ENV['REDDIT_USERNAME'],
                                                    ENV['REDDIT_PASSWORD'],
                                                    ENV['REDDIT_SUBREDDIT'])
        REDIS.lrem REDIS_STORAGE, 0, list_digest
      end
    end
  end

  private

  def valid_response?(request)
    request['json']['errors'].blank?
  end

  def validate_sender(from)
    "#{ENV['LISTDIGEST_WHITELIST']}".strip.split(',').include?(from)
  end

  def to_inline(txt)
    "    #{txt.gsub(/\n/, "\n    ")}"
  end

  def sanitize_utf8(s)
    s.encode('UTF-16', :undef => :replace, :invalid => :replace, :replace => "")
      .encode('UTF-8')
  end

end
