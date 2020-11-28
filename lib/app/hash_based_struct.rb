# Hash の内容に基づく Struct オブジェクトを作る
module HashBasedStruct
  class << self
    # @param [Hash]
    # @return [Struct]
    def instance(attributes)
      to_struct attributes
    end

    private

    # @param [Hash]
    # @return [Struct]
    def to_struct(attributes)
      keys = []
      values = []

      return attributes.map { |i| to_struct(i) } if attributes.is_a?(Array)

      return attributes unless attributes.is_a?(Hash)

      attributes.each do |k, v|
        keys << k.to_sym
        values << ((v.is_a?(Hash) && v.present?) || v.is_a?(Array) ? to_struct(v) : v)
      end

      Struct.new(*keys).new(*values)
    end
  end
end
