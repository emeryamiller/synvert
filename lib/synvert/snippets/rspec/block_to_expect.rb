Synvert::Rewriter.new "convert_rspec_block_to_expect", "RSpec converts block to expect" do
  gem_spec 'rspec', '2.11.0'

  {should: 'to', should_not: 'not_to'}.each do |old_message, new_message|
    within_files 'spec/**/*.rb' do
      # lambda { do_something }.should raise_error => expect { do_something }.to raise_error
      # proc { do_something }.should raise_error => expect { do_something }.to raise_error
      # -> { do_something }.should raise_error => expect { do_something }.to raise_error
      with_node type: 'send', receiver: {type: 'block'}, message: old_message do
        replace_with "expect { {{receiver.body}} }.#{new_message} {{arguments}}"
      end
    end
  end
end
