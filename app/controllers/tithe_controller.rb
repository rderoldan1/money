class TitheController < ApplicationController

  def index
  end

  def month
    require 'date'

    month = Date.strptime( params[:month], "%m" )

    @giving = Transaction.amounts :month => params[:month], :type => 'debit', :bank => 1, :like => %w"support mission tithe"

    @giving_total = 0
    if ! @giving.nil?
      @giving.each {|k, v| @giving_total += v }
    end

    @income = Transaction.amounts :month => params[:month], :type => 'credit', :bank => 1, :like => %w"ve ssm" + ['new constructs']

    @income_total = 0
    if ! @income.nil?
      @income.each {|k, v| @income_total += v }
    end


    @tithe = @income_total * 0.1 - @giving_total
    @date = month.strftime("%B %Y")

  end

end
