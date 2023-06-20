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

    it "returns the same Field instance" do
      expect(definition.field(:name)).to eql(definition)
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

  describe "#load!" do
    it_behaves_like "sort string loader" do
      def load_sort_string(sort_string, mode: :hash)
        definition.load!(sort_string, mode: mode)
      end
    end

    context "with non-whitelisted sort field" do
      before do
        definition.define do
          field "users.first_name", nulls: :last
          field "users.email"
        end
      end

      it "raises an error" do
        sort_fields1 = "-users.last_name:nulls_last,+users.first_name,-users.email"
        sort_fields2 = "users.last_name"
        sort_fields3 = "+users.first_name:nulls_first, +users.email"
        sort_fields4 = "users.email"
        sort_fields5 = "users.first_name"

        expect { definition.load!(sort_fields1) }.to raise_error(SortParam::UnsupportedSortField)
        expect { definition.load!(sort_fields2) }.to raise_error(SortParam::UnsupportedSortField)
        expect { definition.load!(sort_fields3) }.not_to raise_error
        expect { definition.load!(sort_fields4) }.not_to raise_error
        expect { definition.load!(sort_fields5) }.not_to raise_error
      end
    end
  end

  describe "#load" do
    it_behaves_like "sort string loader" do
      def load_sort_string(sort_string, mode: :hash)
        definition.load(sort_string, mode: mode)
      end
    end

    context "with non-whitelisted sort field" do
      before do
        definition.define do
          field "users.first_name", nulls: :last
          field "users.email"
        end
      end

      it "ignores the non-whitelisted fields" do
        sort_fields1 = "-users.last_name:nulls_last,+users.first_name,-users.email"
        sort_fields2 = "users.last_name"
        sort_fields3 = "+users.first_name:nulls_first, +users.email"
        sort_fields4 = "users.email"
        sort_fields5 = "users.first_name"

        expect { definition.load(sort_fields1) }.not_to raise_error
        expect { definition.load(sort_fields2) }.not_to raise_error
        expect { definition.load(sort_fields3) }.not_to raise_error
        expect { definition.load(sort_fields4) }.not_to raise_error
        expect { definition.load(sort_fields5) }.not_to raise_error

        expect(definition.load(sort_fields1).keys).to eql(%w[users.first_name users.email])
        expect(definition.load(sort_fields2)).to be_nil
      end
    end
  end
end
