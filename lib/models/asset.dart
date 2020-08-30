enum AssetType { RF, RV, TD }

class Asset {
  AssetType tipo;
  String nome;
  List<Price> precos;

  Asset({this.tipo, this.nome, this.precos});

  Asset.fromJson(Map<String, dynamic> json) {
    tipo = json['tipo'];
    nome = json['nome'];
    if (json['precos'] != null) {
      precos = new List<Price>();
      json['precos'].forEach((v) {
        precos.add(new Price.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tipo'] = this.tipo;
    data['nome'] = this.nome;
    if (this.precos != null) {
      data['precos'] = this.precos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Price {
  double valor;
  DateTime data;

  Price({this.valor, this.data});

  Price.fromJson(Map<String, dynamic> json) {
    valor = json['valor'];
    data = DateTime.parse(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valor'] = this.valor;
    data['data'] = this.data;
    return data;
  }
}