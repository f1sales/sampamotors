require 'ostruct'

RSpec.describe F1SalesCustom::Hooks::Lead do
  describe '.switch_source(lead)' do
    context 'when lead come from Facebook' do
      let(:lead) do
        lead = OpenStruct.new
        lead.source = source
        lead.message = ''

        lead
      end

      let(:source) do
        source = OpenStruct.new
        source.name = 'Facebook'

        source
      end

      let(:switch_source) { described_class.switch_source(lead) }

      it 'returns Facebook' do
        expect(switch_source).to eq('Facebook')
      end

      context 'when lead is seminovo' do
        before { lead.message = 'Seminovos' }

        it 'returns Facebook - Seminovo' do
          expect(switch_source).to eq('Facebook - Seminovos')
        end
      end
    end

    context 'when lead come from myHonda' do
      let(:lead) do
        lead = OpenStruct.new
        lead.source = source
        lead.attachments = []

        lead
      end

      let(:source) do
        source = OpenStruct.new
        source.name = 'myHonda'

        source
      end

      let(:switch_source) { described_class.switch_source(lead) }

      it 'returns source myHonda' do
        expect(switch_source).to eq('myHonda')
      end

      context 'when lead come by email' do
        before { lead.attachments = ['https://myhonda.force.com/leads/s/lead/00Q4M'] }

        it 'return source nil' do
          expect(switch_source).to be_nil
        end
      end
    end
  end
end
