class TitheController < ApplicationController

  def month
    require 'date'

    month = Date.strptime( params[:month], "%m" )

    where = "
          debit is not null
      and transactions.date between ? and ?
      and (
            lower(meta.descriptor) like '%support%'
        or  lower(meta.descriptor) like '%mission%'
        or  lower(meta.descriptor) like '%tithe%'
      )
    "

    @giving = Bank.find(1).transactions.joins(:meta).where(where, month.strftime("%Y-%m-%d"), month.end_of_month.strftime("%Y-%m-%d"))
    @giving_total = @giving.sum(:debit)

    where = "
          credit is not null
      and transactions.date between ? and ?
      and (
            lower(meta.descriptor) like '%VE%'
        or  lower(meta.descriptor) like '%SSM%'
      )
    "

    @income = Bank.find(1).transactions.joins(:meta).where(where, month.strftime("%Y-%m-%d"), month.end_of_month.strftime("%Y-%m-%d"))
    @income_total = @income.sum(:credit)

    @tithe = @income_total * 0.1 - @giving_total
    @date = month.strftime("%B %Y")

  end

end
