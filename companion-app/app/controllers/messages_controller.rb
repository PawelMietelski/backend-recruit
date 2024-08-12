class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    MessagesCreator.new.call
    @messages = Message.visible
    @hidden_messages = Message.hidden
  end

  def hide
    @message = Message.find(params[:id])
    @message.update(hidden: true)
    TurbochatClient.new.hide_message(@message.id)
    redirect_to root_path
  end
end
