require_relative '../../lib/lib.rb'

describe BoxArray do

  subject { BoxArray.new}

  let(:starting_address) { 'Melbourne, VIC, Australia'}
  let(:boxes) do
    [double('Box', receiver_address: 'Ringwood, VIC, Australia'),
     double('Box', receiver_address: 'Belgrave, VIC, Australia'),
     double('Box', receiver_address: 'Boronia, VIC, Australia')]
   end

  it 'instanciates empty' do
    expect(subject).to be_an_instance_of BoxArray
    expect(subject).to eq []
  end

  context '#sort_by_starting_point' do
    subject { BoxArray.new(*boxes)}
    before { allow(subject).to receive(:make_request).with(anything) { api_response}}

    it { expect(subject.sort_by_starting_point(starting_address)).to eq route}
  end

  let(:route) do
    [
      {"origin"=>"Melbourne, VIC, Australia","destination"=>"Ringwood, VIC, Australia","distance"=>{"text"=>"28.0 km","value"=>28042}, "duration"=>{"text"=>"34 mins","value"=>2051}, "status"=>"OK"},
      {"origin"=>"Ringwood, VIC, Australia","destination"=>"Boronia, VIC, Australia","distance"=>{"text"=>"11.4 km","value"=>11363}, "duration"=>{"text"=>"14 mins","value"=>839}, "status"=>"OK"},
      {"origin"=>"Boronia, VIC, Australia","destination"=>"Belgrave, VIC, Australia","distance"=>{"text"=>"10.7 km","value"=>10659}, "duration"=>{"text"=>"15 mins","value"=>928}, 
      "status"=>"OK"}
    ]
   end

   let(:api_response) do
     {
      "destination_addresses"=>[
          "Melbourne VIC, Australia",
          "Ringwood VIC 3134, Australia",
          "Belgrave VIC 3160, Australia",
          "Boronia VIC 3155, Australia"
        ],
        "origin_addresses"=>[
          "Melbourne VIC, Australia",
          "Ringwood VIC 3134, Australia",
          "Belgrave VIC 3160, Australia",
          "Boronia VIC 3155, Australia"
          ],
        "rows"=>[
          {
            "elements"=>[
              {"distance"=>{"text"=>"1 m","value"=>0}, "duration"=>{"text"=>"1 min","value"=>0}, "status"=>"OK"},
              {"distance"=>{"text"=>"28.0 km","value"=>28042}, "duration"=>{"text"=>"34 mins","value"=>2051}, "status"=>"OK"},
              {"distance"=>{"text"=>"48.1 km","value"=>48055}, "duration"=>{"text"=>"48 mins","value"=>2857}, "status"=>"OK"},
              {"distance"=>{"text"=>"37.8 km","value"=>37842}, "duration"=>{"text"=>"43 mins","value"=>2596}, "status"=>"OK"}
            ]
        },
          {
            "elements"=>[
            {
              "distance"=>{"text"=>"27.6 km","value"=>27561},"duration"=>{"text"=>"30 mins","value"=>1826}, "status"=>"OK"},
              {"distance"=>{"text"=>"1 m","value"=>0}, "duration"=>{"text"=>"1 min","value"=>0}, "status"=>"OK"},
              {"distance"=>{"text"=>"21.7 km","value"=>21685}, "duration"=>{"text"=>"27 mins","value"=>1627}, "status"=>"OK"},
              {"distance"=>{"text"=>"11.4 km","value"=>11363}, "duration"=>{"text"=>"14 mins","value"=>839}, "status"=>"OK"}
            ]
        },
          {
            "elements"=>[
              {"distance"=>{"text"=>"48.9 km","value"=>48949}, "duration"=>{"text"=>"50 mins","value"=>3013}, "status"=>"OK"},
              {"distance"=>{"text"=>"21.9 km","value"=>21882}, "duration"=>{"text"=>"28 mins","value"=>1689}, "status"=>"OK"},
              {"distance"=>{"text"=>"1 m","value"=>0}, "duration"=>{"text"=>"1 min","value"=>0}, "status"=>"OK"},
              {"distance"=>{"text"=>"10.6 km","value"=>10583}, "duration"=>{"text"=>"16 mins","value"=>934}, "status"=>"OK"}
            ]
        },
          {"elements"=>[
              {"distance"=>{"text"=>"36.2 km","value"=>36197}, "duration"=>{"text"=>"41 mins","value"=>2430}, "status"=>"OK"},
              {"distance"=>{"text"=>"8.4 km","value"=>8430}, "duration"=>{"text"=>"15 mins","value"=>901}, "status"=>"OK"},
              {"distance"=>{"text"=>"10.7 km","value"=>10659}, "duration"=>{"text"=>"15 mins","value"=>928}, "status"=>"OK"},
              {"distance"=>{"text"=>"1 m","value"=>0}, "duration"=>{"text"=>"1 min","value"=>0}, "status"=>"OK"}
            ]
        }
        ],
      "status"=>"OK"
  }
  end

end