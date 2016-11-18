class Info

  def initialize(tipo, generico, ficheiros)
    @tipo = tipo
    @generico = generico
    @ficheiros = ficheiros
  end

  def calcula_linhas
    fileObj = File.open(@ficheiros[0])
    count = fileObj.read.count("\n") - 3     #  3 = linhas do cabeçalho
    fileObj.close
    return count
  end

  def prepara_colunas_ref(ficheiro)
    dados = leituras(ficheiro)
    colunas_ref = []
    for i in 0...calcula_linhas
      linha = []
      for j in 0..4
        linha.push(dados[i][j])
      end
      colunas_ref.push(linha)
    end
    colunas_ref
  end

  def leituras(ficheiro)
    num_leituras = calcula_linhas
    fileObj = File.open(ficheiro)
    3.times do
      fileObj.gets.split("\n")
    end
    linhas=[]
    for i in 0...num_leituras
      entrada = fileObj.gets.split("\n")
      entrada = entrada[0].split(";")
      linhas.push(entrada)
    end
    fileObj.close
    return linhas
  end

  def calculo_numero_de_indicadores(ficheiro)
    colunas = leituras(ficheiro)
    num_colunas = colunas[0].size - 5      # 5 = colunas estáticas - dia mes ano horas minutos
    num_colunas
  end

  def prepara_colunas_medicoes(dados, ficheiro)
    indicadores = calculo_numero_de_indicadores(ficheiro)
    colunas = []
    linha = []
    for j in 5...(5+indicadores)
      linha.push(dados[0][j])
    end
    colunas.push(linha)

    for i in 1...calcula_linhas
      linha = []
      for j in 5...(5+indicadores)
        linha.push(dados[i][j].sub(/,/,".").to_f)
      end
      colunas.push(linha)
    end
    colunas
  end

  def cria_novo_csv(tab, num_colunas_tab)
    num_linhas = calcula_linhas
    File.delete("analise_#{@generico}.csv") if File.exist?("analise_#{@generico}.csv")
    fileObj = File.new("analise_#{@generico}.csv", 'a+')
    File.open("analise_#{@generico}.csv",'a') do |linha|
      for i in 0...num_linhas
        for j in 0...num_colunas_tab-1
          linha.write("#{tab[i][j]};")
        end
        linha.write("#{tab[i][num_colunas_tab-1]}\n")
      end
    end
    fileObj.close
  end

  def core
    num_linhas = calcula_linhas
    colunas_ref = prepara_colunas_ref(@ficheiros[0])
    tab = Array.new(colunas_ref)
    for num_ficheiros in 0...@ficheiros.size
      colunas_medicoes = []
      dados = leituras(@ficheiros[num_ficheiros])
      colunas_medicoes = prepara_colunas_medicoes(dados, @ficheiros[num_ficheiros])
        for i in 0...num_linhas
          tab[i].concat(colunas_medicoes[i])
        end
    end
    num_colunas_tab = tab[0].size
    cria_novo_csv(tab, num_colunas_tab)
  end

end

global = Info.new(
  "global",
  "consumo_global",
  ["ea+_dtcs_K_15_minutes_realtime_with_components_from_2016_04_01_to_2016_09_30.csv", 
  "ea+_omcs_K_15_minutes_realtime_with_components_from_2016_04_01_to_2016_09_30.csv"
  ]
  )
global.core

avac = Info.new(
  "AVAC",
  "avac",
  ["ea+_avac_dtcs_K_15_minutes_realtime_with_components_from_2016_04_01_to_2016_09_30.csv",
  "ea+_avac_omcs_K_15_minutes_realtime_with_components_from_2016_04_01_to_2016_09_30.csv"
  ]
  )
avac.core

it = Info.new(
  "IT",
  "IT",
  ["ea+_it_dtcs_K_15_minutes_realtime_with_components_from_2016_01_01_to_2016_09_30.csv",
  "ea+_it_omcs_K_15_minutes_realtime_with_components_from_2016_01_01_to_2016_09_30.csv"
  ]
  )
it.core