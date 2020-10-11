module PageByPage
  class Enum

    def initialize from: 1, step: 1, limit: nil, enumerator: nil
      @enum = enumerator || (from..limit).step(step).lazy.map(&:to_i).to_enum
    end

    def next
      @enum.next rescue nil
    end

  end
end
