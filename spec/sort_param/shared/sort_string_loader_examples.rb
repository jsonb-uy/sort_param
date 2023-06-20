shared_examples "sort string loader" do
  context "with blank sort fields" do
    context "with :default mode" do
      it "returns nil" do
        expect(load_sort_string(nil)).to be_nil
        expect(load_sort_string(" ")).to be_nil
      end
    end

    context "with :pg mode" do
      it "returns nil" do
        expect(load_sort_string(nil, mode: :pg)).to be_nil
        expect(load_sort_string(" ", mode: :pg)).to be_nil
      end
    end

    context "with :mysql mode" do
      it "returns nil" do
        expect(load_sort_string(nil, mode: :mysql)).to be_nil
        expect(load_sort_string(" ", mode: :mysql)).to be_nil
      end
    end
  end

  context "with valid sort fields" do
    before do
      definition.define do
        field "first_name", nulls: :last, rename: "users.first_name"
        field "users.last_name", nulls: "first"
        field "users.email"
      end
    end

    context "with :default mode" do
      it "returns the sort fields hash with the sort direction and default options" do
        sort_fields1 = "-users.last_name:nulls_last,first_name,-users.email"
        sort_fields2 = "users.last_name:nulls_first, +first_name:nulls_first, +users.email"
        sort_fields3 = "users.last_name:nulls_last"

        expect(load_sort_string(sort_fields1)).to eql(
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

        expect(load_sort_string(sort_fields2)).to eql(
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

        expect(load_sort_string(sort_fields3)).to eql(
          {
            "users.last_name" => {
              direction: :asc,
              nulls: :last
            }
          }
        )
      end
    end

    context "with :pg mode" do
      it "returns correct `ORDER BY` SQL" do
        sort_fields1 = "-users.last_name:nulls_last,+first_name,-users.email"
        sort_fields2 = "+users.last_name:nulls_first, +first_name:nulls_first, +users.email"
        sort_fields3 = "users.last_name:nulls_last"

        expect(load_sort_string(sort_fields1, mode: :pg)).to eql(
          "users.last_name desc nulls last, users.first_name asc nulls last, users.email desc"
        )

        expect(load_sort_string(sort_fields2, mode: :pg)).to eql(
          "users.last_name asc nulls first, users.first_name asc nulls first, users.email asc"
        )

        expect(load_sort_string(sort_fields3, mode: :pg)).to eql("users.last_name asc nulls last")
      end
    end

    context "with :mysql mode" do
      it "returns correct `ORDER BY` SQL" do
        sort_fields1 = "-users.last_name:nulls_last,+first_name,-users.email"
        sort_fields2 = "+users.last_name:nulls_first, +first_name:nulls_first, +users.email"
        sort_fields3 = "users.last_name:nulls_last"

        expect(load_sort_string(sort_fields1, mode: :mysql)).to eql(
          "users.last_name is null, users.last_name desc, users.first_name is null, users.first_name asc, users.email desc"
        )

        expect(load_sort_string(sort_fields2, mode: :mysql)).to eql(
          "users.last_name is not null, users.last_name asc, users.first_name is not null, users.first_name asc, users.email asc"
        )

        expect(load_sort_string(sort_fields3, mode: :mysql)).to eql("users.last_name is null, users.last_name asc")
      end
    end
  end
end
