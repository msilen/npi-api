class ProviderSpeciality < ActiveRecord::Base
  belongs_to :speciality
  belongs_to :provider

  validates :speciality_id, :license_number, :state, :country, presence: true
end

