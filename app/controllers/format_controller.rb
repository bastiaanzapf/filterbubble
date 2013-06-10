class FormatController < ApplicationController
  def list
    @formats=Format.find(:all)
    @feeds=Feed.find(:all)
  end
  def edit
    @fmt=Format.find(:first,:conditions => { :format_id => params[:id] })
  end
  def update
    fmt=Format.find(:first,:conditions => { :format_id => params[:id] })
    fmt.parameter=request.POST['parameter']
    fmt.save
    redirect_to :action=>'edit', :status => 302, :id => fmt.format_id
  end
  def create
    format=Format.create(:algorithm => 'xpath',
                         :parameter => request.POST['parameter'])
    redirect_to :action=>'edit', :status => 302, :id => format.format_id

  end

end
