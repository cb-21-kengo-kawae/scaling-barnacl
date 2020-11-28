RSpec.describe Policy, type: :model do
  describe Policy do
    subject { described_class.new }
    it { is_expected.to validate_presence_of(:name) }

    it do
      is_expected.to define_enum_for(:policy_type).with(%i[menu func app])
    end
  end
end
