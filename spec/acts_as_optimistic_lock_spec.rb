require 'spec_helper'

describe ActsAsOptimisticLock do
  before do
    @versioned = Factory.create(:versioned)
    @revisioned = Factory.create(:revisioned)
  end
  
  describe "when saved first" do
    subject { @versioned }
    its(:version) { should eq(1) }
  end
end
