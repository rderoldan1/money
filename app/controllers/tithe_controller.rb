class TitheController < ApplicationController
  require 'date'

  def index
    first = Transaction.minimum('date')
    dates = (first.to_date.beginning_of_month..Date.today.end_of_month).map{|m| m.strftime('%Y-%m')}.uniq.reverse
    @tithes = []
    @total  = {}

    dates.each do |month|
      tithe = {}
      month = Date.strptime( month, '%Y-%m' )
                  .strftime("%m")
                  .to_s
      tithe[:month]  = month
      tithe[:date]   = Date.strptime( month, '%m' ).strftime('%Y %B')
      tithe[:giving] = Transaction.giving_total month
      tithe[:income] = Transaction.income_total(month) * 0.1
      tithe[:tithe]  = Transaction.tithe month

      @tithes << tithe

    end

    @total[:giving] = Transaction.giving_total "-1"
    @total[:income] = Transaction.income_total("-1") * 0.1
    @total[:tithe]  = Transaction.tithe "-1"
    
  end

  def month

    @giving       = Transaction.giving params[:month]
    @giving_total = Transaction.giving_total params[:month]

    @income       = Transaction.income params[:month]
    @income_total = Transaction.income_total params[:month]

    @tithe        = Transaction.tithe params[:month]

  end

end
