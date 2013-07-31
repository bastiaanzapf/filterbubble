# -*- coding: undecided -*-

#Dir.chdir('/home/basti/filterbubble-run')

#load 'app/helpers/filterbubble/download.rb'
#require 'app/helpers/filterbubble/parse.rb'
#load 'crm.rb'

class ItemController < ApplicationController
  layout 'application'
  
  def initialize
    @conf= {
      :limit => 90,
      :confidencebonus => '12 HOUR',
      :displayinterval => '1 DAY'
    }
  end

  # List news items

  def list
    @display_confidence=false
    params[:displayinterval]=@conf[:displayinterval]
    params[:confidencebonus]=@conf[:confidencebonus]
    if (params[:id1])
      @items=Item.find(:all, :limit => @conf[:limit],
                       :joins => "JOIN categories_items USING (item_id) JOIN category USING (meta_id,category_id) ",
                       :order => ["created_at + (confidence * INTERVAL '1 DAY') DESC"],
                       :conditions =>
                       ["created_at>(NOW() - INTERVAL :displayinterval) AND "+
                        "meta_id=:id1 AND category_id=:id2 AND confidence!=0.5",params]            
           )

      
#      @display_confidence=true
#      @confidence_color_code=true
      @change_category=true
      
      @categories=Category.find(:all,
                                :conditions => ["meta_id=:id1",params])
    else
      @items=Item.find(:all)
    end
  end

  def doubt
    params[:displayinterval]=@conf[:displayinterval]
    params[:confidencebonus]=@conf[:confidencebonus]
    if (!params[:id2])
      @items=Item.find(:all, :limit => @limit,
                       :joins => ("JOIN categories_items USING "+
                                  "(item_id)"),
                       :order => "confidence ASC",
                       :conditions =>
                       ["created_at>(NOW() - INTERVAL :displayinterval) AND "+
                        "meta_id=:id1",params]
                       )
    else
      @items=Item.find(:all, :limit => @limit,
                       :joins => ("JOIN categories_items USING "+
                                  "(item_id)"),
                       :order => "created_at DESC",
                       :conditions =>
                       ["created_at>(NOW() - INTERVAL :displayinterval) AND "+
                        "meta_id=:id1 AND category_id=:id2",params]
                       )
    end
    @display_confidence=true
    @display_category=true
    render :list
  end

  def apply
    render :text => "Nein."
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
