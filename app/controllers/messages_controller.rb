=begin rdoc
date::2009.06.10
auth:yasui
====メッセージコントローラー
=end
class MessagesController < ApplicationController
#■INDEX
# GET /messages
# GET /messages.xml
  def index
    @messages = Message.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
      format.pdf {
        prawnto :prawn => {
          :page_layout => :portrait, # A4縦
          :page_size => "A4",
          :left_margin => 36,
          :right_margin => 24,
          :top_margin => 24,
          :bottom_margin => 24},
        :inline => true
      }
    end
  end

#■SHOW
# GET /messages/1
# GET /messages/1.xml
  def show
    @message = Message.find(params[:id])
    @messages = Message.all
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

#■NEW
# GET /messages/new
# GET /messages/new.xml
  def new
    @message = Message.new
    @message.staff_id = try(:current_user).staff.id
    @message.date = Date.today
# 以上変更
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

#■EDIT
# GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

#■CREATE
# POST /messages
# POST /messages.xml
  def create
    @message = Message.new(params[:message])
    respond_to do |format|
      if @message.save
        flash[:notice] = 'Message was successfully created.'
        format.html { redirect_to(@message) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

#■UPDATE
# PUT /messages/1
# PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])
    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

#■DESTROY
# DELETE /messages/1
# DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
end