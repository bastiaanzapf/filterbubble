
Dir.chdir('/home/basti/filterbubble-run')

require 'app/helpers/filterbubble/download.rb'
require 'app/helpers/filterbubble/parse.rb'
load 'app/helpers/filterbubble/crm.rb'

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

  def classify
    
  end
  
  def learn
    fmt=Format.find(:first,:conditions => { :format_id => params[:format] })   
    @item=Item.find(:first,:conditions => { :item_id => params[:id] })
    html=http_get(@item.link)
    doc=parse_html(html)
    @text=extract_xpath_text(doc,fmt.parameter)
    crm_learn(@text,1,1)
  end
end
