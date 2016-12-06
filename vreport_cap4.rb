require_relative "vhelperSites.rb"
require_relative "vhelperTabelas.rb"
require_relative "vhelperFicheiros.rb"

class ReportChapter4

  @@dados = []

  def initialize(lista_sites, categorias, capitulo)
    @lista_sites = lista_sites
    @categorias = categorias
    @capitulo = capitulo
  end

  def nome_ficheiro_gerar
    "report/cap_#{@capitulo}_#{@categorias}.csv"
  end

  def self.ficheiros_a_concatenar
    Dir.glob("ficheiros gerados/1.3_site_mensal*.csv")
  end

  def self.prepara_informacao
    ficheiros = ReportChapter4.ficheiros_a_concatenar
    for i in 0...ficheiros.size
      @@dados[i] = Ficheiro.leitura(ficheiros[i], 0)
    end
  end

  def consumo_mensal
    j = 1 if @categorias == "global"
    j = 2 if @categorias == "avac"
    j = 3 if @categorias == "it"
    tabela = Tabelas.meses
    for ficheiro in 0...@@dados.size
      coluna = []
      for i in 0...@@dados[ficheiro].size
        coluna.push([@@dados[ficheiro][i][j]]) if i == 0
        coluna.push([@@dados[ficheiro][i][j].to_f]) if i != 0
        tabela[i].concat(coluna[i])
      end
    end
    tabela = Tabelas.calcula_soma_linhas(tabela, 1)

    coluna_consumo_dia = [["CONSUMO POR DIA"]]
    dias = Tabelas.dias_mes
    for i in 1...tabela.size
      consumo_dia = tabela[i][-1]/dias[i][0]
      coluna_consumo_dia.push([consumo_dia])
    end
    tabela = Tabelas.concatenacao_tabs(tabela, coluna_consumo_dia)

    coluna_acumulados = [["ACUMULADO"]]
    acumulado = 0
    for i in 1...tabela.size
      acumulado += tabela[i][-2]
      coluna_acumulados.push([acumulado])
    end
    tabela = Tabelas.concatenacao_tabs(tabela, coluna_acumulados)
    Ficheiro.cria_csv(tabela, nome_ficheiro_gerar, 0)
  end
end

def corre_vcap_4
  ReportChapter4.prepara_informacao
  lista_sites = Sites.lista_sites
  categorias = Sites.categorias_medicao
  capitulo = ["4.1", "4.2", "4.3"]
  for i in 0...categorias.size
    categorias[i] = ReportChapter4.new(lista_sites, categorias[i], capitulo[i])
    categorias[i].consumo_mensal
  end
end

corre_vcap_4
