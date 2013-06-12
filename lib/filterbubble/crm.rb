
require 'crm114'

def in_meta(meta_id,fun)

  render :text => "test"

  Dir.chdir('../crm-data/'+meta_id.to_s+'/')

  categories=Category.find :conditions => { "meta_id=$1",[meta_id]} 

  syms=categories.map |c| c["name"].to_sym()

  crm = Classifier::CRM114.new(syms)

  fun(crm)

  Dir.chdir('../../')

end
