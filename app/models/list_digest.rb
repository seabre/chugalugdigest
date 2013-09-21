class ListDigest

  attr_accessor :title
  attr_accessor :digest_text
  attr_accessor :from

  def initialize(from, title, digest_text)
    @from = from
    @title = title
    @digest_text = digest_text
  end

  def submit_to_reddit(username, password, subreddit)
    if in_whitelist(@from)
      reddit = Snoo::Client.new
      reddit.log_in username, password

      reddit.submit @title, subreddit, text: @digest_text
    else
      false
    end
  end

  private

  def in_whitelist(from)
    "#{ENV['LISTDIGEST_WHITELIST']}".strip.split(',').include?(from)
  end

  def to_markdown(txt)
    html = HTMLPage.new contents: txt
    html.markdown
  end

end
