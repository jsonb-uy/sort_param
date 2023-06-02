RSpec.describe SortParam::Definition do
  subject(:definition) { described_class.new }

  describe "#define" do
    context "with fields defined" do
      before do
        definition.define do
          field :first_name, nulls: :last
          field :last_name, nulls: :first
          field :email
        end
      end

      it "sets the fields' default options" do
        expect(definition.fields_hash).to eql(
          {
            "email" => {},
            "first_name" => { nulls: :last },
            "last_name" => { nulls: :first }
          }
        )
      end
    end

    context "with no fields defined" do
      it "raises an error" do
        expect { definition.define }.to raise_error(ArgumentError)
      end
    end
  end
end
