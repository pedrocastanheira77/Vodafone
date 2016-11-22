require_relative "vfuncoes.rb"

class TarifasMes
  
  def initialize(site)
    @site = site
  end
  
  def custo_mensal
    colunas_ref = [["Mes"],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]]
    ficheiro = LeFicheiro.new("ficheiros gerados/4_tarifas_#{@site}.csv",0)
    dados = ficheiro.leitura
    soma = ["Custo Mensal"]
    tabela = [soma]
    for mes in 1..12
      soma =[]
      soma_mes = 0
      for i in 1...dados.size
        if dados[i][2].sub(/,/,".").to_f == mes
          soma_mes += dados[i][12].sub(/,/,".").to_f
        end
      end
      soma.push(soma_mes.round(2))
      tabela.push(soma)
    end
    tabela = ConcatenaTabelas.concat(colunas_ref, tabela)
  end

  def horas_ponta
    colunas_ref = custo_mensal
    ficheiro = LeFicheiro.new("ficheiros gerados/4_tarifas_#{@site}.csv",0)
    dados = ficheiro.leitura
    
    soma = ["Consumo Horas Ponta"]
    tabela = [soma]
    contador_horas_ponta = []
    for mes in 1..12
      soma =[]
      soma_mes = 0
      contador_mes = []
      for i in 1...dados.size
        condicao = (dados[i][2].sub(/,/,".").to_f == mes) && (dados[i][7] == "ponta")
        if condicao == true
          contador_mes.push(1) if condicao == true
          soma_mes += dados[i][5].sub(/,/,".").to_f 
        end
      end
      contador_horas_ponta.push(contador_mes.size)
      soma.push(soma_mes.round(2))
      tabela.push(soma)
    end
    tabela = ConcatenaTabelas.concat(colunas_ref, tabela)
    horas_ponta_mensais = []
    contador_horas_ponta.each {|x| horas_ponta_mensais.push(x*15/60)}
    potencia_horas_ponta = [["Potencia Horas Ponta"]]
    for i in 1...tabela.size
      entrada = [(tabela[i][2] / horas_ponta_mensais[i-1]).round(2)]
      potencia_horas_ponta.push(entrada)
    end
    tabela = ConcatenaTabelas.concat(tabela, potencia_horas_ponta)
    EscreveFicheiro.cria_csv(tabela, "ficheiros gerados/41_tarifas_mes_#{@site}.csv")
  end
end

def corre_vtarifasmes
  sites = ListaSites.lista_sites
  for i in 0...sites.size
    site = sites[i]
    site = TarifasMes.new(sites[i])
    site.horas_ponta
    count = (((i.to_f+1)/16)*100).round(0)
    puts "status..#{count}%"
  end
end



