class Site

  def initialize(site, ficheiro, indicadores)
    @site = site
    @ficheiro = ficheiro
    @indicadores = indicadores
  end

  def self.indicators_groups_globais
    [
    ["EA+ QGD 1 ALF1P0 (KWh)", "EA+ QGD 2 ALF1P0 (KWh)"],
    ["EA+ QGD 1 ALF1P-1 (KWh)","EA+ QGD 2 ALF1P-1 (KWh)"],
    ["EA+ QGD 1 ALF2A1 (KWh)"],
    ["EA+ Geral ALF2A7+A8 (KWh)"],
    ["EA+ GERAL 1 BVTP1 (KWh)", "EA+ GERAL 2 BVTP1 (KWh)"],
    ["EA+ GERAL 1 BVTP0 (KWh)","EA+ QGD2 BVTP0 (KWh)"],
    ["EA+ GERAL AVR (KWh)"],
    ["EA+ GERAL CMB (KWh)"],
    ["EA+ GERAL FAR (KWh)"],
    ["EA+ GERAL FMC (KWh)"],
    ["EA+ Q.INV1 FNC (KWh)"],
    ["EA+ GERAL MAT (KWh)"],
    ["EA+ GERAL PDG (KWh)"],
    ["EA+ GERAL PTM (KWh)"],
    ["EA+ GERAL 1 SNT (KWh)", "EA+ GERAL 2 SNT (KWh)"],
    ["EA+ GERAL 1 RAN (KWh)", "EA+ GERAL 2 RAN (KWh)"]
    ]
  end
  
  def calcula_linhas
    fileObj = File.open("analise_#{@ficheiro}.csv")
    count = fileObj.read.count("\n")
    fileObj.close
    return count
  end

  def get_index
    fileObj = File.open("analise_#{@ficheiro}.csv")
    cabecalho = fileObj.gets.chomp
    cabecalho = cabecalho.split(";")
    index_table = []
    for i in 0...@indicadores.size
      index_table.push(cabecalho.index(@indicadores[i]))
    end
    index_table
  end

  def prepara_colunas_ref
    num_leituras = calcula_linhas
    dados = leituras
    colunas_ref = []
    for i in 0...num_leituras
      linha = []
      for j in 0..4
        linha.push(dados[i][j])
      end
      colunas_ref.push(linha)
    end
    colunas_ref
  end

  def leituras
    num_leituras = calcula_linhas
    fileObj = File.open("analise_#{@ficheiro}.csv")
    linhas=[]
    for i in 0...num_leituras
      entrada = fileObj.gets.split("\n")
      entrada = entrada[0].split(";")
      linhas.push(entrada)
    end
    fileObj.close
    return linhas
  end

  def prepara_colunas_medicoes
    index_table = get_index
    num_leituras = calcula_linhas
    dados = leituras
    colunas = []
    linha = []
    for j in 0...index_table.size
        index = index_table[j]
        linha.push(dados[0][index])
    end 
    colunas.push(linha)    
    for i in 1...num_leituras 
      linha = []
      for j in 0...index_table.size
        index = index_table[j]
        linha.push(dados[i][index].sub(/,/,".").to_f)
      end  
      colunas.push(linha)
    end    
    colunas
  end

  def cria_novo_csv(tab)
    index_table = get_index
    num_leituras = calcula_linhas
    File.delete("site_#{@site}.csv") if File.exist?("site_#{@site}.csv")
    fileObj = File.new("site_#{@site}.csv", 'a+')
    File.open("site_#{@site}.csv",'a') do |linha|
      for i in 0...num_leituras
        for j in 0...tab[0].size-1
          linha.write("#{tab[i][j]};")
        end
        linha.write("#{tab[i][tab[0].size-1]}\n")
      end
    end
    fileObj.close
  end

  def core
    num_leituras = calcula_linhas
    colunas_ref = prepara_colunas_ref
    tab = Array.new(colunas_ref) 
    colunas_medicoes = prepara_colunas_medicoes
    for i in 0...num_leituras
      tab[i].concat(colunas_medicoes[i])
    end
    cria_novo_csv(tab)
  end

end

sites = ["alf1p0", "alf1pmenos1", "alf2a1", "alf2a7a8", "bvtp1", "bvtp0", "avr", "cmb", "far", "fmc", "fnc", "mat", "pdg", "ptm", "snt", "ran"]
groups = Site.indicators_groups_globais
for i in 0...sites.size
  sites[i] = Site.new(sites[i], "consumo_global", groups[i])
  sites[i].core
end


#EA+ AVAC DTCs (KWh);EA+ AVAC IT ALF1P0 (KWh);EA+ AVAC IT BVTP1 (KWh);EA+ AVAC IT ALF2A1 (KWh);EA+ AVAC IT ALF2A7+A8 (KWh);EA+ AVAC OMCs (KWh);EA+ AVAC PDG (KWh);EA+ AVAC IT ALF1P-1 (KWh);EA+ AVAC IT SNT (KWh);EA+ AVAC CMB (KWh);EA+ AVAC FNC (KWh);EA+ AVAC IT FAR (KWh);EA+ AVAC IT BVTP0 (KWh);EA+ AVAC FMC (KWh);EA+ AVAC RAN (KWh);EA+ AVAC IT PTM (KWh);EA+ AVAC IT MAT (KWh);EA+ AVAC AVR (KWh)




