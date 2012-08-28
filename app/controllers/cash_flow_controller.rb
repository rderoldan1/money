class CashFlowController < ApplicationController

  def month
    require 'date'

    # @todo fic this crap
    month = Date.strptime( params[:month], "%m" )

    @date = month.strftime("%B %Y")

    @income = Transaction.amounts :month => params[:month], :type => 'credit', :bank => 1, :like => %w"ve ssm constructs deposit transfer"
    @income_sum = 0
    if !@income.nil?
      @income.each {|k, v| @income_sum += v }
    end

    @expense = Transaction.amounts :month => params[:month], :type => 'debit', :bank => [1, 2] , :unlike => %w"transfer" + ['credit card payment', 'cash withdr']
    @expense_sum = 0
    if !@expense.nil?
      @expense.each {|k, v| @expense_sum += v }
    end

    @net = @income_sum - @expense_sum

  end

end
