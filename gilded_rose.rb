# Defines the GuildedRose class
class GildedRose
  require './lib/item_types'

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      update_item_stats(item)
    end
  end

  private

  def update_item_stats(item)
    item_type_map(item.name).perform(item)
  end

  def item_type_map(item_name)
    @item_type_map ||= {
      'Aged Brie' => ItemTypes::Brie,
      'Backstage Pass' => ItemTypes::BackstagePass,
      'Sulfuras, Hand of Ragnaros' => ItemTypes::Sulfuras,
      'Conjured' => ItemTypes::Conjured
    }
    @item_type_map.fetch(item_name, ItemTypes::Normal)
  end
end

# rubocop:disable all
class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
# rubocop:enable all
