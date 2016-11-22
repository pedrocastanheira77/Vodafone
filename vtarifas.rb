require_relative "vfuncoes.rb"

class Tarifas
  
  def initialize(site)
    @site = site
  end

  def self.prepara_colunas_ref
      ficheiro = LeFicheiro.new("templates/colunas_ref_tarifarios.csv", 0)
      dados = ficheiro.leitura
      colunas_ref = []

      linha = []
      for j in 0..4
        linha.push(dados[0][j])
      end
      colunas_ref.push(linha)

      for i in 1...dados.size
        linha = []
        for j in 0..4
          linha.push(dados[i][j]) if (j==0 || j==4)
          linha.push(dados[i][j].sub(/,/,".").to_f) if (j == 1 || j==2 || j==3)
        end
        colunas_ref.push(linha)
      end
      colunas_ref
  end

  def prepara_colunas_consumo
    colunas_ref = Tarifas.prepara_colunas_ref
    linhas_colunas_ref = colunas_ref.size
    ficheiro = LeFicheiro.new("ficheiros gerados/2_site_#{@site}.csv", 0)
    dados = ficheiro.leitura
    consumo = []
    consumo = [["EA+ Geral (kWh)"]]
    for i in 1...dados.size
      linha = []
      linha.push(dados[i][5].sub(/,/,".").to_f)
      consumo.push(linha)
    end
    for i in dados.size...linhas_colunas_ref
      consumo.push([0])
    end
    consumo
  end

  def concatena
    colunas_ref = Tarifas.prepara_colunas_ref
    consumo = prepara_colunas_consumo
    tabela = ConcatenaTabelas.concat(colunas_ref, consumo)
  end
  
  def atribuicao_sazonalidade
    tabela = concatena
    sazonalidade = [["Sazonalidade"]]
    for i in 1...tabela.size
      if (tabela[i][2] == 3 && tabela[i][1] < 27)
        sazonalidade.push(["I"])
      elsif (tabela[i][2] == 3 && tabela[i][1] >= 27)
        sazonalidade.push(["V"])
      elsif (tabela[i][2] == 10 && tabela[i][1] < 30)
        sazonalidade.push(["V"])
      elsif (tabela[i][2] == 10 && tabela[i][1] >= 30)
        sazonalidade.push(["I"])
      elsif (tabela[i][2] <= 2 || tabela[i][2] >= 11)
        sazonalidade.push(["I"])
      elsif (tabela[i][2] >= 4 || tabela[i][2] <= 9)
        sazonalidade.push(["V"])
      end
    end
    tabela = ConcatenaTabelas.concat(tabela, sazonalidade)
  end 

  def atribuicao_periodo
    sazonalidade = atribuicao_sazonalidade
    tarifario = PeriodosHorarios.new(@site)
    tarifario = tarifario.cria_tarifa_site
    ciclo = tarifario[1][1]
    periodos = [["Periodo Tarifario"]]
    if ciclo.downcase == "diario"
      matriz = PeriodosHorarios.ciclo_diario
      inverno = matriz[0]
      verao = matriz[1]
      for i in 1...sazonalidade.size
        if sazonalidade[i][6] == "I"
          periodos[i] = ["ponta"]  if inverno[0].include? sazonalidade[i][4]
          periodos[i] = ["cheia"]  if inverno[1].include? sazonalidade[i][4]
          periodos[i] = ["vazio"]  if inverno[2].include? sazonalidade[i][4]
          periodos[i] = ["super-vazio"] if inverno[3].include? sazonalidade[i][4]
        elsif sazonalidade[i][6] == "V"
          periodos[i] = ["ponta"]  if verao[0].include? sazonalidade[i][4]
          periodos[i] = ["cheia"]  if verao[1].include? sazonalidade[i][4]
          periodos[i] = ["vazio"]  if verao[2].include? sazonalidade[i][4]
          periodos[i] = ["super-vazio"] if verao[3].include? sazonalidade[i][4]
        end
      end
   
    elsif ciclo.downcase == "semanal"
      matriz = PeriodosHorarios.ciclo_semanal
      dias_uteis = ["Mon","Tue","Wed","Thu","Fri"]
      inverno_dias_uteis = matriz[0][0]
      inverno_dias_sab = matriz[0][1]
      inverno_dias_dom = matriz[0][2]
      verao_dias_uteis = matriz[1][0]
      verao_dias_sab = matriz[1][1]
      verao_dias_dom = matriz[1][2]

     for i in 1...sazonalidade.size
        if (sazonalidade[i][6] == "I") && (dias_uteis.include? sazonalidade[i][0])
          periodos[i] = ["ponta"]  if inverno_dias_uteis[0].include? sazonalidade[i][4]
          periodos[i] = ["cheia"]  if inverno_dias_uteis[1].include? sazonalidade[i][4]
          periodos[i] = ["vazio"]  if inverno_dias_uteis[2].include? sazonalidade[i][4]
          periodos[i] = ["super-vazio"] if inverno_dias_uteis[3].include? sazonalidade[i][4]
        elsif (sazonalidade[i][6] == "I") && (sazonalidade[i][0] == "Sat")
          periodos[i] = ["ponta"]  if inverno_dias_sab[0].include? sazonalidade[i][4]
          periodos[i] = ["cheia"]  if inverno_dias_sab[1].include? sazonalidade[i][4]
          periodos[i] = ["vazio"]  if inverno_dias_sab[2].include? sazonalidade[i][4]
          periodos[i] = ["super-vazio"] if inverno_dias_sab[3].include? sazonalidade[i][4]
        elsif (sazonalidade[i][6] == "I") && (sazonalidade[i][0] == "Sun")
          periodos[i] = ["ponta"]  if inverno_dias_dom[0].include? sazonalidade[i][4]
          periodos[i] = ["cheia"]  if inverno_dias_dom[1].include? sazonalidade[i][4]
          periodos[i] = ["vazio"]  if inverno_dias_dom[2].include? sazonalidade[i][4]
          periodos[i] = ["super-vazio"] if inverno_dias_dom[3].include? sazonalidade[i][4]

        elsif (sazonalidade[i][6] == "V") && (dias_uteis.include? sazonalidade[i][0])
          periodos[i] = ["ponta"]  if verao_dias_uteis[0].include? sazonalidade[i][4]
          periodos[i] = ["cheia"]  if verao_dias_uteis[1].include? sazonalidade[i][4]
          periodos[i] = ["vazio"]  if verao_dias_uteis[2].include? sazonalidade[i][4]
          periodos[i] = ["super-vazio"] if verao_dias_uteis[3].include? sazonalidade[i][4]
        elsif (sazonalidade[i][6] == "V") && (sazonalidade[i][0] == "Sat")
          periodos[i] = ["ponta"]  if verao_dias_sab[0].include? sazonalidade[i][4]
          periodos[i] = ["cheia"]  if verao_dias_sab[1].include? sazonalidade[i][4]
          periodos[i] = ["vazio"]  if verao_dias_sab[2].include? sazonalidade[i][4]
          periodos[i] = ["super-vazio"] if verao_dias_sab[3].include? sazonalidade[i][4]
        elsif (sazonalidade[i][6] == "V") && (sazonalidade[i][0] == "Sun")
          periodos[i] = ["ponta"]  if verao_dias_dom[0].include? sazonalidade[i][4]
          periodos[i] = ["cheia"]  if verao_dias_dom[1].include? sazonalidade[i][4]
          periodos[i] = ["vazio"]  if verao_dias_dom[2].include? sazonalidade[i][4]
          periodos[i] = ["super-vazio"] if verao_dias_dom[3].include? sazonalidade[i][4]
        end
      end
          
    end
    tabela = ConcatenaTabelas.concat(sazonalidade, periodos)
  end

  def atribuicao_custo
    periodos = atribuicao_periodo
    tarifario = PeriodosHorarios.new(@site)
    tarifario = tarifario.cria_tarifa_site
    custos = [["Energia", "Energia Redes"]]
    for i in 1...periodos.size
      if periodos[i][6] == "I" && periodos[i][7] == "ponta"
        custos[i] = [tarifario[6][1], tarifario[11][1]]
      elsif periodos[i][6] == "I" && periodos[i][7] == "cheia"
        custos[i] = [tarifario[7][1], tarifario[13][1]]
      elsif periodos[i][6] == "I" && periodos[i][7] == "vazio"
        custos[i] = [tarifario[8][1], tarifario[15][1]]
      elsif periodos[i][6] == "I" && periodos[i][7] == "super-vazio"
        custos[i] =  [tarifario[9][1], tarifario[17][1]]
      elsif periodos[i][6] == "V" && periodos[i][7] == "ponta"
        custos[i] = [tarifario[6][1], tarifario[10][1]]
      elsif periodos[i][6] == "V" && periodos[i][7] == "cheia"
        custos[i] = [tarifario[7][1], tarifario[12][1]]
      elsif periodos[i][6] == "V" && periodos[i][7] == "vazio"
        custos[i] = [tarifario[8][1], tarifario[14][1]]
      elsif periodos[i][6] == "V" && periodos[i][7] == "super-vazio"
        custos[i] = [tarifario[9][1], tarifario[16][1]]
      end
    end
    tabela = ConcatenaTabelas.concat(periodos, custos)
  end

  def calcula_custo
    custos_unitarios = atribuicao_custo
    soma = [["Energia Total", "Energia Redes Total", "Total"]]
    for i in 1...custos_unitarios.size
      soma_energia = custos_unitarios[i][5] * custos_unitarios[i][8]
      soma_redes = custos_unitarios[i][5] * custos_unitarios[i][9]
      total = soma_energia + soma_redes
      soma[i] = [soma_energia.round(2), soma_redes.round(2), total.round(2)]
    end
    tabela = ConcatenaTabelas.concat(custos_unitarios, soma)
    EscreveFicheiro.cria_csv(tabela, "ficheiros gerados/4_tarifas_#{@site}.csv")
  end

end

def corre_vtarifas
  sites = ListaSites.lista_sites
  for i in 0...sites.size
    site = sites[i]
    site = Tarifas.new(sites[i])
    site.calcula_custo
    count = (((i.to_f+1)/16)*100).round(0)
    puts "status..#{count}%"
  end
end

