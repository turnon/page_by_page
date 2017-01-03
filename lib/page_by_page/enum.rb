class PageByPage
  class Enum

    def initialize from: 1, step: 1
      @enum = (from..Float::INFINITY).step(step).lazy.map(&:to_i).to_enum
    end

    def next
      @enum.next
    end

  end
end
