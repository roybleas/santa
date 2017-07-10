require 'rails_helper'

RSpec.describe "import participants file" do
  context "reads a csv file" do
    it "fails to open non existent file" do
      import = ImportParticipants.new("InvalidFilePath")
      expect(import.extract?).to be_falsey
      expect(import.error_message).to include('No such file or directory')
    end

    it "fails to open invalid file type" do
      invalid_file_type_path = './spec/files/image.png'
      import = ImportParticipants.new(invalid_file_type_path)
      expect(import.extract?).to be_falsey
      expect(import.error_message).to include('invalid byte sequence')
    end

    it "fails to read malformed file" do
      invalid_file_type_path = './spec/files/malformed.csv'
      import = ImportParticipants.new(invalid_file_type_path)
      expect(import.extract?).to be_falsey
      expect(import.error_message).to include('Illegal quoting')
    end

    it "opens a valid file" do
      csv_filename = './spec/files/simple_names.csv'
      import = ImportParticipants.new(csv_filename)
      expect(import.extract?).to be_truthy
      expect(import.error_message).to be_nil
    end
  end
  context "extract" do
    context "participant with invalid" do
      it "value" do
        invalid_file_type_path = "./spec/files/missingvalue.csv"
        import = ImportParticipants.new(invalid_file_type_path)
        expect(import.extract?).to be_falsey
        expect(import.error_message).to include('Invalid value in Row: ["missing name"]')
      end

      it "information" do
        invalid_file_type_path = "./spec/files/invalidvalue.csv"
        import = ImportParticipants.new(invalid_file_type_path)
        expect(import.extract?).to be_falsey
        expect(import.error_message).to include('not an email')
      end

      it "as duplicate name" do
        invalid_file_type_path = "./spec/files/duplicates.csv"
        import = ImportParticipants.new(invalid_file_type_path)
        expect(import.extract?).to be_falsey
        expect(import.error_message).to include('appears more than once')
      end
    end

    context "valid participant" do
      let(:import) { ImportParticipants.new('./spec/files/simple_names.csv')}

      it "to add to participants list" do
        expect(import.extract?).to be_truthy
        expect(import.error_message).to be_nil
        expect(import.participants[0]).to be_a(Participant)
      end

      it "striping blanks from participants details" do
        expect(import.extract?).to be_truthy
        expect(import.participants[0].name).to eq "Fred Flintstone"
        expect(import.participants[0].person.email).to eq "fred@rock.com"
      end

      it "uses existing person if already exists" do
        person = FactoryGirl.create(:person, name: "Fred Flintstone", email: "fred@rock.com")
        expect(import.extract?).to be_truthy
        expect(import.participants[0].person).to eq person
      end

      it "updates email if person already exists" do
        person = FactoryGirl.create(:person, name: "Fred Flintstone", email: "someother@rock.com")
        expect(import.extract?).to be_truthy
        expect(import.participants[0].person.email).to eq "fred@rock.com"
      end

      it "adds all extracted people to participants list" do
        expect(import.extract?).to be_truthy
        expect(import.participants.size).to eq 3
      end
    end
    context "partners" do
      let(:import) { ImportParticipants.new('./spec/files/partners.csv')}

      it "to add to participants list" do
        import.extract?
        expect(import.error_message).to be_nil
        expect(import.participants[0].has_partner?).to be_truthy
        expect(import.participants[1].has_partner?).to be_truthy
        expect(import.participants[2].has_partner?).to be_falsey
      end

      it "to have correct partner name" do
        import.extract?
        expect(import.error_message).to be_nil
        expect(import.participants[0].partner).to eq import.participants[1].name
        expect(import.participants[1].partner).to eq import.participants[0].name
      end
    end
  end
end
