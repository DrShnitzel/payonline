require_relative '../lib/payonline'

def create_hash_with_123_values(keys)
  params = {}
  keys.each { |k| params[k] = 123 }
  params
end

def hash_included?(included_hash:, hash:)
  (included_hash.to_a - hash.to_a).empty?
end
