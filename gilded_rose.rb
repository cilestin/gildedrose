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
    case item.name
    when 'Aged Brie'
      return ItemTypes::Brie.perform(item)
    when 'Backstage Pass'
      return ItemTypes::BackstagePass.perform(item)
    when 'Sulfuras, Hand of Ragnaros'
      return ItemTypes::Sulfuras.perform(item)
    else
      return ItemTypes::Normal.perform(item)
    end
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
