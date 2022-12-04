describe V1::UrlShortensController, type: :request do
  shared_examples :test_input_invalid do
    context 'when url invalid' do
      context 'with blank' do
        let(:url) { '' }

        it 'should return error' do
          expect(response_body).to eq(error_res)
        end
      end

      context 'with format' do
        let(:url) { 'a' }

        it 'should return error' do
          expect(response_body).to eq(error_res)
        end
      end

      context 'with too long' do
        let(:url) { Faker::Internet.url + 'a' * 256 }

        it 'should return error' do
          expect(response_body).to eq(error_res)
        end
      end
    end
  end

  let(:params) { { url: url } }
  let(:success_res) { { code: 200, message: 'OK', data: { url: res_url } } }
  let(:pre_data) { nil }

  before do
    pre_data
    post path, params: params
  end

  describe 'POST #encode' do
    let(:path) { encode_v1_url_shorten_url }
    let(:error_res) { { code: 500, message: 'NG', data: { message: message } } }
    let(:message) { 'Can\'t create short url, please try agian !!!' }

    include_examples :test_input_invalid

    context 'when url valid' do
      let(:url) { Faker::Internet.url }
      let(:link) { Link.last }
      let(:res_url) { link.full_short_url }

      it 'should create a link' do
        expect(Link.count).to eq(1)
      end

      it 'should return success' do
        expect(response_body).to eq(success_res)
      end

      context 'with duplicate url' do
        let(:link) { create(:link) }
        let(:pre_data) { link }
        let(:url) { link.url }

        it 'shouldn\'t create link' do
          expect(Link.by_url(url).count).to eq(1)
        end

        it 'should return success' do
          expect(response_body).to eq(success_res)
        end
      end

      context 'with gen dup key' do
        let(:link) { create(:link) }
        let(:pre_data) do
          link
          allow_any_instance_of(KeyGeneratorService).to receive(:gen_key) { link.short_url }
        end
        let(:message) { 'Can\'t create short url, please try agian !!!' }

        it 'should system not stuck and return error' do
          expect(response_body).to eq(error_res)
        end
      end
    end
  end

  describe 'POST #decode' do
    let(:path) { decode_v1_url_shorten_url }
    let(:error_res) { { code: 400, message: 'NG', data: { message: message } } }
    let(:message) { 'Not Found, please try agian !!!' }

    include_examples :test_input_invalid

    context 'when url valid' do
      let(:res_url) { link.url }

      context 'with not exists' do
        let(:url) { Faker::Internet.url }

        it 'should return success' do
          expect(response_body).to eq(error_res)
        end
      end

      context 'with exists' do
        let(:link) { create(:link) }
        let(:pre_data) { link }
        let(:url) { link.full_short_url }

        it 'should return success' do
          expect(response_body).to eq(success_res)
        end
      end
    end
  end
end
