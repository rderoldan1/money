class CsvController < ApplicationController

  def upload
  end

  def import

    require 'csv'
    require 'date'
    require 'digest'

    CSV.new( params[:upload][:csv].tempfile, { :headers => true } ).each do |row|

      out = {}
      out["date"]         = Date.strptime(row["Date"], '%m/%d/%Y')
                                .strftime('%Y-%m-%d %H:%M:%S')
      out["check_number"] = row["No."].strip
      out["description"]  = row["Description"]
      out["debit"]        = row["Debit"]
      out["credit"]       = row["Credit"]
      out["sha1_digest"]  = Digest::SHA1::hexdigest row.to_s

      Transaction.create out

    end

  end

end
