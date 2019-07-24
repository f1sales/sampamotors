require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do

  context 'when is a differnt email format' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@lojateste.f1sales.org']
      email.subject = 'Solicitação de cotação por artix1@gmail.com em EMPRESAS'
      email.body = "*Site*: https://sampamotors.com.br/\n*Origem*: EMPRESAS\n*Nome*: Rogerio\n*E-mail*: artix1@gmail.com\n*Telefone*: (11) 99203-8916\n*Mensagem*:\nTenho interesse em comprar como Pessoa Jurídica CNPJ 30.364.741/0001-12.\nWR-V EXL 0Km"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website form as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[1][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Rogerio')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('artix1@gmail.com')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq('EMPRESAS')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11992038916')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq("Tenho interesse em comprar como Pessoa Jurídica CNPJ 30.364.741/0001-12. WR-V EXL 0Km")
    end
    
  end

  context 'when email is from website form' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@lojateste.f1sales.org']
      email.subject = 'Campanha - CITY e CIVIC'
      email.body = "Contato via site\n*Nome:* Regina Rodrigues da Cruz\n*E-mail:* jhonatancruz@uol.com.br\n*Telefone:* (11) 9 6216-0607\n*Loja:* Ponte Piqueri\n*Mensagem:* Possível cliente PCD\n-----------------------------------------------------------------------\n*Link da Land:* promocao.sampamotors.com.br/julho/\n*UTM Source:* facebook\n*UTM Medium:* link\n*Mensagem de e-mail confidencial.*"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website form as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[1][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Regina Rodrigues da Cruz')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('jhonatancruz@uol.com.br')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11962160607')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq("Possível cliente PCD - Unidade: Ponte Piqueri")
    end

  end

  context 'when email is from jivochat' do
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
