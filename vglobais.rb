require_relative "vhelperFicheiros.rb"

class Globais
  DATETIME_COLUMNS = 5
  OFFSITE_LINES = 11

  def initialize(tipo, generico, ficheiros)
    @tipo = tipo
    @generico = generico
    @ficheiros = ficheiros
  end

  def prepara_colunas_ref
      dados = Ficheiro.leitura("#{@ficheiros[0]}", OFFSITE_LINES)
      colunas_ref = []
      linha = []
      for j in 0..4 # Cabecalho
        linha.push(dados[0][j])
      end
      colunas_ref.push(linha)
      for i in 1...dados.size # Entradas
        linha = []
        for j in 0..4
          linha.push(dados[i][j]) if (j==0 || j==4)
          linha.push(dados[i][j].sub(/,/,".").to_i) if (j == 1 || j==2 || j==3)
        end
        colunas_ref.push(linha)
      end
      colunas_ref
  end

  def prepara_colunas_medicoes(ficheiro)
    dados = Ficheiro.leitura(ficheiro, OFFSITE_LINES)

    # Remove datetime columns
    for i in 0...dados.size
      DATETIME_COLUMNS.times do
        dados[i].shift
      end
    end
    indicadores = dados[0].size
    colunas = []
    linha = []
    for j in 0...indicadores
      j == indicadores-1 ? linha << dados[0][j].strip : linha << dados[0][j]
    end
    colunas.push(linha)
    for i in 1...dados.size
      linha = []
      for j in 0...indicadores
        linha.push(dados[i][j].sub(/,/,".").to_f)
      end
      colunas.push(linha)
    end
    colunas
  end

  def core
    colunas_ref = prepara_colunas_ref
    num_colunas_ref = colunas_ref[0].size
    tabela = Array.new(colunas_ref)
    for num_ficheiros in 0...@ficheiros.size
      colunas_medicoes = []
      colunas_medicoes = prepara_colunas_medicoes(@ficheiros[num_ficheiros])
        for i in 0...colunas_ref.size
          tabela[i].concat(colunas_medicoes[i])
        end
    end
    Ficheiro.cria_csv(tabela, "ficheiros gerados/1.1_analise_#{@generico}.csv", num_colunas_ref)
  end
end

def corre_vglobais(ficheiros)
  categorias = [["TOTAL", "consumo_total", ficheiros[0]],
                ["AVAC", "avac", ficheiros[1]],
                ["IT", "it", ficheiros[2]]]
  for i in 0...categorias.size
    # nome = categorias[i][1]
    nome = Globais.new(categorias[i][0], categorias[i][1], categorias[i][2])
    nome.core
    puts "status..#{(i+1)*100/categorias.size}%"
  end
end

#corre_vglobais
