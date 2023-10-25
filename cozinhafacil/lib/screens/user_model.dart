class User {
  int? id;
  String? username;
  String? password;

  // Construtor da classe User, que permite criar uma instância com valores opcionais
  User({this.id, this.username, this.password});

  // Método para converter um objeto User em um mapa (para armazenamento em banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,           // Chave 'id' mapeada para o valor da propriedade id
      'username': username, // Chave 'username' mapeada para o valor da propriedade username
      'password': password  // Chave 'password' mapeada para o valor da propriedade password
    };
  }

  // Construtor alternativo que cria um objeto User a partir de um mapa
  User.fromMap(Map<String, dynamic> map) {
    id = map['id'] as int;          // Atribui o valor 'id' do mapa à propriedade id
    username = map['username'] as String;  // Atribui o valor 'username' do mapa à propriedade username
    password = map['password'] as String;  // Atribui o valor 'password' do mapa à propriedade password
  }
}