require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Hooks::Lead do
  describe '.switch_source(lead)' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.message = ''
      lead.attachments = []
      lead.description = ''
      lead.product = product

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = ''

      source
    end

    let(:product) do
      product = OpenStruct.new
      product.name = ''

      product
    end

    let(:switch_source) { described_class.switch_source(lead) }

    context 'when lead come from Facebook' do
      before { source.name = 'Facebook' }

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
      before { source.name = 'myHonda' }

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

      context 'when lead come with Serviços e Peças' do
        before { lead.description = 'Concessionária: SAMPA.; Código: 1617974; Tipo: CS - Serviços e Peças' }

        it 'returns Source - Peças' do
          expect(switch_source).to eq('myHonda - Peças')
        end

        context 'when lead product name is Agendamento de serviços' do
          before { lead.product.name = 'Agendamento de serviços' }

          it 'returns Source - Peças' do
            expect(switch_source).to eq('myHonda - Agendamento')
          end
        end
      end
    end
  end
end
