require_relative "vfuncoes.rb"

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
    ["EA+ BVTP0 (KWh)"],
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

  def self.indicators_groups_avac
    [
    ["EA+ AVAC IT ALF1P0 (KWh)"],
    ["EA+ AVAC IT ALF1P-1 (KWh)"],
    ["EA+ AVAC IT ALF2A1 (KWh)"],
    ["EA+ AVAC IT ALF2A7+A8 (KWh)"],
    ["EA+ AVAC IT BVTP1 (KWh)"],
    ["EA+ AVAC IT BVTP0 (KWh)"],
    ["EA+ AVAC AVR (KWh)"],
    ["EA+ AVAC CMB (KWh)"],
    ["EA+ AVAC IT FAR (KWh)"],
    ["EA+ AVAC FMC (KWh)"],
    ["EA+ AVAC FNC (KWh)"],
    ["EA+ AVAC IT MAT (KWh)"],
    ["EA+ AVAC PDG (KWh)"],
    ["EA+ AVAC IT PTM (KWh)"],
    ["EA+ AVAC IT SNT (KWh)"],
    ["EA+ AVAC RAN (KWh)"]
    ]
  end

  def self.indicators_groups_it
    [
    ["EA+ IT ALF1P0 (KWh)"],
    ["EA+ IT ALF1P-1 (KWh)"],
    ["EA+ IT ALF2A1 (KWh)"],
    ["EA+ IT ALF2A7+A8 (KWh)"],
    ["EA+ IT BVTP1 (KWh)"],
    ["EA+ IT BVTP0 (KWh)"],
    ["EA+ IT AVR (KWh)"],
    ["EA+ IT CMB (KWh)"],
    ["EA+ IT FAR (KWh)"],
    ["EA+ IT FMC (KWh)"],
    ["EA+ IT FNC (KWh)"],
    ["EA+ IT MAT (KWh)"],
    ["EA+ IT PDG (KWh)"],
    ["EA+ IT PTM (KWh)"],
    ["EA+ IT SNT (KWh)"],
    ["EA+ IT RAN (KWh)"]
    ]
  end

  def calcula_linhas
    fileObj = File.open("ficheiros gerados/1.1_analise_#{@ficheiro}.csv")
    count = fileObj.read.count("\n")
    fileObj.close
    return count
  end

  def get_index
    fileObj = File.open("ficheiros gerados/1.1_analise_#{@ficheiro}.csv")
    cabecalho = fileObj.gets.chomp
    cabecalho = cabecalho.split(";")
    index_table = []
    for i in 0...@indicadores.size
      index_table.push(cabecalho.index(@indicadores[i]))
    end
    index_table
  end

  def leituras
    num_leituras = calcula_linhas
    fileObj = File.open("ficheiros gerados/1.1_analise_#{@ficheiro}.csv")
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

  def trata_informacao
    tab = prepara_colunas_medicoes
    #if @indicadores.size > 1
      array_soma = []
      array_soma[0] = ["#{@ficheiro.upcase} #{@site.upcase}"]
      for i in 1...tab.size
        linha = []
        res = 0
        for j in 0...tab[0].size
          res += tab[i][j]
        end
        linha.push(res)
        array_soma.push(linha)
      end
      return array_soma
    #elsif @indicadores.size == 1
    #  array_soma = Array.new(tab)
    #  return array_soma
    #end
  end

end

class Contatena

  def initialize(site, pacote_info, ficheiro)
    @site = site
    @pacote_info = pacote_info
    @ficheiro = ficheiro
  end

  def calcula_linhas
    fileObj = File.open("ficheiros gerados/1.1_analise_consumo_total.csv")
    count = fileObj.read.count("\n")
    fileObj.close
    return count
  end

  def leituras_colunas_ref
    num_leituras = calcula_linhas
    fileObj = File.open("ficheiros gerados/1.1_analise_consumo_total.csv")
    linhas=[]
    for i in 0...num_leituras
      entrada = fileObj.gets.split("\n")
      entrada = entrada[0].split(";")
      linhas.push(entrada)
    end
    fileObj.close
    linhas
  end

  def prepara_colunas_ref   # como referência usa-se o ficheiro dos consumos globais para obter as colunas fixas (data, hora, ...)
    num_leituras = calcula_linhas
    dados = leituras_colunas_ref
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

  def cria_novo_csv(tab)
    num_leituras = calcula_linhas
    File.delete("ficheiros gerados/1.2_site_#{@site}.csv") if File.exist?("ficheiros gerados/1.2_site_#{@site}.csv")
    fileObj = File.new("ficheiros gerados/1.2_site_#{@site}.csv", 'a+')
    File.open("ficheiros gerados/1.2_site_#{@site}.csv",'a') do |linha|
      for i in 0...num_leituras
        for j in 0...tab[0].size-1
          linha.write("#{tab[i][j]};")
        end
        linha.write("#{tab[i][tab[0].size-1]}\n")
      end
    end
    fileObj.close
  end

  def concat_all_groups   # Concatenação das tabelas de consumo global, avac e it
    tab = Array.new(@pacote_info[0])
    for i in 0...tab.size
      tab[i].concat(@pacote_info[1][i]).concat(@pacote_info[2][i])
    end
    tab
  end

  def core
    num_leituras = calcula_linhas
    colunas_ref = prepara_colunas_ref
    tab = Array.new(colunas_ref)
    colunas_medicoes = concat_all_groups
    for i in 0...num_leituras
      tab[i].concat(colunas_medicoes[i])
    end
    cria_novo_csv(tab)
  end
end

def corre_vsites
  sites = sites = ListaSites.lista_sites
  groups_globais = Site.indicators_groups_globais
  groups_avac = Site.indicators_groups_avac
  groups_it = Site.indicators_groups_it

  for i in 0...sites.size
    nome = "globais_#{sites[i]}"
    nome = Site.new(sites[i],"consumo_total", groups_globais[i])
    tab_global = nome.trata_informacao

    nome = "avac_#{sites[i]}"
    nome = Site.new(sites[i], "avac", groups_avac[i])
    tab_avac = nome.trata_informacao

    nome = "it_#{sites[i]}"
    nome = Site.new(sites[i], "it", groups_it[i])
    tab_it = nome.trata_informacao

    sites[i] = Contatena.new(sites[i], [tab_global, tab_avac, tab_it], "consumo_total")
    sites[i].core
    count = (((i.to_f+1)/16)*100).round(0)
    puts "status..#{count}%"
  end
end

#corre_vsites
