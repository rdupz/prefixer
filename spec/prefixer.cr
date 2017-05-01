require "spec"
require "../src/prefixer/*"

Spec.before_each do
  Prefixer.blind = false
  Prefixer.no_update = false
  Prefixer.update_only = false
  Prefixer.squash = false
  Prefixer.prefixes = [/A\-/, /B\-/, /C\-/]
end

describe "Prefixer" do
  describe "#prefix" do
    it "prefixes simple names" do
      Prefixer.prefix = "C-"
      Prefixer.prefix("foo").should eq "C-foo"
    end
    it "prefixes complex names" do
      Prefixer.prefix = "B-"
      Prefixer.prefix("C-A-foo.bar-A-B").should eq "B-A-foo.bar-A-B"
    end
  end
  describe "#unprefix" do
    it "unprefixes simple names" do
      Prefixer.unprefix("C-foo").should eq "foo"
    end
    it "unprefixes complex names" do
      Prefixer.unprefix("C-A-foo.bar-A-B").should eq "A-foo.bar-A-B"
    end
  end
  describe "#blind" do
    it "blindly prefixes simple names" do
      Prefixer.prefix = "A-"
      Prefixer.blind = true
      Prefixer.prefix("A-foo").should eq "A-A-foo"
    end
    it "blindly prefixes complex names" do
      Prefixer.unprefix("C-A-foo.bar-A-B").should eq "A-foo.bar-A-B"
      Prefixer.prefix = "A-"
      Prefixer.blind = true
      Prefixer.prefix("C-A-foo.bar-A-").should eq "A-C-A-foo.bar-A-"
    end
  end
  describe "#no-update" do
    it "ignores prefixed names" do
      Prefixer.prefix = "A-"
      Prefixer.no_update = true
      Prefixer.blind.should eq false
      Prefixer.prefix("C-foo").should eq "C-foo"
    end
    it "prefixes non-prefixed names" do
      Prefixer.prefix = "A-"
      Prefixer.no_update = true
      Prefixer.prefix("foo").should eq "A-foo"
    end
  end
  describe "#update-only" do
    it "ignores non-prefixed names" do
      Prefixer.prefix = "A-"
      Prefixer.update_only = true
      Prefixer.prefix("foo").should eq "foo"
    end
    it "prefixes prefixed names" do
      Prefixer.prefix = "A-"
      Prefixer.update_only = true
      Prefixer.prefix("B-foo").should eq "A-foo"
    end
  end
  describe "#squash" do
    it "correctly squash simple names" do
      Prefixer.prefix = "A-"
      Prefixer.squash = true
      Prefixer.prefix("foo").should eq "A-foo"
      Prefixer.prefix("A-foo").should eq "A-foo"
      Prefixer.prefix("B-A-foo").should eq "A-foo"
    end
    it "correctly squash complex names" do
      Prefixer.prefix = "A-"
      Prefixer.squash = true
      Prefixer.prefix("C-A-foo.bar-A-B-").should eq "A-foo.bar-A-B-"
      Prefixer.prefix("B-A-").should eq "A-"
    end
  end
end
