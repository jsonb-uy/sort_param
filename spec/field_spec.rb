RSpec.describe SortParam::Field do
  subject(:field) { described_class.new("users.first_name", :desc, :last) }

  describe "#name" do
    it "returns the name" do
      expect(field.name).to eql("users.first_name")
    end
  end

  describe "#direction" do
    it "returns the sort direction" do
      expect(described_class.new("field1", :asc).direction).to eql(:asc)
      expect(described_class.new("field2", :desc).direction).to eql(:desc)
    end
  end

  describe "#nulls" do
    it "returns the nulls sort order" do
      expect(described_class.new("field1", :asc, :first).nulls).to eql(:first)
      expect(described_class.new("field2", :desc, :last).nulls).to eql(:last)
      expect(described_class.new("field3", :asc).nulls).to be_nil
    end
  end

  describe ".from_string" do
    context "with blank sort fields" do
      it "returns nil" do
        expect(described_class.from_string(" ")).to be_nil
        expect(described_class.from_string(nil)).to be_nil
        expect(described_class.from_string("")).to be_nil
        expect(described_class.from_string("+")).to be_nil
        expect(described_class.from_string("-")).to be_nil
      end
    end

    context "with valid sort field" do
      it "returns a Field instance" do
        field1 = described_class.from_string("field1")
        field2 = described_class.from_string("+field2")
        field3 = described_class.from_string("-field3")
        field4 = described_class.from_string("field4:nulls_first")
        field5 = described_class.from_string("-field5:nulls_last")

        expect(field1).to be_a(SortParam::Field)
        expect(field1.name).to eql("field1")
        expect(field1.direction).to eql(:asc)
        expect(field1.nulls).to be_nil

        expect(field2).to be_a(SortParam::Field)
        expect(field2.name).to eql("field2")
        expect(field2.direction).to eql(:asc)
        expect(field2.nulls).to be_nil

        expect(field3).to be_a(SortParam::Field)
        expect(field3.name).to eql("field3")
        expect(field3.direction).to eql(:desc)
        expect(field3.nulls).to be_nil

        expect(field4).to be_a(SortParam::Field)
        expect(field4.name).to eql("field4")
        expect(field4.direction).to eql(:asc)
        expect(field4.nulls).to eql(:first)

        expect(field5).to be_a(SortParam::Field)
        expect(field5.name).to eql("field5")
        expect(field5.direction).to eql(:desc)
        expect(field5.nulls).to eql(:last)
      end
    end
  end
end
