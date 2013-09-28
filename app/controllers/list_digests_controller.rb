class ListDigestsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_whitelist

  respond_to :json

  def check_whitelist
    if !ENV['IP_WHITELIST'].strip.split(',').include?(request.remote_ip)
      render text: "Failed", status: :unauthorized
      return
    end
  end

  def create
    @list_digest = ListDigest.new(params[:From], params[:Subject], params[:TextBody])

    if @list_digest.persist
      render text: "Success", status: :created
    else
      render text: "Failed", status: :unauthorized
    end
  end
end
