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

