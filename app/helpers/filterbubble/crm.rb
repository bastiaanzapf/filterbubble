
require 'crm114'

def in_meta(meta_id,fun)

  categories=Category.find(:all,:conditions => { "meta_id"=>meta_id}) 

  syms=categories.map { |c| c["name"].to_sym() }

  Dir.chdir('../crm-data/'+meta_id.to_s+'/') do

    crm = Classifier::CRM114.new(syms)
    value=fun.call(crm)
    return value
  end
  return null
end

def crm_classify(text,meta_id)
  return in_meta(meta_id,lambda { |crm| crm.classify text } )
end

def crm_learn(text,meta_id,category_id)
  category=Category.find(:first,
                         :conditions => 
                         { "category_id"=>category_id,
                           "meta_id"=>meta_id } )
  return in_meta(meta_id,lambda { |crm| crm.train!(category.name.to_sym(),text) } )
end
