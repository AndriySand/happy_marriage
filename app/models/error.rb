class Error < ActiveRecord::Base
  validates :email_uid, :email_time, :email_body, :error_description, :presence => true
end
