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

    #redirect_to flow_edit_path

  end

  def edit
    @transactions = Transaction.order("date DESC")
  end

end
