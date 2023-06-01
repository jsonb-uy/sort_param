RSpec.describe SortParam do
  describe ".define" do
    context "with column definition block" do
      it "creates a Definition instance" do
        definition = SortParam.define do
          field :email
          field :first_name
        end

        expect(definition).to be_a(SortParam::Definition)
      end
    end

    context "with no block given" do
      it "raises an error" do
        expect { SortParam.define }.to raise_error(ArgumentError)
      end
    end
  end
end
