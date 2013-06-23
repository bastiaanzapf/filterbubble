class HintController < ApplicationController
  def blank
    @categories=Category.find(:all,:conditions=>["meta_id=:meta_id",{:meta_id => 1}])
  end
  def new
    # item * hint -> ()
    item=Item.find(:first,:conditions => {"link" => request.POST['url']})
    if (!item)
      item=Item.create(:feed_id => 0, 
                       :link => request.POST['url'] )
    end
    
    @i=request.POST['category']
    Hint.create :meta_id => 1, 
                :category_id => request.POST['category'], 
                :item_id => item.item_id,
                :processed => false
    
    redirect_to :action=>'blank', :status => 302
  end

  def new_by_ids
    # item * hint -> ()
    
    Hint.create(:meta_id => params[:meta_id], 
                :category_id => params[:category_id], 
                :item_id => params[:item_id],
                :processed => false)
    
    c=Category.find(:first,
                    :conditions =>
                    ["meta_id=:meta_id AND "+
                     "category_id!=:category_id",
                     params]);

    redirect_to("/item/list/"+params[:meta_id]+
                "/"+c[:category_id].to_s,
                :status => 302)
  end
end
