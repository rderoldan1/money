class CashFlowController < ApplicationController
  require 'date'

  def item
    @items = Transaction.items :month => params[:month], :bank => [1,2], :equal => [ params[:item] ], :type => 'debit'
    @items_sum = @items.sum('debit')
  end

  def index
    first = Transaction.minimum('date')
    dates = (first.to_date.beginning_of_month..Date.today.end_of_month).map{|m| m.strftime('%Y-%m')}.uniq.reverse
    @transactions = []
    @total  = {}

    dates.each do |month|
      transaction = {}
      transaction[:month]   = month
      transaction[:date]    = Date.strptime( month, '%Y-%m' ).strftime('%Y %B')
      transaction[:income]  = Transaction.income_total month
      transaction[:expense] = Transaction.expense_total month
      transaction[:net]     = transaction[:income] - transaction[:expense]

      @transactions << transaction

    end

    @total[:expense] = Transaction.expense_total "-1"
    @total[:income]  = Transaction.income_total "-1"
    @total[:net]     = @total[:income] - @total[:expense]
  end

  def month

    @month       = params[:month]
    @date        = Transaction.format_date params[:month]
    @date        = @date.to_date.strftime('%B %Y')

    @income      = Transaction.income params[:month]
    @income_sum  = Transaction.income_total params[:month]

    @expense     = Transaction.expense params[:month]
    @expense_sum = Transaction.expense_total params[:month]

    @net = @income_sum - @expense_sum

  end

end
