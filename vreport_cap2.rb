require_relative "vhelperSites.rb"
require_relative "vhelperTabelas.rb"
require_relative "vhelperFicheiros.rb"

class ReportChapter2

  def initialize(tipos, num_coluna, ficheiros)
    @tipos = tipos
    @num_coluna = num_coluna
    @ficheiros = ficheiros
  end

  def self.ficheiros_a_concatenar
    Dir.glob("ficheiros gerados/1.4_site_trimestral*.csv")
  end

  def nome_ficheiro_gerar
    "report/cap_2_#{@tipos}.csv"
  end

  def prepara_colunas_ref
    dados = Ficheiro.leitura("#{@ficheiros[0]}", 0)
    colunas_ref = []
    linha = []
    linha.push(dados[0][0])
    colunas_ref.push(linha)
    for i in 1...dados.size # Entradas
      linha = []
      linha.push(dados[i][0])
      colunas_ref.push(linha)
    end
    colunas_ref.push(["Total"])
  end

  def prepara_colunas_medicoes(ficheiro)
    dados = Ficheiro.leitura(ficheiro, 0)
    for i in 0...dados.size
      dados[i].shift
    end
    indicadores =  @num_coluna
    colunas = []
    linha = []
    linha.push(dados[0][@num_coluna])
    colunas.push(linha)
    for i in 1...dados.size
      linha = []
      linha.push(dados[i][@num_coluna].sub(/,/,".").to_f.round(2))
      colunas.push(linha)
    end
    colunas = Tabelas.calcula_soma_colunas(colunas, 0)
  end

  def concatena_todas_tabelas
    colunas_ref = prepara_colunas_ref
    num_colunas_ref = colunas_ref[0].size
    tabela = Array.new(colunas_ref)
    for num_ficheiros in 0...@ficheiros.size
      colunas_medicoes = prepara_colunas_medicoes(@ficheiros[num_ficheiros])
      for i in 0...colunas_ref.size
        tabela[i].concat(colunas_medicoes[i])
      end
    end
    tabela = Tabelas.calcula_soma_linhas(tabela, 1)
    Ficheiro.cria_csv(tabela, nome_ficheiro_gerar, num_colunas_ref)
  end
end

def corre_vcap_2
  ficheiros = ReportChapter2.ficheiros_a_concatenar
  nomes = Sites.categorias_medicao
  for i in 0...nomes.size
    nome = nomes[i]
    nome = ReportChapter2.new(nomes[i],i,ficheiros)
    nome.concatena_todas_tabelas
    status_progress = (((i+1).to_f/nomes.size)*100).round(0)
    puts "status..#{status_progress}%"
  end
end

#corre_vcap_2
