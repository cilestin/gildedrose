require File.join(File.dirname(__FILE__), '../gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    let(:quality) { 25 }
    let(:sell_in) { 5 }
    let(:items) { [Item.new('Regular Item', sell_in, quality)] }

    before(:each) do
      @gilded_rose = GildedRose.new(items)
    end

    subject { @gilded_rose.update_quality }

    it 'does not change the name' do
      expect(subject.first.name).to eq 'Regular Item'
    end

    context 'normal items' do
      it 'degrades normally before sell expiration' do
        old_quality = quality
        new_quality = quality - 1
        expect { subject }.to change { items.first.quality }.from(old_quality).to(new_quality)
      end

      it 'decreases time to sell with every update' do
        old_sell_in = sell_in
        new_sell_in = sell_in - 1
        expect { subject }.to change { items.first.sell_in }.from(old_sell_in).to(new_sell_in)
      end

      it 'doubles quality degrading after sell by expiration' do
        (1..sell_in).each { @gilded_rose.update_quality }
        old_quality = quality - sell_in
        new_quality = quality - sell_in - 2
        expect { subject }.to change { items.first.quality }.from(old_quality).to(new_quality)
      end

      it 'cannot have negative quality' do
        (1..quality).each { @gilded_rose.update_quality }
        expect(subject.first.quality).to eq 0
      end

      it 'cannot have a quality higher than 50' do
        results = GildedRose.new([Item.new('Expensive!', 5, 55)]).update_quality
        expect(results.first.quality).to eq 50
      end
    end

    context 'aged brie' do
      let(:items) { [Item.new('Aged Brie', sell_in, quality)] }

      it 'increases in quality the older it gets' do
        new_quality = quality + 1
        expect(subject.first.quality).to eq new_quality
      end
    end

    context 'backstage pass' do
      let(:sell_in) { 11 }
      let(:items) { [Item.new('Backstage Pass', sell_in, quality)] }

      it 'increases in quality the older it gets' do
        new_quality = quality + 1
        expect(subject.first.quality).to eq new_quality
      end

      it 'quality adjustment doubles when passes have 10 days left to sell' do
        @gilded_rose.update_quality
        old_quality = items.first.quality
        new_quality = old_quality + 2
        expect { subject }.to change { items.first.quality }.from(old_quality).to(new_quality)
      end

      it 'quality adjustment triples when passes have 5 days left to sell' do
        items = [Item.new('Backstage Pass', 4, quality)]
        old_quality = items.first.quality
        new_quality = old_quality + 3
        expect { GildedRose.new(items).update_quality }.to change { items.first.quality }
          .from(old_quality)
          .to(new_quality)
      end
    end

    context 'sulfuras' do
      let(:quality) { 80 }
      let(:items) { [Item.new('Sulfuras, Hand of Ragnaros', sell_in, quality)] }

      it 'does not need to be sold' do
        expect(subject.first.sell_in).to eq sell_in
      end

      it 'does not change quality' do
        expect(subject.first.quality).to eq quality
      end
    end

    context 'conjured' do
      let(:items) { [Item.new('Conjured', sell_in, quality)] }

      it 'degrades twice as quickly as normal items' do
        old_quality = quality
        new_quality = quality - 2
        expect { subject }.to change { items.first.quality }.from(old_quality).to(new_quality)
      end
    end
  end
end
