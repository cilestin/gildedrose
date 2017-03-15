class NormalItem
  def self.perform(item)
    item.sell_in = adjust_sell_in(item)
    item.quality = limit_quality(adjust_quality(item))
  end

  private
  def self.adjust_sell_in(item)
    item.sell_in - 1
  end

  def self.adjust_quality(item)
    item.quality - ((item.sell_in < 0) ? 2 : 1)
  end

  def self.limit_quality(quality)
    return 0 if quality < 0
    return 50 if quality > 50
    quality
  end
end

class BrieItem < NormalItem
  private
  def self.adjust_quality(item)
    item.quality + 1
  end
end

class BackstagePassItem < NormalItem
  private
  def self.adjust_quality(item)

    # Passes have no value after expiration
    return 0 if item.sell_in < 0

    # Passes increase in quality more quickly when the date approaches
    if item.sell_in < 5
      item.quality + 3
    elsif item.sell_in >= 5  && item.sell_in < 10
      item.quality + 2
    else
      item.quality + 1
    end
  end
end

class SulfurasItem < NormalItem
  private

  # Can always be sold
  def self.adjust_sell_in(item)
    item.sell_in
  end

  # Never loses quality
  def self.adjust_quality(item)
    item.quality
  end

  # Does not follow normal quality limits
  def self.limit_quality(quality)
    quality
  end
end

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      update_item_stats(item)
    end
  end

  private

  def update_item_stats(item)
    case item.name
    when 'Aged Brie'
      return BrieItem.perform(item)
    when 'Backstage Pass'
      return BackstagePassItem.perform(item)
    when 'Sulfuras, Hand of Ragnaros'
      return SulfurasItem.perform(item)
    else
      return NormalItem.perform(item)
    end
  end
end

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
