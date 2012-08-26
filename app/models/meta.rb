class Meta < ActiveRecord::Base
  attr_accessible :descriptor, :transaction_id

  def descriptor
    self.descriptor = 'a'
  end

end
