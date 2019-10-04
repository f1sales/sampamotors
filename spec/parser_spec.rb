require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do

  context 'when is about after sell' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@lojateste.f1sales.org']
      email.subject = 'Campanha - PÓS VENDAS AGOSTO'
      email.body = "Contato via site\n*Nome:* Nagila sales\n*E-mail:* nagilasales14@gmail.com\n*Telefone:* (11) 9 7747-3109\n*Loja:* Ponte Piqueri\n*Mensagem:* Olá, quero fazer um orçamento\n-----------------------------------------------------------------------\n*Link da Land:* promocao.sampamotors.com.br/posvendasagosto/\n*UTM Source:* google\n*UTM Medium:* search\n*UTM Campaign:* posvenda\n*Mensagem de e-mail confidencial.*"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website form as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[4][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Nagila sales') 
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('nagilasales14@gmail.com')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11977473109')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Olá, quero fazer um orçamento - Unidade: Ponte Piqueri')
    end
  end

  context 'when is somenone ask about a quote' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@lojateste.f1sales.org']
      email.subject = 'Solicitação de cotação por Gabi.rigolino@gmail.com em EMPRESAS'
      email.body = "*Site*: https://sampamotors.com.br/\nOrigem: EMPRESAS\n*Nome*: Gabriela\n*E-mail*: Gabi.rigolino@gmail.com\n*Telefone*: (11) 98290-1049\n*Mensagem*:\nOlá, gostaria de saber as condições para CNPJ por favor. Modelo: Fit ou\nCivic ou wrv"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website form as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[1][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Gabriela')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('Gabi.rigolino@gmail.com')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11982901049')
    end

    it 'contains a description' do
      expect(parsed_email[:description]).to eq('EMPRESAS')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Olá, gostaria de saber as condições para CNPJ por favor. Modelo: Fit ou Civic ou wrv')
    end

  end

  context 'when is about acessories' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@lojateste.f1sales.org']
      email.subject = 'Solicitação de cotação por artix1@gmail.com em /acessorios-e-pecas'
      email.body = "*Site*: https://sampamotors.com.br/\n*Origem*: /acessorios-e-pecas\n*Nome*: Rogerio\n*E-mail*: artix1@gmail.com\n*Telefone*: (11) 99203-8916\n*Mensagem*:\nTenho interesse em comprar como Pessoa Jurídica CNPJ 30.364.741/0001-12.\nWR-V EXL 0Km"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website form as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[2][:name])
    end

  end

  context 'when is an email to sell a car' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@lojateste.f1sales.org']
      email.subject = 'Solicitação de venda de carro por iendis@yahoo.com.br'
      email.body = "Site: https://sampamotors.com.br/Nome: Teste IgnorarE-mail: email_teste_ignorar@gmail.comTelefone: (11) 98158-7311Portas: 4Marca/Modelo: Marca TesteQuilometragem: 120.000Ano: 2006Cambio: automatico"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website form as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[2][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Teste Ignorar')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('email_teste_ignorar@gmail.com')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11981587311')
    end

    it 'contains product' do
      expect(parsed_email[:product]).to eq('Marca Teste')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq(' solicitação de venda')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Portas: 4 Quilometragem: 120.000 Ano: 2006 Cambio: automatico')
    end
  end

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

  context 'when email is from jivochat and is used' do
    let(:email){ 
      email = OpenStruct.new
      email.to = [email: 'jivochat@lojateste.f1sales.org']
      email.subject = '[Jivochat Lead] Marcio Klepacz'
      email.body = "nome: Marcio Teste\ntelefone: 11981587311\ntipo: seminovos\nemail: marcio@teste.com.br\nproduto: Honda Fit\nmensagem: Tem interesse no carro"

      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website form as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[3][:name])
    end
    
  end

  context 'when is email is from Honda Social' do
    let(:email){ 
      email = OpenStruct.new
      email.to = [email: 'hondasocial@lojateste.f1sales.org']
      email.subject = '[Honda Social Lead] Marcio Klepacz'
      email.body = "nome: Marcio Teste\ntelefone: 11981587311\nemail: marcio@teste.com.br\nproduto: Honda Fit\nmensagem: Tem interesse no carro"

      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains honda social form as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[5][:name])
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
