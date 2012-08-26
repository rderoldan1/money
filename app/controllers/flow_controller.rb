class FlowController < ApplicationController

  def index
    @transactions = Transaction.order("date DESC")
  end

  def month
  end

  def update

    params[:transactions].each do |k, v|

      if v[:descriptor].empty?
        next
      end

      id = k.split('-')[1].to_i

      @transaction = Transaction.find( id )

      if @transaction.meta

        @transaction.meta.update_attributes( v )

      else

        @transaction.create_meta! v

      end


    end

    redirect_to flow_edit_path

  end

  def edit
    @transactions = Transaction.order("date DESC")
  end

  def tithe
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

    @tithe = ( @income_total - @giving_total ) * 0.1

  end

end
