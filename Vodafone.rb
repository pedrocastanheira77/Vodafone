ficheiros_energia_global = [
"ea+_dtcs_K_15_minutes_realtime_with_components_from_2016_04_01_to_2016_09_30.csv",
"ea+_omcs_K_15_minutes_realtime_with_components_from_2016_04_01_to_2016_09_30.csv"
]

ficheiros_AVAC = [
"ea+_avac_dtcs_K_15_minutes_realtime_with_components_from_2016_04_01_to_2016_09_30.csv",
"ea+_avac_omcs_K_15_minutes_realtime_with_components_from_2016_04_01_to_2016_09_30.csv"
]

ALF1P0 = ["EA+ QGD 1 ALF1P0 (KWh)", "EA+ QGD 2 ALF1P0 (KWh)"]
ALF1PMENOS1 = ["EA+ QGD 1 ALF1P-1 (KWh)","EA+ QGD 2 ALF1P-1 (KWh)","EA+ QGD3 ALF1P-1 (KWh)","EA+ QGD4 ALF1P-1 (KWh)"]
ALF2A1 = ["EA+ QGD 1 ALF2A1 (KWh)"]
ALF2A7A8 = ["EA+ Geral ALF2A7+A8 (KWh)"]
BVTP1 = ["EA+ GERAL 1 BVTP1 (KWh)", "EA+ GERAL 2 BVTP1 (KWh)"]
BVTP0 = ["EA+ GERAL 1 BVTP0 (KWh)","EA+ QGD2 BVTP0 (KWh)"]
AVR = ["EA+ GERAL AVR (KWh)"]
CMB =["EA+ GERAL CMB (KWh)"]
FAR = ["EA+ GERAL FAR (KWh)"]
FMC =["EA+ GERAL FMC (KWh)"]
FUN = ["EA+ Q.INV1 FNC (KWh)"]
MAT = ["EA+ GERAL MAT (KWh)"]
PDG = ["EA+ GERAL PDG (KWh)"]
PTM = ["EA+ GERAL PTM (KWh)"]
SNT = ["EA+ GERAL 1 SNT (KWh)", "EA+ GERAL 2 SNT (KWh)"]
RAN = ["EA+ GERAL 1 RAN (KWh)", "EA+ GERAL 2 RAN (KWh)"]

sites = [ALF1P0, ALF1PMENOS1, ALF2A1, ALF2A7A8, BVTP1, BVTP0, AVR, CMB, FAR, FMC, FUN, MAT, PDG, PTM, SNT, RAN]

def calcula_linhas_tab(ficheiro)
  fileObj = File.open(ficheiro)
  count = fileObj.read.count("\n") - 3
  fileObj.close
  return count
end

def leituras(ficheiro)
  num_leituras = calcula_linhas_tab(ficheiro)
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
  num_colunas = colunas[0].size - 5
  num_colunas
end

def prepara_colunas_ref(ficheiros_energia_global)
  dados = leituras(ficheiros_energia_global)
  colunas_ref = []
  for i in 0...calcula_linhas_tab(ficheiros_energia_global)
    linha = []
    for j in 0..4
      linha.push(dados[i][j])
    end
    colunas_ref.push(linha)
  end
  colunas_ref
end

def prepara_colunas_medicoes(dados, ficheiros_energia_global)
  indicadores = calculo_numero_de_indicadores(ficheiros_energia_global)
  colunas = []

  linha = []
  for j in 5...(5+indicadores)
    linha.push(dados[0][j])
  end
  colunas.push(linha)

  for i in 1...calcula_linhas_tab(ficheiros_energia_global)
    linha = []
    for j in 5...(5+indicadores)
      linha.push(dados[i][j].sub(/,/,".").to_f)
    end
    colunas.push(linha)
  end
  colunas
end

def cria_novo_csv(generico, tab, num_linhas, num_colunas_tab)
  File.delete("analise_#{generico}.csv") if File.exist?("analise_#{generico}.csv")
  fileObj = File.new("analise_#{generico}.csv", 'a+')
  File.open("analise_#{generico}.csv",'a') do |linha|
    for i in 0...num_linhas
      for j in 0...num_colunas_tab-1
        linha.write("#{tab[i][j]};")
      end
      linha.write("#{tab[i][num_colunas_tab-1]}\n")
    end
  end
  fileObj.close
end

def core(ficheiro_ref, ficheiros_energia_global)
  generico = "energia_global"
  num_linhas = calcula_linhas_tab(ficheiro_ref)
  colunas_ref = prepara_colunas_ref(ficheiro_ref)
  tab = Array.new(colunas_ref)
  for num_ficheiro in 0...ficheiros_energia_global.size
    colunas_medicoes = []
    dados = leituras(ficheiros_energia_global[num_ficheiro])
    colunas_medicoes = prepara_colunas_medicoes(dados, ficheiros_energia_global[num_ficheiro])
      for i in 0...num_linhas
        tab[i].concat(colunas_medicoes[i])
      end
  end
  num_colunas_tab = tab[0].size
  cria_novo_csv(generico, tab, num_linhas, num_colunas_tab)
end
