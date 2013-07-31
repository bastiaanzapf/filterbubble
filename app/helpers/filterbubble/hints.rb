
require 'helpers/filterbubble/crm'
require 'helpers/filterbubble/download'
require 'helpers/filterbubble/parse'

def train_all_hints
  hints=Hint.all(:conditions => {"processed"=>'f'})
  hints.each do |hint|
    fmt=hint.item.feed.format[0]
    if (fmt)
      begin
        @item=hint.item
        html=http_get(@item.link)
        doc=parse_html(html)
        @text=extract_xpath_text(doc,fmt.parameter)
        crm_learn(@text,hint.meta_id,hint.category_id)
      rescue URI::Error => e
        puts "URI-Fehler:"
        puts e
      rescue => e
        puts e
      end
      hint.processed=true
      hint.save
      begin
        hint.item.category.delete(hint.item.category[0])
      rescue ActiveRecord::AssociationTypeMismatch => e
        puts "No such category"
        puts e
      end
    end
  end
  return "";
end
