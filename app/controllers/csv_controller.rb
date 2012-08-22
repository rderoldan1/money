class CsvController < ApplicationController

  def import

    require 'csv'
    require 'date'
    require 'digest'

    CSV.foreach( params[:bank_transaction][:csv], { :headers => true } ) do |row|
      out = {}
      out["sha1_digest"] = Digest::SHA1::hexdigest row.to_s
      row["No."].strip!
      row["Date"] = Date.strptime(row["Date"], '%m/%d/%Y')
                        .strftime('%Y-%m-%d %H:%M:%S')
    end
    
  end

end
