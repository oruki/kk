module AttendsHelper

  def work_hour_input(x)
    for i in %w{:00 :15 :30 :45}
      link_to_remote (x.to_s + i), :update => "posts",
          :url => { :action => "input_time_1", :tt => x.to_s + i }
    end
  end          

      
      
  def dd	
    form_tag 'grp_opt', :id => 'grp_opt' do    	
         "#{check_box_tag 'three_days', '1', session[:three_days] == '1'} ３日前より表示
          #{check_box_tag 'all_grp', '1', session[:all_grp] == '1'} 全てのｸﾞﾙｰﾌﾟを表示" 
    end
      observe_form 'grp_opt',
        :url => {:action => 'set_grp_rec', :id => @attend.id },
        :frequency => 0.5,:update => ""
  end
  
  def select_attend_date
         form_tag({:action => :show}, {:method => :get}) do 
           select_tag "attn_id",
             options_for_select( @option_for_attend_date ),
             :onchange => "submit();"
          # submit_tag "選択" 
         end
  end   
       
  def stretch_cillapse(x)
    "<span ID='show_icon01' style='margin-right:0px;float:right;'>
           #{stretch(x)}
           #{collapse(x)}                                
    </span>"
  end

  def stretch_collapse(x)
    "#{stretch(x)}
     #{collapse(x)}"
  end

  def day_prev
      # @attendが最後の要素なら矢印移動アイコンを見せない
      if @attend != @attends.last
        link_to image_tag(
            'arrow_back.gif',
            :border=>0, 
            :title=>"前:#{@attends[@prev].time_start.strftime('%y年%m月%d日')}"), 
          attend_path(@attends[@prev])
      end
  end      
  def day_next     
      # @attendが最初の要素なら矢印移動アイコンを見せない
      if @attend != @attends.first
        link_to image_tag(
            'arrow_next.gif',
            :border=>0,
            :title=>"次:#{@attends[@next].time_start.strftime('%y年%m月%d日')}"),
          attend_path(@attends[@next])
      end
  end
  
  def day_nav
      ck = DayRec.find(
             :first,
             :conditions => ["hizuke = ?", @attend.time_start.to_date])
      if ck
        link_to (@attend.time_start.strftime("%y年%m月%d日") ),
          ck,
          :title=>"#{@attend.time_start.strftime("%y年%m月%d日")}に移動"
      else
          h @attend.time_start.strftime("%y年%m月%d日")
      end

        #{go_edit(@attend)}&nbsp;
        #{go_list}
  end

end