require_relative "vfuncoes.rb"

class ReportCapDois

  def initialize(site)
    @site = site
  end

  def consumo_energia_trimestral # Capitulo 2
    ficheiro = LeFicheiro.new("ficheiros gerados/3_site_mensal_#{@site}.csv", 0)
    dados = ficheiro.leitura
    cabecalho = Array.new(dados[0])
    cabecalho.shift
    cabecalho = ["Trimestre"].concat(cabecalho)
    tabela = [cabecalho]
    a = 0
    for trimestre in 1..4
      soma = Array.new(dados[0].size-1,0)
      for i in (a+1)...(a+4)
        acum=[]
        for j in 1...dados[0].size
          soma[j-1] += dados[i][j].sub(/,/,".").to_f
          acum.push(soma[j-1].round(2))
        end
      end
      tabela.push(acum)
      a = a + 3
      break if a > 9
    end
    tabela
    
    for i in 1..4
      tabela[i] = ["#{i} trim"].concat(tabela[i])
    end
    tabela
    EscreveFicheiro.cria_csv(tabela, "ficheiros gerados/31_site_trimestral_#{@site}.csv")
  end

end

def corre_report
  sites = ["alf1p0",
           "alf1-1",
           "alf2a1",
           "alf2a7a8",
           "bvtp1",
           "bvtp0",
           "avr",
           "cmb",
           "far",
           "fmc",
           "fnc",
           "mat",
           "pdg",
           "ptm",
           "snt",
           "ran"]

  for i in 0...sites.size
    nome = "timestral_#{sites[i]}"
    nome = ReportCapDois.new(sites[i])
    nome.consumo_energia_trimestral
  end
end

corre_report