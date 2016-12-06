require_relative "vhelperTarifarios.rb"
require_relative "vhelperSites.rb"

sites = Sites.lista_sites
sites_bte = []
sites_mt = []
for i in 0...sites.size
  site = PeriodosHorarios.new(sites[i])
  tarifa = site.cria_tarifa_site
  sites_bte.push(sites[i]) if tarifa[2][1].include? "BTE"
  sites_mt.push(sites[i]) if tarifa[2][1].include? "MT"
end

p sites_bte
p sites_mt
