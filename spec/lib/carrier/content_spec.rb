require_relative '../../../lib/lib'

describe Carrier::Content do

  subject { Carrier::Content.new }

  let(:origin) { 'Melbourne, VIC, Australia'}
  let(:package1) { Carrier::Package.new(length: 5, width: 2, height: 2, weight: 3, destination: 'Ringwood, VIC, Australia') }
  let(:package2) { Carrier::Package.new(length: 5, width: 1, height: 3, weight: 2, destination: 'Ringwood, VIC, Australia') }
  let(:package3) { Carrier::Package.new(length: 1, width: 3, height: 2, weight: 2, destination: 'Boronia, VIC, Australia') }
  let(:package4) { Carrier::Package.new(length: 1, width: 5, height: 5, weight: 5, destination: 'Belgrave, VIC, Australia') }
  let(:package5) { Carrier::Package.new(length: 5, width: 2, height: 1, weight: 3, destination: 'Belgrave, VIC, Australia') }
  let(:package6) { Carrier::Package.new(length: 3, width: 2, height: 1, weight: 3, destination: 'Belgrave, VIC, Australia') }
  let(:packages) do
    [package4, package6, package5, package3, package1, package2]
   end

  before do
    allow(subject).to receive(:build_route).with(any_args) { route }
  end

  context '#new' do
    it { expect(subject).to be_an_instance_of Carrier::Content }
    it { expect(subject).to eq [] }
  end

  context '#sort_by_origin' do
    subject { Carrier::Content.new(*packages)}
    it { expect(subject.sort_by_origin(origin, [])).to eq sorted_packages}
  end

  let(:route) do
    [
      {"origin"=>"Melbourne, VIC, Australia","destination"=>"Ringwood, VIC, Australia","distance"=>{"text"=>"28.0 km","value"=>28042}, "duration"=>{"text"=>"34 mins","value"=>2051}, "status"=>"OK"},
      {"origin"=>"Ringwood, VIC, Australia","destination"=>"Boronia, VIC, Australia","distance"=>{"text"=>"11.4 km","value"=>11363}, "duration"=>{"text"=>"14 mins","value"=>839}, "status"=>"OK"},
      {"origin"=>"Boronia, VIC, Australia","destination"=>"Belgrave, VIC, Australia","distance"=>{"text"=>"10.7 km","value"=>10659}, "duration"=>{"text"=>"15 mins","value"=>928}, 
      "status"=>"OK"}
    ]
   end

   let(:sorted_packages) do
     [package1, package2, package3, package4, package5, package6]
   end

end