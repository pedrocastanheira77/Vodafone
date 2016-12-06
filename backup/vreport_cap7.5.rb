require_relative "vhelperSites.rb"
require_relative "vhelperTabelas.rb"
require_relative "vhelperFicheiros.rb"

class ReportChapter7c

  @@tabela = [["Categoria", "Valor"]]

  def initialize(site, categoria)
    @site = site
    @categoria = categoria
  end

  def self.nome_ficheiro_gerar(tipo, tipo_contrato)
    "report/cap_7.5_#{tipo_contrato}_#{tipo}.csv"
  end

  def nome_ficheiro_ler
    "ficheiros gerados/2.2_tarifas_mes_#{@site}.csv"
  end

  def custo_trimestral
    num_colunas_ref = 0
    dados = Ficheiro.leitura(nome_ficheiro_ler, num_colunas_ref)
    for index in 0...dados[0].size
      break if dados[0][index].include?(@categoria)
    end
    index
    cabecalho = [@site]
    tabela = [cabecalho]
    a = 0
    for trimestre in 1..4
      soma = 0
      for i in (a+1)...(a+4)
        acum=[]
        soma += (dados[i][index].sub(/,/,".").to_f)
        acum.push(soma.round(2))
      end
      tabela.push(acum)
      a = a + 3
      break if a > 9
    end
    tabela = Tabelas.calcula_soma_colunas(tabela, 0)
  end

  def self.concatena_tabelas(tabela_site, categoria, global)
    coluna_ref = Tabelas.trimestres
    num_colunas_ref = coluna_ref[0].size
    tabela = Array.new(coluna_ref)
    for num_sites in 0...tabela_site.size
      tabela = Tabelas.concatenacao_tabs(tabela, tabela_site[num_sites])
    end
    tabela = Tabelas.calcula_soma_linhas(tabela, 1)
    @@tabela.push([categoria, tabela[-1][-1]])
  end

  def self.cria_tabela
    @@tabela
  end

  def self.limpa_tabela
    @@tabela = [["Categoria", "Valor"]]
  end
end

def corre_vcap_75(tipo, globais, categoria, sites, tipo_contrato)
  tabela = []
  tabela_somatorio = [["Categoria","Valor"]]
  for cat in 0...categoria.size
    colunas = []
    for subcat in 0...categoria[cat].size
      for i in 0...sites.size
        nome = "timestral_#{sites[i]}"
        nome = ReportChapter7c.new(sites[i], categoria[cat][subcat])
        colunas[i] = nome.custo_trimestral
      end
    tabela[cat] = ReportChapter7c.concatena_tabelas(colunas, categoria[cat][subcat], globais[cat])
    end
    tabela = ReportChapter7c.cria_tabela
    tabela = Tabelas.calcula_soma_colunas(tabela, 1)
    tabela_somatorio.push([globais[cat], tabela[-1][-1]])
    ReportChapter7c.limpa_tabela
  end
  tabela_somatorio = Tabelas.calcula_soma_colunas(tabela_somatorio, 1)
  Ficheiro.cria_csv(tabela_somatorio, ReportChapter7c.nome_ficheiro_gerar(tipo,tipo_contrato), 1)
end

def corre_vcap_75_consumo_energia(tipo_contrato, sites)
  tipo = ["Consumo", "Custo"]
  globais = [["Ponta (kWh)", "Cheias (kWh)", "Vazio (kWh)", "Super-Vazio (kWh)"],
             ["Custo Ponta (eur)", "Custo Cheias (eur)", "Custo Vazio (eur)", "Custo Super-Vazio (eur)"]]
  categoria = [[["Consumo Ponta (kWh)"],["Consumo Cheias (kWh)"],["Consumo Vazio (kWh)"],["Consumo Super-Vazio (kWh)"]],
               [["Total Termo Ponta (eur)"],["Custo Cheia (eur)"],["Custo Vazio (eur)"],["Custo Super-Vazio (eur)"]]]
  for i in 0...tipo.size
    corre_vcap_75(tipo[i], globais[i], categoria[i], sites, tipo_contrato)
  end
end

def corre_vcap_75_consumo_energia_por_tensao
  tipo_contrato = ["BTE", "MT"]
  sites = [Sites.sites_por_tipo_tensao[0],Sites.sites_por_tipo_tensao[1]]
  for i in 0...sites.size
    corre_vcap_75_consumo_energia(tipo_contrato[i], sites[i])
  end
end

corre_vcap_75_consumo_energia_por_tensao
