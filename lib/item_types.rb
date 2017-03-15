module ItemTypes
  # Defines a normal (default) item
  class Normal
    def self.perform(item)
      item.sell_in = adjust_sell_in(item)
      item.quality = limit_quality(adjust_quality(item))
    end

    private

    def self.adjust_sell_in(item)
      item.sell_in - 1
    end

    def self.adjust_quality(item)
      item.quality - (item.sell_in < 0 ? 2 : 1)
    end

    def self.limit_quality(quality)
      return 0 if quality < 0
      return 50 if quality > 50
      quality
    end
  end

  # Brie increases quality with age
  class Brie < Normal
    def self.adjust_quality(item)
      item.quality + 1
    end
  end

  # BackstagePasses increase more rapidly as their sell_in date approaches, and
  # have no value when expiration has passed.
  class BackstagePass < Normal
    def self.adjust_quality(item)
      # Passes have no value after expiration
      return 0 if item.sell_in < 0

      # Passes increase in quality more quickly when the date approaches
      if item.sell_in < 5
        item.quality + 3
      elsif item.sell_in >= 5 && item.sell_in < 10
        item.quality + 2
      else
        item.quality + 1
      end
    end
  end

  # Sulfuras is a magical item of great worth and can always be sold
  class Sulfuras < Normal
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
end
