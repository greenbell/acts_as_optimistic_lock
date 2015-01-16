# coding: utf-8
require 'spec_helper'

describe ActsAsOptimisticLock do
  before do
    @versioned = FactoryGirl.create(:versioned)
  end

  describe "with saving" do
    it "increases version" do
      expect{ @versioned.save! }.to change{ @versioned.version }.from(1).to(2)
    end
  end

  describe "with concurrent operation" do
    before do
      @versioned2 = Versioned.find(@versioned.id)
    end

    it { expect(@versioned.name).to eq("Versioned Record") }

    context "when saved elsewhere" do
      before do
        @versioned2.name = "Changed"
        @versioned2.save!
      end
      it { expect(@versioned.save).to be_falsey }
      describe "with retrieval of updated value" do
        before do
          @versioned.save
        end
        it { expect(@versioned.name).to eq("Changed") }
      end
    end

    describe "when version is higher" do
      before do
        @versioned.version = @versioned2.version + 1
      end
      it { expect(@versioned.save).to be_falsey }
    end

    context "when deleted elsewhere" do
      before do
        @versioned2.delete
      end
      it { expect(@versioned.save).to be_falsey }
      context "on failure" do
        before do
          @versioned.save
        end
        it { expect(@versioned.errors.size).to eq(1) }
        it { expect(@versioned.errors[:base].size).to eq(1) }
        it "should have validation error message 'This record was deleted.'" do
          expect(@versioned.errors[:base][0]).to eq('This record was deleted elsewhere.')
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
        @unversioned.versioned.name += 'abc'
        @unversioned.name += 'abc'
        @unversioned.save!
      end
      subject { @unversioned.versioned }

      it "increases version" do
        expect(subject.version).to eq(@version_no + 1)
      end

      context "and record was updated elsewhere" do
        before do
          Versioned.find(@versioned.id).save!
        end
        it { expect(@unversioned.save).to be_falsey }
      end
    end
  end

  describe "with configuration" do
    before do
      @revisioned = FactoryGirl.create(:revisioned)
    end
    it { expect(Versioned.version_column).to eq(:version) }
    it { expect(Revisioned.version_column).to eq(:revision) }

    it "revision should be 2 after saving" do
      @revisioned.save!
      expect(@revisioned.revision).to eq(2)
    end

    context "when saved elsewhere" do
      before do
        Revisioned.find(@revisioned.id).save!
      end
      it { expect(@revisioned.save).to be_falsey }
      context "on failure" do
        before do
          @revisioned.save
        end
        it { expect(@revisioned.errors.size).to eq(1) }
        it { expect(@revisioned.errors[:base].size).to eq(1) }
        it "should have validation error message 'revision is old'" do
          expect(@revisioned.errors[:base][0]).to eq('revision is old')
        end
      end
    end

    context "when deleted elsewhere" do
      before do
        Revisioned.destroy(@revisioned.id)
      end
      subject { @revisioned }

      it "fails to save" do
        expect(subject.save).to be_falsey
      end

      context "on failure" do
        before do
          @revisioned.save
        end
        it { expect(@revisioned.errors.size).to eq(1) }
        it { expect(@revisioned.errors[:base].size).to eq(1) }
        it "should have validation error message 'no longer exists'" do
          expect(@revisioned.errors[:base][0]).to eq('no longer exists')
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
        expect(@locale_ja.errors[:base][0]).to eq('他の場所で先に更新されています。')
      end
    end

    context "when deleted elsewhere" do
      before do
        LocaleJa.destroy(@locale_ja.id)
        @locale_ja.save
      end
      it "should have validation error message '他の場所で先に削除されています。'" do
        expect(@locale_ja.errors[:base][0]).to eq('他の場所で先に削除されています。')
      end
    end
  end

  context "with STI table" do
    before do
      @employee = FactoryGirl.create(:employee)
      @employer = @employee.becomes(Employer)
    end

    it "does not fail stating 'already deleted'" do
      expect(@employer.valid?).to be_truthy
    end
  end
end
