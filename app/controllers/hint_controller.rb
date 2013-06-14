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
end
