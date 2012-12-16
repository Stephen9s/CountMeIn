class MessagesController < ApplicationController
  
  before_filter :authenticate_user
  
  def index
    # Used to display all messages
    @received = Message.find(:all,  :conditions => ["messages.receiver_id = ?", current_user.id])
    @sent = Message.find(:all,  :conditions => ["messages.sender_id = ?", current_user.id])
    
    render 'index'
  end
  
  def new
    @message = Message.new
  end
  
  def create
    
    if params[:message][:receiver_id] == ""
      flash[:error_receiver] = "Receiver does not exist"
    end
    
    if params[:message][:subject] == ""
      flash[:error_subject] = "Subject not present."
    end
    
    if params[:message][:body] == ""
      flash[:error_body] = "Body not present."
    end
    
    if params[:message][:receiver_id] != ""
      @message = Message.new(params[:message])
      @message.sender_id = current_user.id
      
      if @message.save
        redirect_to inbox_path, :notice => "Message sent!"
      else
        redirect_to inbox_new_path, :notice => "Unable to send message!"
        #render :action => 'new'
      end
      
    else
      render "messages/new"
    end
        
  end
  
  def view

    if Message.exists?(params[:message])
      
      @message = Message.find(params[:message])
      
      if current_user.id != @message.sender_id && current_user.id != @message.receiver_id
        redirect_to inbox_path
      else
        if current_user.id == @message.receiver_id
          @message.mark_as_read
        end
        render "view"
      end
      
    else
      redirect_to inbox_path
    end
    
  end
  
  def destroy
    
    if Message.exists?(params[:message])
      
      message = Message.find(params[:message])
      
      if current_user.id == message.receiver_id
        message.destroy
        redirect_to inbox_path, :notice => "Message deleted!"
      else
        redirect_to inbox_path, :notice => "Failed to delete message!"
      end    
    else
        redirect_to inbox_path, :notice => "Message does not exist!"
    end
    
  end
  
end
