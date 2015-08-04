class Hash
  def transform_keys!
    return enum_for(:transform_keys!) unless block_given?
    keys.each do |key|
      self[yield(key)] = delete(key)
    end
    self
  end
  def symbolize_keys!
    transform_keys!{ |key| key.to_sym rescue key }
  end
end