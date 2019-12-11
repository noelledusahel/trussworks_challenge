require './normalizer.rb'

describe Normalizer do
  normalizer = Normalizer.new
  describe "#format_timestamp" do
    it 'should return a timestamp formated for ISO-8601' do
      expect(normalizer.format_timestamp('4/1/11 11:00:00 AM')).to eq('2004-01-11T06:00:00-05:00')
    end
  end

  describe '#format_zip' do
    it 'formats zipcode with preceeding zeros when under 5 digits in length' do
      zip = '292'
      normalizer.format_zip(zip)
      expect(normalizer.format_zip(zip)).to eq('00292')
    end
  end
  describe '#format_fullname' do
    it 'formats fullname with all uppercase' do
      name = 'Superman übertan'
      expect(normalizer.format_fullname(name)).to eq(name.upcase)
    end
  end
  describe '#format_address' do
    it 'runs unicode validation on address' do
      address = "Somewhere Else, In Another Time, äB"
      expect(normalizer.format_address(address).valid_encoding?).to be(true)
    end
  end
  describe '#format_duration' do
    it 'converts duration to total seconds' do
      duration = '1:00:00.00'
      expect(normalizer.format_duration(duration)).to be_a(Float)
      expect(normalizer.format_duration(duration)).to eq(3600.0)
    end
  end
end