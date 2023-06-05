RSpec.describe SortParam::Fields do
  let(:fields) { described_class.new }
  let(:with_sort_fields) { described_class.new("+first_name,-last_name:nulls_first") }

  describe "#initialize" do
    context "without :sort_string" do
      it "creates an empty Fields instance" do
        expect(fields).to be_a(SortParam::Fields)
        expect(fields).to be_empty
      end
    end

    context "with :sort_string" do
      it "creates a Fields instance containing the sort fields" do
        expect(with_sort_fields).to be_a(SortParam::Fields)
        expect(with_sort_fields).not_to be_empty

        sort_fields = with_sort_fields.to_a
        expect(sort_fields.first.name).to eql("first_name")
        expect(sort_fields.first.direction).to eql(:asc)
        expect(sort_fields.first.nulls).to be_nil

        expect(sort_fields.last.name).to eql("last_name")
        expect(sort_fields.last.direction).to eql(:desc)
        expect(sort_fields.last.nulls).to eql(:first)
      end
    end
  end

  describe "#names" do
    it "returns the name of the sort fields" do
      expect(with_sort_fields.names).to eql(%w[first_name last_name])
    end
  end

  describe "#<<" do
    it "appends a sort field" do
      fields << SortParam::Field.new("field1", :asc)
      fields << SortParam::Field.new("field2", :desc, :last)

      sort_fields = fields.to_a
      expect(sort_fields[0].name).to eql("field1")
      expect(sort_fields[0].direction).to eql(:asc)
      expect(sort_fields[0].nulls).to be_nil

      expect(sort_fields[1].name).to eql("field2")
      expect(sort_fields[1].direction).to eql(:desc)
      expect(sort_fields[1].nulls).to eql(:last)
    end
  end

  describe "#[]" do
    it "returns the sort field with the given name" do
      expect(with_sort_fields["first_name"].name).to eql("first_name")
      expect(with_sort_fields["last_name"].name).to eql("last_name")
      expect(with_sort_fields["email"]).to be_nil
    end
  end

  describe "#empty?" do
    it "returns true if there are no sort fields" do
      expect(fields).to be_empty
      expect(with_sort_fields).not_to be_empty
    end
  end

  describe "#each" do
    it "iterates over the sort field instances" do
      sort_fields = []

      with_sort_fields.each do |field|
        sort_fields << field
      end

      expect(sort_fields.size).to be(2)
      expect(sort_fields.map(&:name)).to eql(%w[first_name last_name])
    end
  end
end
