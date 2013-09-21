class ListDigest

  attr_accessor :title
  attr_accessor :digest_text

  def initialize(title, digest_text)
    @title = title
    @digest_text = digest_text
  end

  def submit_to_reddit(username, password, subreddit)
    reddit = Snoo::Client.new
    reddit.log_in username, password

    reddit.submit @title, subreddit, text: to_markdown(@digest_text)
  end

  private

  def to_markdown(txt)
    html = HTMLPage.new contents: txt
    html.markdown
  end

end
