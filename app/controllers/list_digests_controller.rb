class ListDigestsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    list_digest = ListDigest.new(params[:Subject], params[:TextBody])

    if list_digest.submit_to_reddit(ENV['REDDIT_USERNAME'],
                                    ENV['REDDIT_PASSWORD'],
                                    ENV['REDDIT_SUBREDDIT'])

      render text: "Success", status: :created
    else
      render text: "Failed", status: :unauthorized
    end
  end
end
