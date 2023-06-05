RSpec.describe SortParam::Formatters::Formatter do
  describe ".for" do
    context "with `pg` :mode" do
      it "returns PG formatter class" do
        expect(described_class.for(:pg)).to eql(SortParam::Formatters::PG)
      end
    end

    context "with `mysql` :mode" do
      it "returns MySQL formatter class" do
        expect(described_class.for(:mysql)).to eql(SortParam::Formatters::MySQL)
      end
    end

    context "with `hash` :mode" do
      it "returns the default Hash formatter class" do
        expect(described_class.for(:hash)).to eql(SortParam::Formatters::Hash)
        expect(described_class.for(:any_other_value)).to eql(SortParam::Formatters::Hash)
      end
    end
  end

  describe "#format" do
    subject(:abstract_formatter) { described_class.new(SortParam::Definition.new) }

    it "raises NotImplementedError" do
      expect do
        abstract_formatter.format(SortParam::Field.new("id", :asc))
      end.to raise_error(NotImplementedError)

      expect do
        abstract_formatter.format(SortParam::Field.new("name", :asc), 
                                  SortParam::Field.new("id", :asc))
      end.to raise_error(NotImplementedError)
    end
  end
end
