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

      it "defines the whitelisted sort fields and their default options" do
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

  describe "#field" do
    it "whitelists a sort field and sets its default options" do
      definition.field(:email, { nulls: :first })
      definition.field(:first_name, { nulls: :last })
      definition.field(:last_name)

      expect(definition.fields_hash).to eql(
        {
          "email" => { nulls: :first },
          "first_name" => { nulls: :last },
          "last_name" => {}
        }
      )
    end

    it "ignores blank field name" do
      definition.field("")
      definition.field(nil)

      expect(definition.fields_hash).to be_empty
    end
  end

  describe "#field_defaults" do
    it "returns the field's configured default options" do
      definition.field(:email, { nulls: :first })
      definition.field(:last_name)

      expect(definition.field_defaults("email")).to eql(nulls: :first)
      expect(definition.field_defaults("last_name")).to eql({})
    end
  end

  xdescribe "#load_param!" do
  end
end
