module GroupRecsHelper
# group_recs_controller>index calls
  def grp_recs
    p = GroupRec.find(session[:ext0]) 
    p = p.select {|i| i.group_id.to_s  == params[:grp]} if params[:grp]
    p = p.sort {|x, y| y.hizuke <=> x.hizuke}   #日付で降順ソート
    session[:ext0] = p.map{|i| i.id}
    return p	  	                       
  end  	
	
end
