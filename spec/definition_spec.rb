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

  describe "#load_param!" do
    context "with blank sort fields" do
      context "with :default mode" do
        it "returns nil" do
          expect(definition.load_param!(nil)).to be_nil
          expect(definition.load_param!(" ")).to be_nil
        end
      end

      context "with :pg mode" do
        it "returns nil" do
          expect(definition.load_param!(nil, mode: :pg)).to be_nil
          expect(definition.load_param!(" ", mode: :pg)).to be_nil
        end
      end

      context "with :mysql mode" do
        it "returns nil" do
          expect(definition.load_param!(nil, mode: :mysql)).to be_nil
          expect(definition.load_param!(" ", mode: :mysql)).to be_nil
        end
      end
    end

    context "with valid sort fields" do
      before do
        definition.define do
          field "users.first_name", nulls: :last
          field "users.last_name", nulls: "first"
          field "users.email"
        end
      end

      context "with :default mode" do
        it "returns the sort fields hash with the sort direction and default options" do
          sort_fields1 = "-users.last_name:nulls_last,+users.first_name,-users.email"
          sort_fields2 = "+users.last_name:nulls_first, +users.first_name:nulls_first, +users.email"

          expect(definition.load_param!(sort_fields1)).to eql(
            {
              "users.last_name" => {
                direction: :desc,
                nulls: :last
              },
              "users.first_name" => {
                direction: :asc,
                nulls: :last
              },
              "users.email" => {
                direction: :desc
              }
            }
          )

          expect(definition.load_param!(sort_fields2)).to eql(
            {
              "users.last_name" => {
                direction: :asc,
                nulls: :first
              },
              "users.first_name" => {
                direction: :asc,
                nulls: :first
              },
              "users.email" => {
                direction: :asc
              }
            }
          )
        end
      end

      context "with :pg mode" do
        it "returns correct `ORDER BY` SQL" do
          sort_fields1 = "-users.last_name:nulls_last,+users.first_name,-users.email"
          sort_fields2 = "+users.last_name:nulls_first, +users.first_name:nulls_first, +users.email"

          expect(definition.load_param!(sort_fields1, mode: :pg)).to eql(
            "users.last_name desc nulls last, users.first_name asc nulls last, users.email desc"
          )

          expect(definition.load_param!(sort_fields2, mode: :pg)).to eql(
            "users.last_name asc nulls first, users.first_name asc nulls first, users.email asc"
          )
        end
      end

      xcontext "with :mysql mode" do
        it "returns correct `ORDER BY` SQL" do
          sort_fields1 = "-users.last_name:nulls_last,+users.first_name,-users.email"
          sort_fields2 = "+users.last_name:nulls_first, +users.first_name:nulls_first, +users.email"

          expect(definition.load_param!(sort_fields1, mode: :mysql)).to eql(
            "users.last_name is null, users.last_name desc, users.first_name is null, users.first_name asc, , users.email desc"
          )

          expect(definition.load_param!(sort_fields2, mode: :mysql)).to eql(
            "users.last_name asc nulls first, users.first_name asc nulls first, users.email asc"
          )
        end
      end
    end
  end
end
