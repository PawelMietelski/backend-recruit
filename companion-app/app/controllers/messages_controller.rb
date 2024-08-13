class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = Message.with_attached_attachments.visible
    @hidden_messages = Message.with_attached_attachments.hidden
  end

  def hide
    @message = Message.find(params[:id])
    @message.update(hidden: true)
    TurbochatClient.new.hide_message(@message.id)
    redirect_to root_path
  end
end
