class AgendaController < ApplicationController
  def index
    @events = Event.all
    @events_by_date = @events.group_by(&:end_date)
    @date = params[:date] ? Date.strptime(params[:date], "%Y-%m-%d") : Date.today
  end
end
