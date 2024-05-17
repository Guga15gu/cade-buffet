# README

## Cadê Buffet?
Aplicação para o gerenciamento de Buffets.

Há 3 tipos de usuários:
- Usuários Donos de Buffet
- Usuários Clientes
- Usuários não logados como nenhum dos outros dois

- Um Dono de Buffet após criar sua conta e logar, precisa cadastrar seu buffet, ele só pode ter um buffet.
  - Um buffet pode ter vários tipos de buffets (eventos).
  - Um tipo de buffet só pode ter um preço cadastrado.
  - O dono de buffet também pode aprovar um pedido feito por um cliente.

- Um Cliente pode visualizar os buffets e tipos de buffets criados pelos donos de buffet e fazer um pedido.
  - Após ser feito o pedido, o cliente pode confirmar o pedido aprovado pelo dono do buffet.
  - 
### API
- Uma API está disponível: É possível listar buffets e tipos de buffets, visualizar detalhes de um buffet e consultar disponibilidade de um evento de um tipo de buffet.
- Os endpoints são os seguintes:
#### get "/api/v1/buffets/#{buffet.id}"
- Retorna um buffet pelo id.
- Exemplo de resposta:
```json
{
    "id":1,
    "business_name":"Buffet Delícias",
    "contact_phone":"(11) 1234-5678",
    "address":"Rua dos Sabores, 123",
    "district":"Centro",
    "state":"SP",
    "city":"São Paulo",
    "postal_code":"12345-678",
    "description":"Buffet especializado em eventos corporativos",
    "payment_methods":"Cartão de crédito, Dinheiro"
}
```
#### get "/api/v1/buffets/"
- Retorna uma lista dos buffets.
- Exemplo de resposta:
```json
[
    {
        "id":1,
        "business_name":"Buffet Delícias",
        "contact_phone":"(11) 1234-5678",
        "address":"Rua dos Sabores, 123",
        "district":"Centro",
        "state":"SP",
        "city":"São Paulo",
        "postal_code":"12345-678",
        "description":"Buffet especializado em eventos corporativos",
        "payment_methods":"Cartão de crédito, Dinheiro"
        }
]
```
#### get "/api/v1/buffets?search=#{search}"
- Busca por um buffet pelo nome e retorna uma lista de buffets em ordem alfabética por nome.
- Exemplo de resposta:
```json
[
    {
        "id":1,
        "business_name":"Buffet Delícias",
        "contact_phone":"(11) 1234-5678",
        "address":"Rua dos Sabores, 123",
        "district":"Centro",
        "state":"SP",
        "city":"São Paulo",
        "postal_code":"12345-678",
        "description":"Buffet especializado em eventos corporativos",
        "payment_methods":"Cartão de crédito, Dinheiro"
    }
]
```
#### get "/api/v1/buffets/#{buffet.id}/buffet_types"
- Retorna uma lista de tipos de buffet de um buffet identificado pelo id
- Exemplo de resposta:
```json
[
    {
        "id":1,
        "name":"Casamento",
        "description":"Casamento com comida",
        "max_capacity_people":10,
        "min_capacity_people":5,
        "duration":120,
        "menu":"Comida caseira e doce",
        "alcoholic_beverages":true,
        "decoration":true,
        "parking_valet":true,
        "exclusive_address":true,
        "buffet_id":1
    }
]
```
#### get "/api/v1/buffets/#{buffet.id}/buffet_types/#{buffet_type.id}/available?date=#{date}&number_of_guests=#{date}"
- Retorna o preço de um evento de um tipo de buffet, é necessário informar o id do buffete do tipo de buffet, além da data desejada e a quantidade de pessoas
- Exemplo de resposta:
```json
{
    "price":20
}
```

### Como rodar
#### Testado no linux usando:
- ruby 3.3.0 
- Rails 7.1.3.2
#### Guia rápido de instalação
1. Instale Ruby na seu computador [here](https://www.ruby-lang.org/en/documentation/installation/).

2. Clone e abra o diretório do projeto

3. Rode ```bundle install``` para instalar as depedências.

4. Prepare a db com ```rails db:reset```

5. Popule a db com ```rails db:seeds```
   
6. Inicie o servidor com ```rails server```, ele normalmente executará em `http://127.0.0.1:3000`

#### Testes:
1. Os testes podem ser executados com o comando ```rspec```

