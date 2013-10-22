class Provider < User
  class_attribute :npi

  has_one :provider_speciality, dependent: :destroy
  has_many :provider_names, dependent: :destroy
  has_many :affiliations, dependent: :destroy

  accepts_nested_attributes_for :provider_speciality, :provider_names, :affiliations
end

