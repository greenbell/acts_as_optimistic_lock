require 'spec_helper'

describe ActsAsOptimisticLock do
  before do
    @versioned = Factory.create(:versioned)
  end

  describe "when saving" do
    subject { @versioned }
    its(:version) { should == 1 }
    it "s version should be 2 after saving" do
      @versioned.save!
      @versioned.version.should == 2
    end
  end

  describe "with concurrent operation" do
    before do
      @versioned2 = Versioned.find(@versioned.id)
    end

    describe "when saved elsewhere" do
      before do
        @versioned2.save!
      end
      it { @versioned.save.should be_false }
    end

    describe "when version is higher" do
      before do
        @versioned.version = @versioned2.version + 1
      end
      subject { @versioned }
      its(:save) { should be_false }
    end
  end

  describe "with association" do
    before do
      @version_no = @versioned.version
    end

    describe "when associated model was saved" do
      before do
        @unversioned = @versioned.unversioned
        @version_no = @unversioned.versioned.version
        @unversioned.name += 'abc'
        @unversioned.save!
      end
      subject { @unversioned.versioned }
      its(:version) { should == @version_no + 1 }

      describe "when record was updated elsewhere" do
        before do
          Versioned.find(@versioned.id).save!
        end
        subject { @unversioned }
        its(:save) { should be_false }
      end
    end
  end

  describe "with configuration" do
    before do
      @revisioned = Factory.create(:revisioned)
    end
    it { Versioned.version_column.should == 'version' }
    it { Revisioned.version_column.should == 'revision' }

    it "revision should be 2 after saving" do
      @revisioned.save!
      @revisioned.revision.should == 2
    end

    describe "when saved elsewhere" do
      before do
        Revisioned.find(@revisioned.id).save!
      end
      subject { @revisioned }
      its(:save) { should be_false }
      describe "on failure" do
        before do
          @revisioned.save
        end
        it { @revisioned.errors.should have(1).items }
        it { @revisioned.errors[:revision].should have(1).items }
        it "should have validation error message 'is old'" do
          @revisioned.errors[:revision][0].should == 'is old'
        end
      end
    end
  end
end
