
$LOAD_PATH.unshift('/usr/lib/ruby/vendor_ruby/feed_tools/helpers/')

require 'feed_tools'

class FeedController < ApplicationController
  def list
    @feeds=Feed.all
    @i=@feeds.length
  end
  def create
    Feed.create :url => request.POST['url']
    redirect_to :action=>'list', :status => 302
  end
  def get_binding
    binding
  end
end
