describe Payonline::Config do
  describe '.new' do
    it 'creates methods for valid options' do
      keys = %i(merchant_id private_security_key return_url fail_url)
      options = create_hash_with_123_values(keys)

      instance = Payonline::Config.new(options)

      keys.each do |key|
        expect(instance.send(key)).to eq 123
      end
    end

    it 'doesnt create methods for invalid options' do
      keys = %i(not_valid_key also_not_valid_key)
      options = create_hash_with_123_values(keys)

      instance = Payonline::Config.new(options)

      keys.each do |key|
        expect{ instance.send(key) }.to raise_exception NoMethodError
      end
    end
  end
end
