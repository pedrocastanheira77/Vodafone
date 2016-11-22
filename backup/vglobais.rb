require_relative "vfuncoes.rb"

class Globais
  def initialize(tipo, generico, ficheiros)
    @tipo = tipo
    @generico = generico
    @ficheiros = ficheiros
  end

  def prepara_colunas_ref
      ficheiro = LeFicheiro.new("#{@ficheiros[0]}", 3)
      dados = ficheiro.leitura
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
    ficheiro = LeFicheiro.new(ficheiro, 3)
    dados = ficheiro.leitura
    for i in 0...dados.size
      6.times do
        dados[i].shift
      end
    end
    indicadores = dados[0].size
    colunas = []
    linha = []

    for j in 0...indicadores
      linha.push(dados[0][j])
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
    tabela = Array.new(colunas_ref)
    for num_ficheiros in 0...@ficheiros.size
      colunas_medicoes = []
      colunas_medicoes = prepara_colunas_medicoes(@ficheiros[num_ficheiros])
        for i in 0...colunas_ref.size
          tabela[i].concat(colunas_medicoes[i])
        end
    end
    EscreveFicheiro.cria_csv(tabela, "ficheiros gerados/1_analise_#{@generico}.csv")
    p "ficheiros gerados/1_analise_#{@generico}.csv => done"
  end

end

def corre_vglobais(fich_globais, fich_avac, fich_it)
  global = Globais.new("global", "consumo_global", fich_globais)
  global.core
  avac = Globais.new("AVAC", "avac", fich_avac)
  avac.core
  it = Globais.new("IT", "it", fich_it)
  it.core
end