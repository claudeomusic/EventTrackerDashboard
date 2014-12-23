class HomeController < ApplicationController

  def index
    if user_signed_in?
      @all_events = current_user.events
      if (params[:referer_URL])
        puts "made it here"
        @events = current_user.events.where(referer_URL: params[:referer_URL])
      else
        @events = current_user.events
      end

    end
  end
end