require_relative "vhelperSites.rb"
require_relative "vhelperTabelas.rb"
require_relative "vhelperFicheiros.rb"

class ReportChapter3

@@dados = []

  def initialize(tipo_site, capitulo, lista_sites, categorias)
    @tipo_site = tipo_site
    @capitulo = capitulo
    @lista_sites = lista_sites
    @categorias = categorias
  end

  def nome_ficheiro_gerar(capitulo, tipo_pue)
    "report/cap_#{capitulo}_#{@tipo_site}_#{tipo_pue}.csv"
  end

  def self.ficheiros_a_concatenar
    Dir.glob("report/cap_2*.csv")
  end

  def self.prepara_informacao
    dados = []
    ficheiros = ReportChapter3.ficheiros_a_concatenar
    for i in 0...ficheiros.size
      dados[i] = Ficheiro.leitura(ficheiros[i], 0)
    end
    total = Array.new(dados[1])
    avac = Array.new(dados[0])
    it = Array.new(dados[2])
    for i in 1..5
      total[i].map! {|x| (x=="#{i} trim" || x == "Total") ? x : x.sub(/,/,".").to_f}
      avac[i].map! {|x| (x=="#{i} trim" || x == "Total") ? x : x.sub(/,/,".").to_f}
      it[i].map! {|x| (x=="#{i} trim" || x == "Total") ? x : x.sub(/,/,".").to_f}
    end
    @@dados.push(total)
    @@dados.push(avac)
    @@dados.push(it)
  end

  def agrupa_tipo_site
    indices_sites = []
    for i in 0...@lista_sites.size
      index = Tabelas.get_index_colunas(@lista_sites[i].upcase, @@dados[0])
      indices_sites.push(index)
    end
    tabela_categorias = []
    tabela = []
    for index_cat in 0...@categorias.size
      tabela = [["Timestre"]]
      tabela[0].concat(@lista_sites)
      for i in 1...@@dados[index_cat].size
        tabela.push(["#{i} Trim"]) if i < 5
        tabela.push(["Total"]) if i == 5
        for j in 0...indices_sites.size
          tabela[i].push(@@dados[index_cat][i][indices_sites[j]])
        end
      end
      tabela = Tabelas.calcula_soma_linhas(tabela, 1)
      tabela[0][-1] = "Media"
      tabela_categorias.push(tabela)
    end
    tabela_categorias
  end

  def pue_trimestral
    if @tipo_site == "total"
      tabela = @@dados
      for i in 0...@@dados.size
         @@dados[i][0][-1] = "Media"
      end
    else
      tabela = agrupa_tipo_site
    end
    total = tabela[0]
    avac = tabela[1]
    it = tabela[2]
    cabecalho = total[0]
    pue_total = [] # iguala-se ao total só para montar o array
    pue_it = [] # iguala-se ao total só para montar o array
    pue_total.push(cabecalho)
    pue_it.push(cabecalho)
    for i in 1..5
      linha = Array.new(cabecalho.size)
      if i < 5
        pue_total.push(["#{i} Trim"])
        pue_it.push(["#{i} Trim"])
      else
        pue_total.push(["Total"])
        pue_it.push(["Total"])
      end
    end
    for i in 1...total.size
      for j in 1...total[0].size
        pue_total[i][j] = (total[i][j]/it[i][j]).round(2)
        pue_it[i][j] = ((avac[i][j]+it[i][j])/it[i][j]).round(2)
      end
    end
    Ficheiro.cria_csv(pue_total, nome_ficheiro_gerar(@capitulo[0],"total"), 1)
    Ficheiro.cria_csv(pue_it, nome_ficheiro_gerar(@capitulo[1],"it"), 1)
  end
end

def corre_vcap_3
  ReportChapter3.prepara_informacao
  tipo_site = ["dtcs","omcs", "total"]
  capitulo = [["3.1", "3.4"], ["3.1", "3.4"], ["3.2", "3.5"]]
  lista_sites = [Sites.dtcs, Sites.omcs]
  categorias = Sites.categorias_medicao
  for i in 0...tipo_site.size
    tipo_site[i] = ReportChapter3.new(tipo_site[i], capitulo[i], lista_sites[i], categorias)
    tipo_site[i].pue_trimestral
  end

end
