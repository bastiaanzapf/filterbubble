
require 'lib/filterbubble/download.rb'
require 'lib/filterbubble/parse.rb'

class ItemController < ApplicationController

  def list
    @items=Item.find(:all)
  end

  def apply
    fmt=Format.find(:first,:conditions => { :format_id => params[:format] })    
    @item=Item.find(:first,:conditions => { :item_id => params[:id] })
    html=http_get(@item.link)
    doc=parse_html(html)
    @text=extract_xpath_text(doc,fmt.parameter)
  end

end
