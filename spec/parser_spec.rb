require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do

  context 'when email is from website form' do
    let(:email){ 
      email = OpenStruct.new
      email.to = [email: 'jivochat@lojateste.f1sales.org']
      email.subject = '[Jivochat Lead] Marcio Klepacz'
      email.body = "nome: Marcio Teste\ntelefone: 11981587311\nemail: marcio@teste.com.br\nproduto: Honda Fit\nmensagem: Tem interesse no carro"

      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website form as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all.first[:name])
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Tem interesse no carro')
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Marcio Teste')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('marcio@teste.com.br')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11981587311')
    end

    it 'contains product' do
      expect(parsed_email[:product]).to eq('Honda Fit')
    end
  end


end
