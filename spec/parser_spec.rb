require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do

  context 'when email is from website form' do
    let(:email){ 
      email = OpenStruct.new
      email.to = [email: 'jivochat@lojateste.f1sales.org']
      email.subject = '[Jivochat Lead] Marcio Klepacz'
      email.body = "\nnome: Marcio Klepacz email: marcioklepacz@citofoobar.com telefone: (11)\n98158-7311\nproduto: Civic 2010"

      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website form as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all.first[:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Marcio Klepacz')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('marcioklepacz@citofoobar.com')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11981587311')
    end

    it 'contains product' do
      expect(parsed_email[:product]).to eq('Civic 2010')
    end
  end


end
