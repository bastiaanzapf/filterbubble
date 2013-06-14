
Dir.chdir('/home/basti/filterbubble-run')

require 'app/helpers/filterbubble/download.rb'
require 'app/helpers/filterbubble/parse.rb'
load 'app/helpers/filterbubble/crm.rb'

class ItemController < ApplicationController
  layout 'application'
  def list
    @display_confidence=false
    if (params[:id1])
      @items=Item.find(:all, :limit => 30,
                       :joins => ("JOIN categories_items USING "+
                                  "(item_id)"),
                       :order => "confidence DESC",
                       :conditions =>
                       ["created_at<(NOW() - INTERVAL '1 DAY') AND "+
                        "meta_id=:id1 AND category_id=:id2",params]
                       )
      @display_confidence=true
    else
      @items=Item.find(:all)
    end
  end

  def doubt
    if (!params[:id2])
      @items=Item.find(:all, :limit => 30,
                       :joins => ("JOIN categories_items USING "+
                                  "(item_id)"),
                       :order => "confidence ASC",
                       :conditions =>
                       ["created_at<(NOW() - INTERVAL '3 DAY') AND "+
                        "meta_id=:id1",params]
                       )
    else
      @items=Item.find(:all, :limit => 30,
                       :joins => ("JOIN categories_items USING "+
                                  "(item_id)"),
                       :order => "confidence ASC",
                       :conditions =>
                       ["created_at<(NOW() - INTERVAL '3 DAY') AND "+
                        "meta_id=:id1 AND category_id=:id2",params]
                       )
    end
    @display_confidence=true
    @display_category=true
    render :list
  end

  def apply
    fmt=Format.find(:first,:conditions => { :format_id => params[:id2] })   
    @item=Item.find(:first,:conditions => { :item_id => params[:id1] })
    html=http_get(@item.link)
    doc=parse_html(html)
    @text=extract_xpath_text(doc,fmt.parameter)
  end

  def classify
    
  end
  
  def learn
    fmt=Format.find(:first,:conditions => { :format_id => params[:id2] })   
    @item=Item.find(:first,:conditions => { :item_id => params[:id1] })
    html=http_get(@item.link)
    doc=parse_html(html)
    @text=extract_xpath_text(doc,fmt.parameter)
    crm_learn(@text,1,1)
  end
end
