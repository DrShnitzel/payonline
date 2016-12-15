module Payonline
  describe PaymentGateway do
    describe '.new' do
      it 'stores permited params' do
        params = permited_params

        instance = PaymentGateway.new(params)

        instance_params = instance.instance_variable_get(:@params)
        PaymentGateway::PERMITTED_PARAMS.each do |param|
          expect(instance_params.key?(param.to_sym)).to be true
        end
      end

      it 'cuts off not permited params' do
        params = permited_params
        params[:not_permited_param] = 123

        instance = PaymentGateway.new(params)

        instance_params = instance.instance_variable_get(:@params)
        expect(instance_params.key?(:not_permited_param)).to be false
      end

      it 'adds default_params to params' do
        params = permited_params

        instance = PaymentGateway.new(params)

        instance_params = instance.instance_variable_get(:@params)
        instance.send(:default_params).each do |key, _|
          expect(instance_params.key?(key)).to be true
        end
      end

      it 'doesnt override passed params with default params' do
        params = permited_params
        params[:return_url] = 'https://new.path'

        instance = PaymentGateway.new(params)

        instance_params = instance.instance_variable_get(:@params)
        expect(instance_params[:return_url]).to eq 'https://new.path'
      end
    end

    describe '#payment_url' do
      before(:each) do
        allow_any_instance_of(Signature).to receive(:sign)
          .and_return(any_param: :value)
      end

      it 'returns correct url' do
        params = permited_params
        instance = PaymentGateway.new(params)

        expected_url = 'https://secure.payonlinesystem.com' \
                       '/ru/payment/?any_param=value'
        expect(instance.payment_url).to eq expected_url
      end

      it 'returns correct url for other payment types' do
        params = permited_params
        instance = PaymentGateway.new(params)

        expected_url = 'https://secure.payonlinesystem.com' \
                       '/ru/payment/select/qiwi/?any_param=value'
        expect(instance.payment_url(type: :qiwi)).to eq expected_url
      end

      it 'return correct url for other langueges' do
        params = permited_params
        instance = PaymentGateway.new(params)

        expected_url = 'https://secure.payonlinesystem.com' \
                       '/en/payment/?any_param=value'
        expect(instance.payment_url(language: :en)).to eq expected_url
      end
    end

    def permited_params
      create_hash_with_123_values(
        PaymentGateway::PERMITTED_PARAMS.map(&:to_sym) - %i(return_url fail_url)
      )
    end
  end
end
