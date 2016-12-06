require_relative "vfuncoes.rb"

class TarifasMes

  @@acumula_site = []
  @@dados = []
  @@pot_horas_ponta = []
  @@custo_mensal_ativa = []
  @@custo_por_horas_ponta = []
  @@tarifario = []

  def initialize(site)
    @site = site
  end

  def colunas_ref
    colunas_ref = [["Mes"],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],["Total"]]
  end

  def self.le_dados(site)
    ficheiro = LeFicheiro.new("ficheiros gerados/2.1_tarifas_#{site}.csv",0)
    @@dados = ficheiro.leitura
  end

  def self.atribui_tarifario(site)
    tarifario = PeriodosHorarios.new(site)
    @@tarifario = tarifario.cria_tarifa_site
  end


  def custo_mensal_termo_energia
    @@custo_mensal_ativa = [["Custo Mensal (eur)"]]
    for mes in 1..12
      soma =[]
      soma_mes = 0
      for i in 1...@@dados.size
        if @@dados[i][2].sub(/,/,".").to_f == mes
          soma_mes += @@dados[i][12].sub(/,/,".").to_f
        end
      end
      soma.push(soma_mes.round(2))
      @@custo_mensal_ativa.push(soma)
    end
    @@custo_mensal_ativa
  end

  def consumo_horas_ponta
    tabela = [["Consumo Ponta (kWh)"]]
    contador_horas_ponta = [] # para cálculo da potencia em horas de potencia
    for mes in 1..12
      soma =[]
      soma_mes = 0
      contador_mes = []
      for i in 1...@@dados.size
        condicao = (@@dados[i][2].sub(/,/,".").to_f == mes) && (@@dados[i][7] == "ponta")
        if condicao == true
          contador_mes.push(1) if condicao == true
          soma_mes += @@dados[i][5].sub(/,/,".").to_f
        end
      end
      contador_horas_ponta.push(contador_mes.size)
      soma.push(soma_mes.round(2))
      tabela.push(soma)
    end
    return tabela, contador_horas_ponta
  end

  def consumos_periodos
    ponta = consumo_horas_ponta[0]
    cheia = GetConsumoPeriodoTarifario.consumo_periodo_tarifario("Consumo Cheias (kWh)", "cheia", @@dados)
    vazio = GetConsumoPeriodoTarifario.consumo_periodo_tarifario("Consumo Vazio (kWh)", "vazio", @@dados)
    supervazio = GetConsumoPeriodoTarifario.consumo_periodo_tarifario("Consumo Super-Vazio (kWh)", "super-vazio", @@dados)
    return ponta, cheia, vazio, supervazio
  end

  def custo_periodos
    ponta = GetCosts.calcula_custos_periodo("Custo Ponta (eur)", "ponta", @@dados)
    cheia = GetCosts.calcula_custos_periodo("Custo Cheia (eur)", "cheia", @@dados)
    vazio = GetCosts.calcula_custos_periodo("Custo Vazio (eur)", "vazio", @@dados)
    supervazio = GetCosts.calcula_custos_periodo("Custo Super-Vazio (eur)", "super-vazio", @@dados)
    return ponta, cheia, vazio, supervazio
  end

  def potencia_horas_ponta
    dados = consumo_horas_ponta # consumo e número de horas
    tabela = dados[0]
    contador_horas_ponta = dados[1]
    horas_ponta_mensais = []
    contador_horas_ponta.each {|x| horas_ponta_mensais.push(x*15/60)}
    @@pot_horas_ponta = [["Potencia Horas Ponta (kW)"]]
    for i in 1...tabela.size
      entrada = [(tabela[i][0]/horas_ponta_mensais[i-1]).round(2)]
      @@pot_horas_ponta.push(entrada)
    end
    @@pot_horas_ponta
  end

  def potencia_contratada
    indice = GetIndex.linhas("potencia_contratada_kW", @@tarifario)
    tabela = [["Potencia Contratada (kW)"]]
    potencia = @@tarifario[indice][1]
    for mes in 1..12
      if @@custo_mensal_ativa[mes][0] != 0
        tabela.push([potencia])
      else
        tabela.push([0.0])
      end
    end
    tabela
  end

  def custo_potencia_contratada
    indice = GetIndex.linhas("potencia_contratada_valor", @@tarifario)
    valor_unitario = @@tarifario[indice][1]
    potencia = potencia_contratada[1][0]
    tabela = [["Custo Potencia Contratada (eur)"]]
    for mes in 1..12
      if @@custo_mensal_ativa[mes][0] != 0
        valor_mensal = (potencia * valor_unitario).round(2)
        tabela.push([valor_mensal])
      else
        tabela.push([0.0])
      end
    end
    tabela
  end

  def custo_potencia_horas_ponta
    indice = GetIndex.linhas("potencia_horas_ponta", @@tarifario)
    valor_unitario = @@tarifario[indice][1]
    @@custo_por_horas_ponta = [["Custo Potencia Horas Ponta (eur)"]]
    for i in 1...@@pot_horas_ponta.size
      valor = @@pot_horas_ponta[i][0]*valor_unitario
      @@custo_por_horas_ponta.push([valor.round(2)])
    end
    @@custo_por_horas_ponta
  end

  def custo_termo_ponta
    ponta = custo_periodos[0]
    total_ponta = [["Total Termo Ponta (eur)"]]
    for i in 1..12
      total = (ponta[i][0] + @@custo_por_horas_ponta[i][0]).round(2)
      total_ponta.push([total])
    end
    total_ponta
  end

  def concatena_colunas
    print "*Iniciando #{@site}*"
    TarifasMes.le_dados(@site)
    TarifasMes.atribui_tarifario(@site)
    @@custo_mensal_ativa = custo_mensal_termo_energia
    consumo_por_periodo = consumos_periodos
    custo_por_periodo = custo_periodos
    pot_contratada = potencia_contratada
    @@pot_horas_ponta = potencia_horas_ponta
    custo_por_contratada = custo_potencia_contratada
    @@custo_por_horas_ponta = custo_potencia_horas_ponta
    custo_t_ponta = custo_termo_ponta
    colunas_a_concatenar = [pot_contratada,
                            @@pot_horas_ponta,
                            consumo_por_periodo[0],
                            consumo_por_periodo[1],
                            consumo_por_periodo[2],
                            consumo_por_periodo[3],
                            custo_por_contratada,
                            @@custo_por_horas_ponta,
                            custo_por_periodo[0],
                            custo_por_periodo[1],
                            custo_por_periodo[2],
                            custo_por_periodo[3],
                            custo_t_ponta]
    custo_total = [["Custo Total (eur)"]]
    for i in 1..12
      total = (@@custo_mensal_ativa[i][0] + custo_por_contratada[i][0] + @@custo_por_horas_ponta[i][0]).round(2)
      custo_total.push([total])
    end
    colunas_a_concatenar.push(custo_total)

    tabela = colunas_a_concatenar[0]
    for colunas in 1...colunas_a_concatenar.size
      tabela = ConcatenaTabelas.concat(tabela, colunas_a_concatenar[colunas])
    end
    # concatenação tabela do somatório do site
    @@acumula_site = TotalColuna.calcula_acumulado_por_coluna(tabela)
    tabela.push(@@acumula_site)
    tabela = ConcatenaTabelas.concat(colunas_ref, tabela)
    @@acumula_site = []
    num_colunas_ref = colunas_ref[0].size
    EscreveFicheiro.cria_csv(tabela, "ficheiros gerados/2.2_tarifas_mes_#{@site}.csv", num_colunas_ref)
  end
end

def corre_vtarifasmes
  sites = ListaSites.lista_sites
  for i in 0...sites.size
    site = sites[i]
    site = TarifasMes.new(sites[i])
    site.concatena_colunas
    count = (((i.to_f+1)/16)*100).round(0)
    puts "status..#{count}%"
  end
end

#corre_vtarifasmes
