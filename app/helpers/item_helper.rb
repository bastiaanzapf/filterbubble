module ItemHelper

  def getCategory(id1,id2)
    Category.find(:first,
                  :conditions => 
                  { "meta_id"=>id1,
                    "category_id"=>id2
                  })
  end
end
