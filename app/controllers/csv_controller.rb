class CsvController < ApplicationController

  def upload
  end

  def import

    require 'csv'
    require 'date'
    require 'digest'

    @bank = Bank.find( params[:transaction][:bank] )

    CSV.new( params[:upload][:csv].tempfile, { :headers => true } ).each do |row|

      out = {}

      if @bank.id == 1
        #Regions bank

        out["date"]         = Date.strptime(row["Date"], '%m/%d/%Y').strftime('%Y-%m-%d %H:%M:%S')
        out["check_number"] = row["No."].strip
        out["debit"]        = row["Debit"]
        out["credit"]       = row["Credit"]

      else 
        #Chase bank

        out["date"]       = Date.strptime(row["Post Date"], '%m/%d/%Y').strftime('%Y-%m-%d %H:%M:%S')
        out["trans_date"] = Date.strptime(row["Trans Date"], '%m/%d/%Y').strftime('%Y-%m-%d %H:%M:%S')
        out["debit"]      = row["Amount"].to_f.abs unless row["Amount"].to_f > 0
        out["credit"]     = row["Amount"].to_f.abs unless row["Amount"].to_f < 0
        out["trans_type"] = row["Type"]
        
      end
     
      out["description"]  = row["Description"]
      out["sha1_digest"]  = Digest::SHA1::hexdigest row.to_s
      out["bank_id"]      = params[:transaction][:bank]

      @bank.transactions.create out

    end

    redirect_to transactions_path

  end

end
