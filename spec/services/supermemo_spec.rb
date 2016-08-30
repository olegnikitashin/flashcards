require 'rails_helper'

describe Supermemo do
  describe '#self.quality_calc' do
    context 'calculate quality from review_seconds' do
      it '0-15 sec equal quality of 5' do
        expect(Supermemo.quality_calc(2)).to eq 5
      end
      it '16-30 sec equal quality of 4' do
        expect(Supermemo.quality_calc(17)).to eq 4
      end
      it '31-60 sec equal quality of 3' do
        expect(Supermemo.quality_calc(34)).to eq 3
      end
      it '> 60 sec equal quality of 0' do
        expect(Supermemo.quality_calc(100)).to eq 0
      end
    end
  end

  describe '#ef_calc' do
    it 'calculate efactor_new from old efactor and quality' do
      expect(Supermemo.ef_calc(2.5, 5)).to eq 2.6
    end
    it "can't be less than 1.3" do
      expect(Supermemo.ef_calc(0.1, 1)).to eq 1.3
    end
  end

  describe '#repetition_calc' do
    it 'calculates the repetition number according to quality' do
      expect(Supermemo.repetition_calc(4, 0)).to eq 1
    end
    it 'is quality < 3 than repetitions 0' do
      expect(Supermemo.repetition_calc(1, 5)).to eq 0
    end
  end

  describe '#interval_calc' do
    it 'calculates the interval till the next review date' do
      expect(Supermemo.interval_calc(0, 2.5)).to eq 0
    end
    it 'if repetitions > 2, then calculates the interval till the next review date via formula' do
      expect(Supermemo.interval_calc(3, 2.5)).to eq 5
    end
  end
end
