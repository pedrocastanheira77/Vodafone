require_relative "vhelperSites.rb"
require_relative "vhelperTabelas.rb"
require_relative "vhelperFicheiros.rb"

class ReportChapter3a

  @@dados = []

  def initialize(ficheiro, capitulo)
    @ficheiro = ficheiro
    @capitulo = capitulo
  end

  def nome_ficheiro_gerar(capitulo, ficheiro)
    "report/cap_#{capitulo}_#{ficheiro}.csv"
  end

  def self.ficheiros_a_concatenar
    Dir.glob("ficheiros gerados/1.3_site_mensal*.csv")
  end

  def self.prepara_informacao
    ficheiros = ReportChapter3a.ficheiros_a_concatenar
    for i in 0...ficheiros.size
      @@dados[i] = Ficheiro.leitura(ficheiros[i], 0)
    end
  end

  def consumos_mes
    tabela = [["MES","TOTAL","AVAC","IT"]]
    for i in 1...@@dados[0].size
      total = 0
      avac = 0
      it = 0
      for site in 0...@@dados.size
        linha_mes = [@@dados[0][i][0]] # recebe mês
        total += @@dados[site][i][1].to_f
        avac += @@dados[site][i][2].to_f
        it += @@dados[site][i][3].to_f
      end
      linha_mes.push(total.round(2),avac.round(2),it.round(2))
      tabela.push(linha_mes)
    end
    Tabelas.calcula_soma_colunas(tabela, 1)
    tabela
  end

  def pue_mes
    tabela = consumos_mes
    tab_pue_total = [["PUE Total"]]
    tab_pue_it = [["PUE IT"]]
    for i in 1...tabela.size
      pue_total = tabela[i][1]/tabela[i][3]
      pue_it = (tabela[i][2]+tabela[i][3]) / tabela[i][3]
      tab_pue_total.push([pue_total.round(2)])
      tab_pue_it.push([pue_it.round(2)])
    end
    tab_pue_total = Tabelas.concatenacao_tabs(Tabelas.meses.push(["Media"]), tab_pue_total)
    tab_pue_it = Tabelas.concatenacao_tabs(Tabelas.meses.push(["Media"]), tab_pue_it)
    Ficheiro.cria_csv(tab_pue_total, nome_ficheiro_gerar(@capitulo[0], @ficheiro[0]), 0)
    Ficheiro.cria_csv(tab_pue_it, nome_ficheiro_gerar(@capitulo[1], @ficheiro[1]), 0)
  end
end

def corre_vcap_3a
  ReportChapter3a.prepara_informacao
  ficheiro = ["total", "it"]
  capitulo = ["3.3", "3.6"]
  ficheiro = ReportChapter3a.new(ficheiro, capitulo)
  ficheiro.pue_mes
end

#corre_vcap_3a
