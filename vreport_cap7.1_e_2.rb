require_relative "vhelperSites.rb"
require_relative "vhelperTabelas.rb"
require_relative "vhelperFicheiros.rb"

class ReportChapter7

  def initialize(site)
    @site = site
  end

  def self.nome_ficheiro_gerar
    "report/cap_7.2.csv"
  end

  def nome_ficheiro_ler
    "ficheiros gerados/2.2_tarifas_mes_#{@site}.csv"
  end

  def consumo_energia_trimestral
    num_colunas_ref = 0
    dados = Ficheiro.leitura(nome_ficheiro_ler, num_colunas_ref)
    for index in 0...dados[0].size
      break if dados[0][index].include?("Custo Total (eur)")
    end
    cabecalho = [@site]
    tabela = [cabecalho]
    a = 0
    for trimestre in 1..4
      soma = 0
      for i in (a+1)...(a+4)
        acum=[]
        soma += dados[i][index].sub(/,/,".").to_f
        acum.push(soma.round(2))
      end
      tabela.push(acum)
      a = a + 3
      break if a > 9
    end
    tabela = Tabelas.calcula_soma_colunas(tabela, 0)
  end

  def self.concatena_tabelas(tabela_site)
    coluna_ref = Tabelas.trimestres
    num_colunas_ref = coluna_ref[0].size
    tabela = Array.new(coluna_ref)
    for num_sites in 0...tabela_site.size
      tabela = Tabelas.concatenacao_tabs(tabela, tabela_site[num_sites])
    end
    tabela = Tabelas.calcula_soma_linhas(tabela, 1)
    Ficheiro.cria_csv(tabela, nome_ficheiro_gerar, num_colunas_ref)
  end

end

def corre_vcap_71_72
  sites = Sites.lista_sites
  tabela =[]
  for i in 0...sites.size
    nome = "timestral_#{sites[i]}"
    nome = ReportChapter7.new(sites[i])
    tabela[i] = nome.consumo_energia_trimestral
  end
  ReportChapter7.concatena_tabelas(tabela)
end

#corre_vcap_71_72
