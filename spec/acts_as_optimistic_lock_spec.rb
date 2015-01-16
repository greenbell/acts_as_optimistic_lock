# coding: utf-8
require 'spec_helper'

describe ActsAsOptimisticLock do
  before do
    @versioned = FactoryGirl.create(:versioned)
  end

  describe "with saving" do
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

    it { @versioned.name.should == "Versioned Record" }

    context "when saved elsewhere" do
      before do
        @versioned2.name = "Changed"
        @versioned2.save!
      end
      it { @versioned.save.should be_false }
      describe "with retrieval of updated value" do
        before do
          @versioned.save
        end
        it { @versioned.name.should == "Changed" }
      end
    end

    describe "when version is higher" do
      before do
        @versioned.version = @versioned2.version + 1
      end
      it { @versioned.save.should be_false }
    end

    context "when deleted elsewhere" do
      before do
        @versioned2.delete
      end
      it { @versioned.save.should be_false }
      context "on failure" do
        before do
          @versioned.save
        end
        it { @versioned.errors.should have(1).items }
        it { @versioned.errors[:base].should have(1).items }
        it "should have validation error message 'This record was deleted.'" do
          @versioned.errors[:base][0].should == 'This record was deleted elsewhere.'
        end
      end
    end
  end

  describe "with association" do
    before do
      @version_no = @versioned.version
    end

    context "when associated model was saved" do
      before do
        @unversioned = @versioned.unversioned
        @version_no = @unversioned.versioned.version
        @unversioned.name += 'abc'
        @unversioned.save!
      end
      subject { @unversioned.versioned }
      its(:version) { should == @version_no + 1 }

      context "and record was updated elsewhere" do
        before do
          Versioned.find(@versioned.id).save!
        end
        it { @unversioned.save.should be_false }
      end
    end
  end

  describe "with configuration" do
    before do
      @revisioned = FactoryGirl.create(:revisioned)
    end
    it { Versioned.version_column.should == :version }
    it { Revisioned.version_column.should == :revision }

    it "revision should be 2 after saving" do
      @revisioned.save!
      @revisioned.revision.should == 2
    end

    context "when saved elsewhere" do
      before do
        Revisioned.find(@revisioned.id).save!
      end
      it { @revisioned.save.should be_false }
      context "on failure" do
        before do
          @revisioned.save
        end
        it { @revisioned.errors.should have(1).items }
        it { @revisioned.errors[:base].should have(1).items }
        it "should have validation error message 'revision is old'" do
          @revisioned.errors[:base][0].should == 'revision is old'
        end
      end
    end

    context "when deleted elsewhere" do
      before do
        Revisioned.destroy(@revisioned.id)
      end
      subject { @revisioned }
      its(:save) { should be_false }
      context "on failure" do
        before do
          @revisioned.save
        end
        it { @revisioned.errors.should have(1).items }
        it { @revisioned.errors[:base].should have(1).items }
        it "should have validation error message 'no longer exists'" do
          @revisioned.errors[:base][0].should == 'no longer exists'
        end
      end
    end

  end

  describe "i18n" do
    before do
      I18n.locale = :ja
      @locale_ja = FactoryGirl.create(:locale_ja)
    end
    context "when saved elsewhere" do
      before do
        LocaleJa.find(@locale_ja.id).save!
        @locale_ja.save
      end
      it "should have validation error message '他の場所で先に更新されています。'" do
        @locale_ja.errors[:base][0].should == '他の場所で先に更新されています。'
      end
    end

    context "when deleted elsewhere" do
      before do
        LocaleJa.destroy(@locale_ja.id)
        @locale_ja.save
      end
      it "should have validation error message '他の場所で先に削除されています。'" do
        @locale_ja.errors[:base][0].should == '他の場所で先に削除されています。'
      end
    end
  end

  context "with STI table" do
    before do
      @employee = FactoryGirl.create(:employee)
      @employer = @employee.becomes(Employer)
    end

    it "does not fail stating 'already deleted'" do
      @employer.valid?.should be_true
    end
  end
end
