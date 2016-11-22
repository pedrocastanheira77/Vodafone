require_relative "vglobais.rb"
require_relative "vsites.rb"
require_relative "vsitesmes.rb"
require_relative "vtarifas.rb"
require_relative "vtarifasmes.rb"
require_relative "vfuncoes.rb"

system "cls"
lineWidth = 15

#### Procura na diretoria os ficheiros que vai utilizar ################################################
ficheiroswm = corre_vfiles
puts "Files".ljust(lineWidth) + "ok (100%)".rjust(lineWidth)

#### Gera ficheiros com os consumos globais ################################################
corre_vglobais(ficheiroswm[0], ficheiroswm[1], ficheiroswm[2])
puts "Globais".ljust(lineWidth) + "ok (100%)".rjust(lineWidth)

#### Gera ficheiros com os consumos por site ################################################
corre_vsites
puts "Sites".ljust(lineWidth) + "ok (100%)".rjust(lineWidth)

#### Gera ficheiros com os consumos mensais por site ################################################
corre_vsitesmes
puts "Sites por mes".ljust(lineWidth) + "ok (100%)".rjust(lineWidth)

#### Gera ficheiros com os custos por site ################################################
corre_vtarifas
puts "Custos por site".ljust(lineWidth) + "ok (100%)".rjust(lineWidth)

#### Gera ficheiros com os custos mensais por site ################################################
corre_vtarifasmes
puts "Custos por site por mês".ljust(lineWidth) + "ok (100%)".rjust(lineWidth)